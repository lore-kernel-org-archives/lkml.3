Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3BGOkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:40:32 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:44828 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3BGOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:40:26 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUV1rrR_8Wx6BFj5=gAATdt=j5wDFt6EPMRi=m7rWH94CQ@mail.gmail.com>
References: <CA+icZUXzh1S2+ZQ8vvPFSN8jXS62kijbAP+83F0hG9emLQzpQw@mail.gmail.com>
	<CA+icZUWQuLe1banpd9qzuvUtSep0GiyQWpu=yjhSao_9qAgaUA@mail.gmail.com>
	<CA+icZUWNXpta6PhVCMvEjZVTgi0H0AC4Ou+ysG+b5PMEF6kxXQ@mail.gmail.com>
	<87ip644bqh.fsf@xmission.com>
	<CA+icZUX=2w-hj8SHy8AG-3gQbmN2XCwx_XCSuJ8Gmp=z0gri9w@mail.gmail.com>
	<CA+icZUV1rrR_8Wx6BFj5=gAATdt=j5wDFt6EPMRi=m7rWH94CQ@mail.gmail.com>
Date: Thu, 7 Feb 2013 15:40:25 +0100
Message-ID: <CA+icZUU23tENcnh=jH9FXk82X=8MUAJAYeZpfDOhnt3MWoLzhQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 7 (fakeroot BROKEN due to SYSV IPC support?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=20cf3068447d6324e504d5236cc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3068447d6324e504d5236cc1
Content-Type: text/plain; charset=UTF-8

On Thu, Feb 7, 2013 at 2:39 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Feb 7, 2013 at 12:52 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Feb 7, 2013 at 12:14 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Sedat Dilek <sedat.dilek@gmail.com> writes:
>>>
>>>> On Thu, Feb 7, 2013 at 11:20 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>> On Thu, Feb 7, 2013 at 10:38 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>>> On Thu, Feb 7, 2013 at 7:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Changes since 20130206:
>>>>>>>
>>>>>>> Removed tree: kvmtool (still present via the tip tree)
>>>>>>>
>>>>>>> The block tree lost its build failure.
>>>>>>>
>>>>>>> The tip tree gained a conflict against the s390 tree.
>>>>>>>
>>>>>>> The kvm tree gained a conflict against Linus' tree.
>>>>>>>
>>>>>>> The tty tree lost its build failure.
>>>>>>>
>>>>>>> The arm-soc tree gained conflicts against the iommu tree.
>>>>>>>
>>>>>>> The signal tree gained a conflict against the s390 tree.
>>>>>>>
>>>>>>> The akpm tree gained a conflict against the kvm tree and lost its build
>>>>>>> failure.
>>>>>>>
>>>>>>> ----------------------------------------------------------------------------
>>>>>>>
>>>>>>
>>>>>> My build-script uses fakeroot and does no more start:
>>>>>>
>>>>>> $ ./scripts/build_linux-next.sh
>>>>>> make options ...... CC=gcc-4.6 -j4
>>>>>> KBUILD_BUILD_USER=sedat.dilek@gmail.com
>>>>>> LOCALVERSION=-next20130207-2-iniza-small
>>>>>> dep-pkg options ... KDEB_PKGVERSION=3.8.0~rc6~next20130207-2~iniza+dileks1
>>>>>> fakeroot, while creating message channels: Invalid argument
>>>>>> This may be due to a lack of SYSV IPC support.
>>>>>> fakeroot: error while starting the `faked' daemon.
>>>>>> kill: usage: kill [-s sigspec | -n signum | -sigspec] pid | jobspec
>>>>>> ... or kill -l [sigspec]
>>>>>>
>>>>>>
>>>>>> Any hints?
>>>>>> ( I could run strace... )
>>>>>>
>>>>>> - Sedat -
>>>>>
>>>>> Attached strace outputs within yesterday's (GOOD) and today's (BAD) Linux-Next.
>>>>>
>>>>> - Sedat -
>>>>
>>>> [ CCing Al and Eric ]
>>>>
>>>> I compared quickly the diff between the -next versions and saw changes
>>>> coming from signal and userns trees.
>>>> ( Sorry for re-attaching the strace outputs. )
>>>
>>> It has been about a week and a half since I have pushed anything into
>>> the userns tree, and I don't have anything ipc related in my tree.
>>> So the reason for the suspicion seems odd.
>>>
>>> The straces are useless because all they show is that fakeroot was
>>> forked, but there is not a trace of fakeroot itself.
>>>
>>> Given the timing my initial suspect would be the idr_preload patches
>>> from Tejun that were merged via Andrew's akpm tree.  I didn't see
>>> anything in there that would kill ipc but that is likely the most recent
>>> touch to the ipc code.
>>>
>>
>> [ CCing Tejun ]
>>
>> Hmm, still stepping in the dark...
>>
>> OK, fakeroot does PRELOADing so your assumption makes sense.
>>
>> How can I trigger fakeroot calls?
>> Here I have...
>> /usr/bin/faked-sysv
>> /usr/bin/faked-tcp
>>
>> I think that is the main commit but I am not sure if I can revert the
>> idr_preload part, otherwise it gets complicated:
>>
>> commit e2802c2defba1e5c88d7d168eb5c66813c86f249
>> "idr: implement idr_preload[_end]() and idr_alloc()"
>>
>> $ grep idr ../Linux-Next-v20130206-VS-v20130207.diff | grep ^'++Applying:'
>> ++Applying: block: fix ext_devt_idr handling
>> ++Applying: idr: fix a subtle bug in idr_get_next()
>> ++Applying: nfsd: idr_destroy() no longer needs idr_remove_all()
>> ++Applying: idr: cosmetic updates to struct / initializer definitions
>> ++Applying: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new()
>> ++Applying: idr: remove _idr_rc_to_errno() hack
>> ++Applying: idr: refactor idr_get_new_above()
>> ++Applying: idr: implement idr_preload[_end]() and idr_alloc()
>> ++Applying: block: convert to idr_alloc()
>> ++Applying: block/loop: convert to idr_alloc()
>> ++Applying: atm/nicstar: convert to idr_alloc()
>> ++Applying: drbd: convert to idr_alloc()
>> ++Applying: dca: convert to idr_alloc()
>> ++Applying: dmaengine: convert to idr_alloc()
>> ++Applying: firewire: convert to idr_alloc()
>> ++Applying: gpio: convert to idr_alloc()
>> ++Applying: drm: convert to idr_alloc()
>> ++Applying: drm/exynos: convert to idr_alloc()
>> ++Applying: drm/i915: convert to idr_alloc()
>> ++Applying: drm/sis: convert to idr_alloc()
>> ++Applying: drm/via: convert to idr_alloc()
>> ++Applying: drm/vmwgfx: convert to idr_alloc()
>> ++Applying: i2c: convert to idr_alloc()
>> ++Applying: IB/core: convert to idr_alloc()
>> ++Applying: IB/amso1100: convert to idr_alloc()
>> ++Applying: IB/cxgb3: convert to idr_alloc()
>> ++Applying: IB/cxgb4: convert to idr_alloc()
>> ++Applying: IB/ehca: convert to idr_alloc()
>> ++Applying: IB/ipath: convert to idr_alloc()
>> ++Applying: IB/mlx4: convert to idr_alloc()
>> ++Applying: IB/ocrdma: convert to idr_alloc()
>> ++Applying: IB/qib: convert to idr_alloc()
>> ++Applying: dm: convert to idr_alloc()
>> ++Applying: memstick: convert to idr_alloc()
>> ++Applying: mfd: convert to idr_alloc()
>> ++Applying: misc/c2port: convert to idr_alloc()
>> ++Applying: misc/tifm_core: convert to idr_alloc()
>> ++Applying: mmc: convert to idr_alloc()
>> ++Applying: mtd: convert to idr_alloc()
>> ++Applying: macvtap: convert to idr_alloc()
>> ++Applying: ppp: convert to idr_alloc()
>> ++Applying: power: convert to idr_alloc()
>> ++Applying: pps: convert to idr_alloc()
>> ++Applying: remoteproc: convert to idr_alloc()
>> ++Applying: rpmsg: convert to idr_alloc()
>> ++Applying: scsi/bfa: convert to idr_alloc()
>> ++Applying: scsi: convert to idr_alloc()
>> ++Applying: target/iscsi: convert to idr_alloc()
>> ++Applying: scsi/lpfc: convert to idr_alloc()
>> ++Applying: thermal: convert to idr_alloc()
>> ++Applying: uio: convert to idr_alloc()
>> ++Applying: vfio: convert to idr_alloc()
>> ++Applying: dlm: convert to idr_alloc()
>> ++Applying: inotify: convert to idr_alloc()
>> ++Applying: ocfs2: convert to idr_alloc()
>> ++Applying: ipc: convert to idr_alloc()
>> ++Applying: cgroup: convert to idr_alloc()
>> ++Applying: events: convert to idr_alloc()
>> ++Applying: posix-timers: convert to idr_alloc()
>> ++Applying: net/9p: convert to idr_alloc()
>> ++Applying: mac80211: convert to idr_alloc()
>> ++Applying: sctp: convert to idr_alloc()
>> ++Applying: nfs4client: convert to idr_alloc()
>>
>> - Sedat -
>>
>> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=e2802c2defba1e5c88d7d168eb5c66813c86f249
>>
>>> Eric
>
> Hi Tejun,
>
> Eric was right that your idr_preload/idr_alloc patches from mmotm-tree
> in Linux-Next (next-20130207) caused that fakeroot crazyness.
>
> I can't say if the whole series is BORKED or the IPC part.
> Changelog in [1] says "compile-tested-only" :-).
>
> commitdiff aebcb5a5f97e6e567bdd1b2651253de073afa572
> "ipc: convert to idr_alloc()"
>

This ^^^^^ seems to be the culprit commit!
I just reverted this one and I could compile my kernels again with fakeroot!

- Sedat -

> Reverting the series let me build my kernels with fakeroot!
>
> Tejun, can you have a look at this?
> Thanks!
>
> Thank you Eric for the hints and sorry for my wrong suspicions.
>
> Please, have a look at the attachments.
>
> Regards,
> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=aebcb5a5f97e6e567bdd1b2651253de073afa572

--20cf3068447d6324e504d5236cc1
Content-Type: text/plain; charset=US-ASCII; 
	name="strace_3.8.0-rc6-next20130207-3-iniza-small.txt"
Content-Disposition: attachment; 
	filename="strace_3.8.0-rc6-next20130207-3-iniza-small.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcw0jne93

ZXhlY3ZlKCIuL3NjcmlwdHMvYnVpbGRfbGludXgtbmV4dC5zaCIsIFsiLi9zY3JpcHRzL2J1aWxk
X2xpbnV4LW5leHQuc2giXSwgWy8qIDQ4IHZhcnMgKi9dKSA9IDAKYnJrKDApICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgID0gMHhiZDkwMDAKYWNjZXNzKCIvZXRjL2xkLnNvLm5vaHdj
YXAiLCBGX09LKSAgICAgID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpt
bWFwKE5VTEwsIDgxOTIsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfQU5P
TllNT1VTLCAtMSwgMCkgPSAweDdmNDZjYWVkYzAwMAphY2Nlc3MoIi9ldGMvbGQuc28ucHJlbG9h
ZCIsIFJfT0spICAgICAgPSAtMSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCm9w
ZW4oIi9ldGMvbGQuc28uY2FjaGUiLCBPX1JET05MWXxPX0NMT0VYRUMpID0gMwpmc3RhdCgzLCB7
c3RfbW9kZT1TX0lGUkVHfDA2NDQsIHN0X3NpemU9OTM4MzgsIC4uLn0pID0gMAptbWFwKE5VTEws
IDkzODM4LCBQUk9UX1JFQUQsIE1BUF9QUklWQVRFLCAzLCAwKSA9IDB4N2Y0NmNhZWM1MDAwCmNs
b3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKYWNjZXNzKCIvZXRjL2xk
LnNvLm5vaHdjYXAiLCBGX09LKSAgICAgID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGly
ZWN0b3J5KQpvcGVuKCIvbGliL3g4Nl82NC1saW51eC1nbnUvbGliYy5zby42IiwgT19SRE9OTFl8
T19DTE9FWEVDKSA9IDMKcmVhZCgzLCAiXDE3N0VMRlwyXDFcMVwwXDBcMFwwXDBcMFwwXDBcMFwz
XDA+XDBcMVwwXDBcMFwyMDBcMzBcMlwwXDBcMFwwXDAiLi4uLCA4MzIpID0gODMyCmZzdGF0KDMs
IHtzdF9tb2RlPVNfSUZSRUd8MDc1NSwgc3Rfc2l6ZT0xODExMTI4LCAuLi59KSA9IDAKbW1hcChO
VUxMLCAzOTI1MjA4LCBQUk9UX1JFQUR8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdS
SVRFLCAzLCAwKSA9IDB4N2Y0NmNhOGZkMDAwCm1wcm90ZWN0KDB4N2Y0NmNhYWIyMDAwLCAyMDkz
MDU2LCBQUk9UX05PTkUpID0gMAptbWFwKDB4N2Y0NmNhY2IxMDAwLCAyNDU3NiwgUFJPVF9SRUFE
fFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDFi
NDAwMCkgPSAweDdmNDZjYWNiMTAwMAptbWFwKDB4N2Y0NmNhY2I3MDAwLCAxNzYyNCwgUFJPVF9S
RUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfQU5PTllNT1VTLCAtMSwg
MCkgPSAweDdmNDZjYWNiNzAwMApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgPSAwCm1tYXAoTlVMTCwgNDA5NiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRF
fE1BUF9BTk9OWU1PVVMsIC0xLCAwKSA9IDB4N2Y0NmNhZWM0MDAwCm1tYXAoTlVMTCwgNDA5Niwg
UFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9BTk9OWU1PVVMsIC0xLCAwKSA9
IDB4N2Y0NmNhZWMzMDAwCm1tYXAoTlVMTCwgNDA5NiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1B
UF9QUklWQVRFfE1BUF9BTk9OWU1PVVMsIC0xLCAwKSA9IDB4N2Y0NmNhZWMyMDAwCmFyY2hfcHJj
dGwoQVJDSF9TRVRfRlMsIDB4N2Y0NmNhZWMzNzAwKSA9IDAKbXByb3RlY3QoMHg3ZjQ2Y2FjYjEw
MDAsIDE2Mzg0LCBQUk9UX1JFQUQpID0gMAptcHJvdGVjdCgweDYxOTAwMCwgNDA5NiwgUFJPVF9S
RUFEKSAgICAgPSAwCm1wcm90ZWN0KDB4N2Y0NmNhZWRlMDAwLCA0MDk2LCBQUk9UX1JFQUQpID0g
MAptdW5tYXAoMHg3ZjQ2Y2FlYzUwMDAsIDkzODM4KSAgICAgICAgICAgPSAwCmdldHBpZCgpICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDIzMzIKcnRfc2lnYWN0aW9uKFNJR0NITEQs
IHsweDQwZjEwMCwgfltSVE1JTiBSVF8xXSwgU0FfUkVTVE9SRVIsIDB4N2Y0NmNhOTMzNGEwfSwg
TlVMTCwgOCkgPSAwCmdldGV1aWQoKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDEw
MDAKYnJrKDApICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMHhiZDkwMDAKYnJr
KDB4YmZhMDAwKSAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMHhiZmEwMDAKZ2V0cHBpZCgp
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMjMyOQpzdGF0KCIvaG9tZS93ZWFyZWZh
bS9zcmMvbGludXgta2VybmVsIiwge3N0X21vZGU9U19JRkRJUnwwNzc1LCBzdF9zaXplPTEyMjg4
LCAuLi59KSA9IDAKc3RhdCgiLiIsIHtzdF9tb2RlPVNfSUZESVJ8MDc3NSwgc3Rfc2l6ZT0xMjI4
OCwgLi4ufSkgPSAwCm9wZW4oIi4vc2NyaXB0cy9idWlsZF9saW51eC1uZXh0LnNoIiwgT19SRE9O
TFkpID0gMwpmY250bCgzLCBGX0RVUEZELCAxMCkgICAgICAgICAgICAgICAgICAgPSAxMApjbG9z
ZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCmZjbnRsKDEwLCBGX1NFVEZE
LCBGRF9DTE9FWEVDKSAgICAgICAgICA9IDAKcnRfc2lnYWN0aW9uKFNJR0lOVCwgTlVMTCwge1NJ
R19ERkwsIFtdLCAwfSwgOCkgPSAwCnJ0X3NpZ2FjdGlvbihTSUdJTlQsIHsweDQwZjEwMCwgfltS
VE1JTiBSVF8xXSwgU0FfUkVTVE9SRVIsIDB4N2Y0NmNhOTMzNGEwfSwgTlVMTCwgOCkgPSAwCnJ0
X3NpZ2FjdGlvbihTSUdRVUlULCBOVUxMLCB7U0lHX0RGTCwgW10sIDB9LCA4KSA9IDAKcnRfc2ln
YWN0aW9uKFNJR1FVSVQsIHtTSUdfREZMLCB+W1JUTUlOIFJUXzFdLCBTQV9SRVNUT1JFUiwgMHg3
ZjQ2Y2E5MzM0YTB9LCBOVUxMLCA4KSA9IDAKcnRfc2lnYWN0aW9uKFNJR1RFUk0sIE5VTEwsIHtT
SUdfREZMLCBbXSwgMH0sIDgpID0gMApydF9zaWdhY3Rpb24oU0lHVEVSTSwge1NJR19ERkwsIH5b
UlRNSU4gUlRfMV0sIFNBX1JFU1RPUkVSLCAweDdmNDZjYTkzMzRhMH0sIE5VTEwsIDgpID0gMApy
ZWFkKDEwLCAiIyEvYmluL3NoXG5cbiMjIyBIRUxQXG4jIDEuIG1ha2UgZGUiLi4uLCA4MTkyKSA9
IDM4NTIKcGlwZShbMywgNF0pICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApjbG9uZShj
aGlsZF9zdGFjaz0wLCBmbGFncz1DTE9ORV9DSElMRF9DTEVBUlRJRHxDTE9ORV9DSElMRF9TRVRU
SUR8U0lHQ0hMRCwgY2hpbGRfdGlkcHRyPTB4N2Y0NmNhZWMzOWQwKSA9IDIzMzMKY2xvc2UoNCkg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApyZWFkKDMsICIvaG9tZS93ZWFyZWZh
bS9zcmMvbGludXgta2VybmVsXG4iLCAxMjgpID0gMzIKcmVhZCgzLCAiIiwgMTI4KSAgICAgICAg
ICAgICAgICAgICAgICAgID0gMAotLS0gU0lHQ0hMRCAoQ2hpbGQgZXhpdGVkKSBAIDAgKDApIC0t
LQpydF9zaWdyZXR1cm4oMHgxMSkgICAgICAgICAgICAgICAgICAgICAgPSAwCmNsb3NlKDMpICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKd2FpdDQoLTEsIFt7V0lGRVhJVEVEKHMp
ICYmIFdFWElUU1RBVFVTKHMpID09IDB9XSwgMCwgTlVMTCkgPSAyMzMzCmNoZGlyKCIvaG9tZS93
ZWFyZWZhbS9zcmMvbGludXgta2VybmVsL2xpbnV4LW5leHQiKSA9IDAKcGlwZShbMywgNF0pICAg
ICAgICAgICAgICAgICAgICAgICAgICAgID0gMApjbG9uZShjaGlsZF9zdGFjaz0wLCBmbGFncz1D
TE9ORV9DSElMRF9DTEVBUlRJRHxDTE9ORV9DSElMRF9TRVRUSUR8U0lHQ0hMRCwgY2hpbGRfdGlk
cHRyPTB4N2Y0NmNhZWMzOWQwKSA9IDIzMzQKY2xvc2UoNCkgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgID0gMApyZWFkKDMsICI0XG4iLCAxMjgpICAgICAgICAgICAgICAgICAgICAgPSAy
Ci0tLSBTSUdDSExEIChDaGlsZCBleGl0ZWQpIEAgMCAoMCkgLS0tCnJ0X3NpZ3JldHVybigweDEx
KSAgICAgICAgICAgICAgICAgICAgICA9IDIKcmVhZCgzLCAiIiwgMTI4KSAgICAgICAgICAgICAg
ICAgICAgICAgID0gMApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAw
CndhaXQ0KC0xLCBbe1dJRkVYSVRFRChzKSAmJiBXRVhJVFNUQVRVUyhzKSA9PSAwfV0sIDAsIE5V
TEwpID0gMjMzNApwaXBlKFszLCA0XSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCmNs
b25lKGNoaWxkX3N0YWNrPTAsIGZsYWdzPUNMT05FX0NISUxEX0NMRUFSVElEfENMT05FX0NISUxE
X1NFVFRJRHxTSUdDSExELCBjaGlsZF90aWRwdHI9MHg3ZjQ2Y2FlYzM5ZDApID0gMjMzNQpjbG9z
ZSg0KSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCnJlYWQoMywgIjNcbiIsIDEy
OCkgICAgICAgICAgICAgICAgICAgICA9IDIKcmVhZCgzLCAiIiwgMTI4KSAgICAgICAgICAgICAg
ICAgICAgICAgID0gMAotLS0gU0lHQ0hMRCAoQ2hpbGQgZXhpdGVkKSBAIDAgKDApIC0tLQpydF9z
aWdyZXR1cm4oMHgxMSkgICAgICAgICAgICAgICAgICAgICAgPSAwCmNsb3NlKDMpICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICA9IDAKd2FpdDQoLTEsIFt7V0lGRVhJVEVEKHMpICYmIFdF
WElUU1RBVFVTKHMpID09IDB9XSwgMCwgTlVMTCkgPSAyMzM1CnBpcGUoWzMsIDRdKSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICA9IDAKY2xvbmUoY2hpbGRfc3RhY2s9MCwgZmxhZ3M9Q0xPTkVf
Q0hJTERfQ0xFQVJUSUR8Q0xPTkVfQ0hJTERfU0VUVElEfFNJR0NITEQsIGNoaWxkX3RpZHB0cj0w
eDdmNDZjYWVjMzlkMCkgPSAyMzM2CmNsb3NlKDQpICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICA9IDAKcmVhZCgzLCAiOFxuIiwgMTI4KSAgICAgICAgICAgICAgICAgICAgID0gMgpyZWFk
KDMsICIiLCAxMjgpICAgICAgICAgICAgICAgICAgICAgICAgPSAwCi0tLSBTSUdDSExEIChDaGls
ZCBleGl0ZWQpIEAgMCAoMCkgLS0tCnJ0X3NpZ3JldHVybigweDExKSAgICAgICAgICAgICAgICAg
ICAgICA9IDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMAp3YWl0
NCgtMSwgW3tXSUZFWElURUQocykgJiYgV0VYSVRTVEFUVVMocykgPT0gMH1dLCAwLCBOVUxMKSA9
IDIzMzYKcGlwZShbMywgNF0pICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApjbG9uZShj
aGlsZF9zdGFjaz0wLCBmbGFncz1DTE9ORV9DSElMRF9DTEVBUlRJRHxDTE9ORV9DSElMRF9TRVRU
SUR8U0lHQ0hMRCwgY2hpbGRfdGlkcHRyPTB4N2Y0NmNhZWMzOWQwKSA9IDIzMzcKY2xvc2UoNCkg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApyZWFkKDMsICIwXG4iLCAxMjgpICAg
ICAgICAgICAgICAgICAgICAgPSAyCnJlYWQoMywgIiIsIDEyOCkgICAgICAgICAgICAgICAgICAg
ICAgICA9IDAKLS0tIFNJR0NITEQgKENoaWxkIGV4aXRlZCkgQCAwICgwKSAtLS0KcnRfc2lncmV0
dXJuKDB4MTEpICAgICAgICAgICAgICAgICAgICAgID0gMApjbG9zZSgzKSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgPSAwCndhaXQ0KC0xLCBbe1dJRkVYSVRFRChzKSAmJiBXRVhJVFNU
QVRVUyhzKSA9PSAwfV0sIDAsIE5VTEwpID0gMjMzNwpwaXBlKFszLCA0XSkgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgPSAwCmNsb25lKGNoaWxkX3N0YWNrPTAsIGZsYWdzPUNMT05FX0NISUxE
X0NMRUFSVElEfENMT05FX0NISUxEX1NFVFRJRHxTSUdDSExELCBjaGlsZF90aWRwdHI9MHg3ZjQ2
Y2FlYzM5ZDApID0gMjMzOApjbG9zZSg0KSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
PSAwCnJlYWQoMywgIi1yYzZcbiIsIDEyOCkgICAgICAgICAgICAgICAgICA9IDUKcmVhZCgzLCAi
IiwgMTI4KSAgICAgICAgICAgICAgICAgICAgICAgID0gMAotLS0gU0lHQ0hMRCAoQ2hpbGQgZXhp
dGVkKSBAIDAgKDApIC0tLQpydF9zaWdyZXR1cm4oMHgxMSkgICAgICAgICAgICAgICAgICAgICAg
PSAwCmNsb3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKd2FpdDQoLTEs
IFt7V0lGRVhJVEVEKHMpICYmIFdFWElUU1RBVFVTKHMpID09IDB9XSwgMCwgTlVMTCkgPSAyMzM4
CnBpcGUoWzMsIDRdKSAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKY2xvbmUoY2hpbGRf
c3RhY2s9MCwgZmxhZ3M9Q0xPTkVfQ0hJTERfQ0xFQVJUSUR8Q0xPTkVfQ0hJTERfU0VUVElEfFNJ
R0NITEQsIGNoaWxkX3RpZHB0cj0weDdmNDZjYWVjMzlkMCkgPSAyMzM5CmNsb3NlKDQpICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKcmVhZCgzLCAibmV4dDIwMTMwMjA3XG4iLCAx
MjgpICAgICAgICAgID0gMTMKcmVhZCgzLCAiIiwgMTI4KSAgICAgICAgICAgICAgICAgICAgICAg
ID0gMAotLS0gU0lHQ0hMRCAoQ2hpbGQgZXhpdGVkKSBAIDAgKDApIC0tLQpydF9zaWdyZXR1cm4o
MHgxMSkgICAgICAgICAgICAgICAgICAgICAgPSAwCmNsb3NlKDMpICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICA9IDAKd2FpdDQoLTEsIFt7V0lGRVhJVEVEKHMpICYmIFdFWElUU1RBVFVT
KHMpID09IDB9XSwgMCwgTlVMTCkgPSAyMzM5CnBpcGUoWzMsIDRdKSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICA9IDAKY2xvbmUoY2hpbGRfc3RhY2s9MCwgZmxhZ3M9Q0xPTkVfQ0hJTERfQ0xF
QVJUSUR8Q0xPTkVfQ0hJTERfU0VUVElEfFNJR0NITEQsIGNoaWxkX3RpZHB0cj0weDdmNDZjYWVj
MzlkMCkgPSAyMzQ0CmNsb3NlKDQpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAK
cmVhZCgzLCAiMy44LjB+cmM2XG4iLCAxMjgpICAgICAgICAgICAgID0gMTAKcmVhZCgzLCAiIiwg
MTI4KSAgICAgICAgICAgICAgICAgICAgICAgID0gMAotLS0gU0lHQ0hMRCAoQ2hpbGQgZXhpdGVk
KSBAIDAgKDApIC0tLQpydF9zaWdyZXR1cm4oMHgxMSkgICAgICAgICAgICAgICAgICAgICAgPSAw
CmNsb3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKd2FpdDQoLTEsIFt7
V0lGRVhJVEVEKHMpICYmIFdFWElUU1RBVFVTKHMpID09IDB9XSwgMCwgTlVMTCkgPSAyMzQ0Cndy
aXRlKDEsICJtYWtlIG9wdGlvbnMgLi4uLi4uIENDPWdjYy00LjYgLSIuLi4sIDExNm1ha2Ugb3B0
aW9ucyAuLi4uLi4gQ0M9Z2NjLTQuNiAtajQgS0JVSUxEX0JVSUxEX1VTRVI9c2VkYXQuZGlsZWtA
Z21haWwuY29tIExPQ0FMVkVSU0lPTj0tbmV4dDIwMTMwMjA3LTMtaW5pemEtc21hbGwKKSA9IDEx
Ngp3cml0ZSgxLCAiZGVwLXBrZyBvcHRpb25zIC4uLiBLREVCX1BLR1ZFUlMiLi4uLCA3NWRlcC1w
a2cgb3B0aW9ucyAuLi4gS0RFQl9QS0dWRVJTSU9OPTMuOC4wfnJjNn5uZXh0MjAxMzAyMDctM35p
bml6YStkaWxla3MxCikgPSA3NQpvcGVuYXQoQVRfRkRDV0QsICIuIiwgT19SRE9OTFl8T19OT05C
TE9DS3xPX0RJUkVDVE9SWXxPX0NMT0VYRUMpID0gMwpnZXRkZW50cygzLCAvKiA1NiBlbnRyaWVz
ICovLCAzMjc2OCkgICAgPSAxODAwCmdldGRlbnRzKDMsIC8qIDAgZW50cmllcyAqLywgMzI3Njgp
ICAgICA9IDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMApzdGF0
KCIvb3B0L2xsdm0vYmluL3JtIiwgMHg3ZmZmNmE5MGEyYzApID0gLTEgRU5PRU5UIChObyBzdWNo
IGZpbGUgb3IgZGlyZWN0b3J5KQpzdGF0KCIvdXNyL2xpYi9saWdodGRtL2xpZ2h0ZG0vcm0iLCAw
eDdmZmY2YTkwYTJjMCkgPSAtMSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCnN0
YXQoIi91c3IvbG9jYWwvc2Jpbi9ybSIsIDB4N2ZmZjZhOTBhMmMwKSA9IC0xIEVOT0VOVCAoTm8g
c3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKc3RhdCgiL3Vzci9sb2NhbC9iaW4vcm0iLCAweDdmZmY2
YTkwYTJjMCkgPSAtMSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCnN0YXQoIi91
c3Ivc2Jpbi9ybSIsIDB4N2ZmZjZhOTBhMmMwKSAgICA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxl
IG9yIGRpcmVjdG9yeSkKc3RhdCgiL3Vzci9iaW4vcm0iLCAweDdmZmY2YTkwYTJjMCkgICAgID0g
LTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpzdGF0KCIvc2Jpbi9ybSIsIDB4
N2ZmZjZhOTBhMmMwKSAgICAgICAgPSAtMSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3Rv
cnkpCnN0YXQoIi9iaW4vcm0iLCB7c3RfbW9kZT1TX0lGUkVHfDA3NTUsIHN0X3NpemU9NTU4ODgs
IC4uLn0pID0gMApjbG9uZShjaGlsZF9zdGFjaz0wLCBmbGFncz1DTE9ORV9DSElMRF9DTEVBUlRJ
RHxDTE9ORV9DSElMRF9TRVRUSUR8U0lHQ0hMRCwgY2hpbGRfdGlkcHRyPTB4N2Y0NmNhZWMzOWQw
KSA9IDIzNDcKd2FpdDQoLTEsIFt7V0lGRVhJVEVEKHMpICYmIFdFWElUU1RBVFVTKHMpID09IDB9
XSwgMCwgTlVMTCkgPSAyMzQ3Ci0tLSBTSUdDSExEIChDaGlsZCBleGl0ZWQpIEAgMCAoMCkgLS0t
CnJ0X3NpZ3JldHVybigweDExKSAgICAgICAgICAgICAgICAgICAgICA9IDIzNDcKc3RhdCgiL29w
dC9sbHZtL2Jpbi9mYWtlcm9vdCIsIDB4N2ZmZjZhOTBhMzIwKSA9IC0xIEVOT0VOVCAoTm8gc3Vj
aCBmaWxlIG9yIGRpcmVjdG9yeSkKc3RhdCgiL3Vzci9saWIvbGlnaHRkbS9saWdodGRtL2Zha2Vy
b290IiwgMHg3ZmZmNmE5MGEzMjApID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0
b3J5KQpzdGF0KCIvdXNyL2xvY2FsL3NiaW4vZmFrZXJvb3QiLCAweDdmZmY2YTkwYTMyMCkgPSAt
MSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCnN0YXQoIi91c3IvbG9jYWwvYmlu
L2Zha2Vyb290IiwgMHg3ZmZmNmE5MGEzMjApID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3Ig
ZGlyZWN0b3J5KQpzdGF0KCIvdXNyL3NiaW4vZmFrZXJvb3QiLCAweDdmZmY2YTkwYTMyMCkgPSAt
MSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCnN0YXQoIi91c3IvYmluL2Zha2Vy
b290Iiwge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTM4OTUsIC4uLn0pID0gMApwaXBl
KFszLCA0XSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCmNsb25lKGNoaWxkX3N0YWNr
PTAsIGZsYWdzPUNMT05FX0NISUxEX0NMRUFSVElEfENMT05FX0NISUxEX1NFVFRJRHxTSUdDSExE
LCBjaGlsZF90aWRwdHI9MHg3ZjQ2Y2FlYzM5ZDApID0gMjM0OApjbG9zZSg0KSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgPSAwCnN0YXQoIi9vcHQvbGx2bS9iaW4vdGVlIiwgMHg3ZmZm
NmE5MGEzMjApID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpzdGF0KCIv
dXNyL2xpYi9saWdodGRtL2xpZ2h0ZG0vdGVlIiwgMHg3ZmZmNmE5MGEzMjApID0gLTEgRU5PRU5U
IChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpzdGF0KCIvdXNyL2xvY2FsL3NiaW4vdGVlIiwg
MHg3ZmZmNmE5MGEzMjApID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpz
dGF0KCIvdXNyL2xvY2FsL2Jpbi90ZWUiLCAweDdmZmY2YTkwYTMyMCkgPSAtMSBFTk9FTlQgKE5v
IHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCnN0YXQoIi91c3Ivc2Jpbi90ZWUiLCAweDdmZmY2YTkw
YTMyMCkgICA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKc3RhdCgiL3Vz
ci9iaW4vdGVlIiwge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTI3MDcyLCAuLi59KSA9
IDAKY2xvbmUoY2hpbGRfc3RhY2s9MCwgZmxhZ3M9Q0xPTkVfQ0hJTERfQ0xFQVJUSUR8Q0xPTkVf
Q0hJTERfU0VUVElEfFNJR0NITEQsIGNoaWxkX3RpZHB0cj0weDdmNDZjYWVjMzlkMCkgPSAyMzQ5
CmNsb3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKY2xvc2UoNDI5NDk2
NzI5NSkgICAgICAgICAgICAgICAgICAgICAgID0gLTEgRUJBREYgKEJhZCBmaWxlIGRlc2NyaXB0
b3IpCndhaXQ0KC0xLCBtYWtlIEtCVUlMRF9TUkM9Cm1ha2VbM106IE5vdGhpbmcgdG8gYmUgZG9u
ZSBmb3IgYGFsbCcuCiAgQ0hLICAgICBpbmNsdWRlL2dlbmVyYXRlZC91YXBpL2xpbnV4L3ZlcnNp
b24uaAogIENISyAgICAgaW5jbHVkZS9nZW5lcmF0ZWQvdXRzcmVsZWFzZS5oCiAgQ0MgICAgICBz
Y3JpcHRzL21vZC9kZXZpY2V0YWJsZS1vZmZzZXRzLnMKICBHRU4gICAgIHNjcmlwdHMvbW9kL2Rl
dmljZXRhYmxlLW9mZnNldHMuaAogIEhPU1RDQyAgc2NyaXB0cy9tb2QvZmlsZTJhbGlhcy5vCiAg
SE9TVExEICBzY3JpcHRzL21vZC9tb2Rwb3N0Cm1ha2VbM106IE5vdGhpbmcgdG8gYmUgZG9uZSBm
b3IgYHJlbG9jcycuCiAgQ0FMTCAgICBzY3JpcHRzL2NoZWNrc3lzY2FsbHMuc2gK
--20cf3068447d6324e504d5236cc1
Content-Type: application/octet-stream; 
	name="3.8.0-rc6-next20130207-3-iniza-small.patch"
Content-Disposition: attachment; 
	filename="3.8.0-rc6-next20130207-3-iniza-small.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcw0jlja2

U2VkYXQgRGlsZWsgKDgpOgogICAgICBrYnVpbGQ6IGRlYi1wa2c6IFRyeSB0byBkZXRlcm1pbmUg
ZGlzdHJpYnV0aW9uCiAgICAgIGtidWlsZDogZGViLXBrZzogQnVtcCB5ZWFyIGluIGRlYmlhbi9j
b3B5cmlnaHQgZmlsZQogICAgICBrYnVpbGQ6IGRlYi1wa2c6IFVwZGF0ZSBnaXQgcmVwb3NpdG9y
eSBVUkwgaW4gZGViaWFuL2NvcHlyaWdodCBmaWxlCiAgICAgIE1lcmdlIHRhZyAnbmV4dC0yMDEz
MDIwNycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvLi4uL25leHQvbGludXgtbmV4dCBpbnRvIExp
bnV4LU5leHQtdjIwMTMwMjA3CiAgICAgIFJldmVydCAiaXBjOiBjb252ZXJ0IHRvIGlkcl9hbGxv
YygpIgogICAgICBNZXJnZSBicmFuY2ggJ2RlYi1wa2ctZml4ZXMnIGludG8gMy44LjAtcmM2LW5l
eHQyMDEzMDIwNy0zLWluaXphLXNtYWxsCiAgICAgIFJldmVydCAiaXBjOiBjb252ZXJ0IHRvIGlk
cl9hbGxvYygpIgogICAgICBNZXJnZSBicmFuY2ggJ3JldmVydC1pZHItaXBjLWZyb20tYWtwbScg
aW50byAzLjguMC1yYzYtbmV4dDIwMTMwMjA3LTMtaW5pemEtc21hbGwKCiBpcGMvdXRpbC5jICAg
ICAgICAgICAgICAgfCAzMCArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0KIHNjcmlwdHMv
cGFja2FnZS9idWlsZGRlYiB8IDE5ICsrKysrKysrKysrKysrKystLS0KIDIgZmlsZXMgY2hhbmdl
ZCwgMzYgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaXBjL3V0
aWwuYyBiL2lwYy91dGlsLmMKaW5kZXggOTFjZTBiYy4uNzRlMWQ5YyAxMDA2NDQKLS0tIGEvaXBj
L3V0aWwuYworKysgYi9pcGMvdXRpbC5jCkBAIC0yNTIsNyArMjUyLDcgQEAgaW50IGlwY19hZGRp
ZChzdHJ1Y3QgaXBjX2lkcyogaWRzLCBzdHJ1Y3Qga2Vybl9pcGNfcGVybSogbmV3LCBpbnQgc2l6
ZSkKIHsKIAlrdWlkX3QgZXVpZDsKIAlrZ2lkX3QgZWdpZDsKLQlpbnQgaWQ7CisJaW50IGlkLCBl
cnI7CiAJaW50IG5leHRfaWQgPSBpZHMtPm5leHRfaWQ7CiAKIAlpZiAoc2l6ZSA+IElQQ01OSSkK
QEAgLTI2MSwyMSArMjYxLDE3IEBAIGludCBpcGNfYWRkaWQoc3RydWN0IGlwY19pZHMqIGlkcywg
c3RydWN0IGtlcm5faXBjX3Blcm0qIG5ldywgaW50IHNpemUpCiAJaWYgKGlkcy0+aW5fdXNlID49
IHNpemUpCiAJCXJldHVybiAtRU5PU1BDOwogCi0JaWRyX3ByZWxvYWQoR0ZQX0tFUk5FTCk7Ci0K
IAlzcGluX2xvY2tfaW5pdCgmbmV3LT5sb2NrKTsKIAluZXctPmRlbGV0ZWQgPSAwOwogCXJjdV9y
ZWFkX2xvY2soKTsKIAlzcGluX2xvY2soJm5ldy0+bG9jayk7CiAKLQlpZCA9IGlkcl9hbGxvYygm
aWRzLT5pcGNzX2lkciwgbmV3LAotCQkgICAgICAgKG5leHRfaWQgPCAwKSA/IDAgOiBpcGNpZF90
b19pZHgobmV4dF9pZCksIDAsCi0JCSAgICAgICBHRlBfTk9XQUlUKTsKLQlpZHJfcHJlbG9hZF9l
bmQoKTsKLQlpZiAoaWQgPCAwKSB7CisJZXJyID0gaWRyX2dldF9uZXdfYWJvdmUoJmlkcy0+aXBj
c19pZHIsIG5ldywKKwkJCQkobmV4dF9pZCA8IDApID8gMCA6IGlwY2lkX3RvX2lkeChuZXh0X2lk
KSwgJmlkKTsKKwlpZiAoZXJyKSB7CiAJCXNwaW5fdW5sb2NrKCZuZXctPmxvY2spOwogCQlyY3Vf
cmVhZF91bmxvY2soKTsKLQkJcmV0dXJuIGlkOworCQlyZXR1cm4gZXJyOwogCX0KIAogCWlkcy0+
aW5fdXNlKys7CkBAIC0zMTEsMTAgKzMwNywxOSBAQCBzdGF0aWMgaW50IGlwY2dldF9uZXcoc3Ry
dWN0IGlwY19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3QgaXBjX2lkcyAqaWRzLAogCQlzdHJ1Y3QgaXBj
X29wcyAqb3BzLCBzdHJ1Y3QgaXBjX3BhcmFtcyAqcGFyYW1zKQogewogCWludCBlcnI7CityZXRy
eToKKwllcnIgPSBpZHJfcHJlX2dldCgmaWRzLT5pcGNzX2lkciwgR0ZQX0tFUk5FTCk7CisKKwlp
ZiAoIWVycikKKwkJcmV0dXJuIC1FTk9NRU07CiAKIAlkb3duX3dyaXRlKCZpZHMtPnJ3X211dGV4
KTsKIAllcnIgPSBvcHMtPmdldG5ldyhucywgcGFyYW1zKTsKIAl1cF93cml0ZSgmaWRzLT5yd19t
dXRleCk7CisKKwlpZiAoZXJyID09IC1FQUdBSU4pCisJCWdvdG8gcmV0cnk7CisKIAlyZXR1cm4g
ZXJyOwogfQogCkBAIC0zNzAsNyArMzc1LDkgQEAgc3RhdGljIGludCBpcGNnZXRfcHVibGljKHN0
cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IGlwY19pZHMgKmlkcywKIHsKIAlzdHJ1Y3Qg
a2Vybl9pcGNfcGVybSAqaXBjcDsKIAlpbnQgZmxnID0gcGFyYW1zLT5mbGc7Ci0JaW50IGVyciA9
IDA7CisJaW50IGVycjsKK3JldHJ5OgorCWVyciA9IGlkcl9wcmVfZ2V0KCZpZHMtPmlwY3NfaWRy
LCBHRlBfS0VSTkVMKTsKIAogCS8qCiAJICogVGFrZSB0aGUgbG9jayBhcyBhIHdyaXRlciBzaW5j
ZSB3ZSBhcmUgcG90ZW50aWFsbHkgZ29pbmcgdG8gYWRkCkBAIC00MDYsNiArNDEzLDkgQEAgc3Rh
dGljIGludCBpcGNnZXRfcHVibGljKHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IGlw
Y19pZHMgKmlkcywKIAl9CiAJdXBfd3JpdGUoJmlkcy0+cndfbXV0ZXgpOwogCisJaWYgKGVyciA9
PSAtRUFHQUlOKQorCQlnb3RvIHJldHJ5OworCiAJcmV0dXJuIGVycjsKIH0KIApkaWZmIC0tZ2l0
IGEvc2NyaXB0cy9wYWNrYWdlL2J1aWxkZGViIGIvc2NyaXB0cy9wYWNrYWdlL2J1aWxkZGViCmlu
ZGV4IGFjYjg2NTAuLjdkN2M5ZDggMTAwNjQ0Ci0tLSBhL3NjcmlwdHMvcGFja2FnZS9idWlsZGRl
YgorKysgYi9zY3JpcHRzL3BhY2thZ2UvYnVpbGRkZWIKQEAgLTE3Miw5ICsxNzIsMjIgQEAgZWxz
ZQogZmkKIG1haW50YWluZXI9IiRuYW1lIDwkZW1haWw+IgogCisjIFRyeSB0byBkZXRlcm1pbmUg
ZGlzdHJpYnV0aW9uCitpZiBbIC1lICQod2hpY2ggbHNiX3JlbGVhc2UpIF07IHRoZW4KKyAgICAg
ICBjb2RlbmFtZT0kKGxzYl9yZWxlYXNlIC0tY29kZW5hbWUgLS1zaG9ydCkKKyAgICAgICBpZiBb
ICIkY29kZW5hbWUiICE9ICIiIF07IHRoZW4KKwkJZGlzdHJpYnV0aW9uPSRjb2RlbmFtZQorICAg
ICAgIGVsc2UKKwkJZGlzdHJpYnV0aW9uPSJVTlJFTEVBU0VEIgorCQllY2hvICJXQVJOSU5HOiBU
aGUgZGlzdHJpYnV0aW9uIGNvdWxkIE5PVCBiZSBkZXRlcm1pbmVkISIKKyAgICAgICBmaQorZWxz
ZQorICAgICAgIGVjaG8gIkhJTlQ6IEluc3RhbGwgbHNiX3JlbGVhc2UgYmluYXJ5LCB0aGlzIGhl
bHBzIHRvIGlkZW50aWZ5IHlvdXIgZGlzdHJpYnV0aW9uISIKK2ZpCisKICMgR2VuZXJhdGUgYSBz
aW1wbGUgY2hhbmdlbG9nIHRlbXBsYXRlCiBjYXQgPDxFT0YgPiBkZWJpYW4vY2hhbmdlbG9nCi1s
aW51eC11cHN0cmVhbSAoJHBhY2thZ2V2ZXJzaW9uKSB1bnN0YWJsZTsgdXJnZW5jeT1sb3cKK2xp
bnV4LXVwc3RyZWFtICgkcGFja2FnZXZlcnNpb24pICRkaXN0cmlidXRpb247IHVyZ2VuY3k9bG93
CiAKICAgKiBDdXN0b20gYnVpbHQgTGludXgga2VybmVsLgogCkBAIC0xODgsMTAgKzIwMSwxMCBA
QCBUaGlzIGlzIGEgcGFja2Fja2VkIHVwc3RyZWFtIHZlcnNpb24gb2YgdGhlIExpbnV4IGtlcm5l
bC4KIFRoZSBzb3VyY2VzIG1heSBiZSBmb3VuZCBhdCBtb3N0IExpbnV4IGZ0cCBzaXRlcywgaW5j
bHVkaW5nOgogZnRwOi8vZnRwLmtlcm5lbC5vcmcvcHViL2xpbnV4L2tlcm5lbAogCi1Db3B5cmln
aHQ6IDE5OTEgLSAyMDA5IExpbnVzIFRvcnZhbGRzIGFuZCBvdGhlcnMuCitDb3B5cmlnaHQ6IDE5
OTEgLSAyMDEzIExpbnVzIFRvcnZhbGRzIGFuZCBvdGhlcnMuCiAKIFRoZSBnaXQgcmVwb3NpdG9y
eSBmb3IgbWFpbmxpbmUga2VybmVsIGRldmVsb3BtZW50IGlzIGF0OgotZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LTIuNi5naXQKK2dp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51
eC5naXQKIAogICAgIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlz
dHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgICAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkK
--20cf3068447d6324e504d5236cc1--

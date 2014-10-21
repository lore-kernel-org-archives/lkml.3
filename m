Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaJUXPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:15:10 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:53865 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJUXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <5446D2D8.2090203@gaast.net>
References: <54347520.3050109@gaast.net>
	<543AA2FE.20105@gaast.net>
	<20141012204032.GA11171@amd>
	<9751497.0fL0kvsyX7@vostro.rjw.lan>
	<20141015111641.GC7792@gaast.net>
	<CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
	<CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
	<543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
Date: Tue, 21 Oct 2014 16:15:07 -0700
X-Google-Sender-Auth: ghuuSWmERpzG9Yqvu2IIrch3lRc
Message-ID: <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0149d1168debf70505f70013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149d1168debf70505f70013
Content-Type: text/plain; charset=UTF-8

On Tue, Oct 21, 2014 at 2:40 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Hello,
>
> Sorry for the delay, finally poked at this again. It looks like the
> no_console_suspend flag was causing troubles, which I didn't really need
> anyway with logging going to my serial port.
>
> This is what I get now on the failing resume:
>
> [  112.879390] PM: resume of devices complete after 2239.905 msecs
> [  112.880068] r8169 0000:07:00.0 eth0: link up
> [  112.880078] Switched to clocksource hpet
> [  116.069248] PM: Finishing wakeup.
> [  116.072574] Restarting tasks ... done.
> [  116.076664] PM: calling nb rcu_pm_notify+0x0/0x60
> [  116.081439] PM: ... nb rcu_pm_notify+0x0/0x60 done
> [  116.086267] PM: calling nb cpu_hotplug_pm_callback+0x0/0x50
> [  116.088526] systemd[1]: Got notification message for unit
> systemd-journald.service
> [  116.099442] PM: ... nb cpu_hotplug_pm_callback+0x0/0x50 done
> [  116.105099] PM: calling nb fw_pm_notify+0x0/0x150
> [  116.109812] PM: ... nb fw_pm_notify+0x0/0x150 done
> [  116.114623] PM: calling nb bsp_pm_callback+0x0/0x50
> [  116.119504] PM: ... nb bsp_pm_callback+0x0/0x50 done
>
> And then nothing, and it's hung. Looks the same to me (apart from the tsc
> issues + hpet switch) as a successful resume:

then it stuck in pm_restore_console()?

Please check attached debut patch.

Thanks

Yinghai

--089e0149d1168debf70505f70013
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_y.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_y.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1jvem5h0

LS0tCiBrZXJuZWwvcG93ZXIvY29uc29sZS5jIHwgICAgOSArKysrKysrKysKIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYva2VybmVsL3Bvd2VyL2NvbnNv
bGUuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9rZXJuZWwvcG93ZXIvY29uc29sZS5j
CisrKyBsaW51eC0yLjYva2VybmVsL3Bvd2VyL2NvbnNvbGUuYwpAQCAtNTEsNiArNTEsNyBAQCB2
b2lkIHBtX3Z0X3N3aXRjaF9yZXF1aXJlZChzdHJ1Y3QgZGV2aWNlCiAJCWlmICh0bXAtPmRldiA9
PSBkZXYpIHsKIAkJCS8qIGFscmVhZHkgcmVnaXN0ZXJlZCwgdXBkYXRlIHJlcXVpcmVtZW50ICov
CiAJCQl0bXAtPnJlcXVpcmVkID0gcmVxdWlyZWQ7CisJCQlkZXZfaW5mbyhkZXYsICJwbV92dF9z
d2l0Y2hfcmVxdWlyZWQoKSB1cGRhdGUgJWRcbiIsIHJlcXVpcmVkKTsKIAkJCWdvdG8gb3V0Owog
CQl9CiAJfQpAQCAtNjEsNiArNjIsNyBAQCB2b2lkIHBtX3Z0X3N3aXRjaF9yZXF1aXJlZChzdHJ1
Y3QgZGV2aWNlCiAKIAllbnRyeS0+cmVxdWlyZWQgPSByZXF1aXJlZDsKIAllbnRyeS0+ZGV2ID0g
ZGV2OworCWRldl9pbmZvKGRldiwgInBtX3Z0X3N3aXRjaF9yZXF1aXJlZCgpIGFkZGVkICVkXG4i
LCByZXF1aXJlZCk7CiAKIAlsaXN0X2FkZCgmZW50cnktPmhlYWQsICZwbV92dF9zd2l0Y2hfbGlz
dCk7CiBvdXQ6CkBAIC04MSw2ICs4Myw3IEBAIHZvaWQgcG1fdnRfc3dpdGNoX3VucmVnaXN0ZXIo
c3RydWN0IGRldmkKIAltdXRleF9sb2NrKCZ2dF9zd2l0Y2hfbXV0ZXgpOwogCWxpc3RfZm9yX2Vh
Y2hfZW50cnkodG1wLCAmcG1fdnRfc3dpdGNoX2xpc3QsIGhlYWQpIHsKIAkJaWYgKHRtcC0+ZGV2
ID09IGRldikgeworCQkJZGV2X2luZm8oZGV2LCAicG1fdnRfc3dpdGNoX3JlcXVpcmVkKCkgcmVt
b3ZlZCAlZFxuIiwgdG1wLT5yZXF1aXJlZCk7CiAJCQlsaXN0X2RlbCgmdG1wLT5oZWFkKTsKIAkJ
CWtmcmVlKHRtcCk7CiAJCQlicmVhazsKQEAgLTEzMSwxMSArMTM0LDE0IEBAIGludCBwbV9wcmVw
YXJlX2NvbnNvbGUodm9pZCkKIAlpZiAoIXBtX3Z0X3N3aXRjaCgpKQogCQlyZXR1cm4gMDsKIAor
CXByX2luZm8oInBtX3ByZXBhcmVfY29uc29sZSgpIGJlZm9yZSBtb3ZlXG4iKTsKIAlvcmlnX2Zn
Y29uc29sZSA9IHZ0X21vdmVfdG9fY29uc29sZShTVVNQRU5EX0NPTlNPTEUsIDEpOwogCWlmIChv
cmlnX2ZnY29uc29sZSA8IDApCiAJCXJldHVybiAxOwogCisJcHJfaW5mbygicG1fcHJlcGFyZV9j
b25zb2xlKCkgYmVmb3JlIHJlZGlyZWN0XG4iKTsKIAlvcmlnX2ttc2cgPSB2dF9rbXNnX3JlZGly
ZWN0KFNVU1BFTkRfQ09OU09MRSk7CisJcHJfaW5mbygicG1fcHJlcGFyZV9jb25zb2xlKCkgZG9u
ZVxuIik7CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTE0NSw3ICsxNTEsMTAgQEAgdm9pZCBwbV9yZXN0
b3JlX2NvbnNvbGUodm9pZCkKIAkJcmV0dXJuOwogCiAJaWYgKG9yaWdfZmdjb25zb2xlID49IDAp
IHsKKwkJcHJfaW5mbygicG1fcmVzdG9yZV9jb25zb2xlKCkgYmVmb3JlIG1vdmVcbiIpOwogCQl2
dF9tb3ZlX3RvX2NvbnNvbGUob3JpZ19mZ2NvbnNvbGUsIDApOworCQlwcl9pbmZvKCJwbV9yZXN0
b3JlX2NvbnNvbGUoKSBiZWZvcmUgcmVkaXJlY3RcbiIpOwogCQl2dF9rbXNnX3JlZGlyZWN0KG9y
aWdfa21zZyk7CisJCXByX2luZm8oInBtX3Jlc3RvcmVfY29uc29sZSgpIGRvbmVcbiIpOwogCX0K
IH0K
--089e0149d1168debf70505f70013--

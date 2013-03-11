Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3CKSoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:44:18 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:59125 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3CKSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130311182655.GB12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
	<1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com>
Date: Mon, 11 Mar 2013 11:44:16 -0700
X-Google-Sender-Auth: P_HdPyB0gI5Fa3iBGfLzA9-AmyE
Message-ID: <CAE9FiQUu-AwKhsAdUautjxduW5a-pxpv8XFY-p1LWSmb-itATg@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d04462e0a68228604d7aa8f94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04462e0a68228604d7aa8f94
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Mar 11, 2013 at 11:26 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Mar 11, 2013 at 10:58:39AM -0700, Yinghai Lu wrote:
>> On Mon, Mar 11, 2013 at 8:02 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >
>> > IOW, wouldn't it be better that crashkernel=X first tries to find
>> > requested amount of memory in lowest memory area available/possible.
>>
>> Yest, that is much better, and user even could stay with old kexec-tools
>> for system that does not tons of memory.
>> And I don't need to mess up with auto setting crashkernel_low or export
>> swiotlb_size() etc.
>>
>> Please check if you are ok with attached one.
>>
> Hi Yinghai,
>
> In mutt your patches are showing as attachment instead of inline. Mutt
> thinks attachment is of type "application/octet-stream". Not sure if
> this is configuration issue on my part or something is going on your
> end.

I sent it via gmail and it only can have attachment instead of inline.

>
> I have few more concerns.
>
> - Are we able to reserve 512MB memory now below 896MB. I remember so
>   far it was broken.

It also depends BIOS memmap layout. some bios put reserved on middle of ram
like just below 512M or just 2G.

>
> - If reserving memory below 896MB fails, we immediately switch to
>   reserving anywhere till MAXMEM. Would it make sense to first try
>   to reserve it below 4G (so that we don't have to worry much about
>   swiotlb or iommu being on).

ok.

Attached again.

Thanks

Yinghai

--f46d04462e0a68228604d7aa8f94
Content-Type: application/octet-stream; name="fix_crashkernel_low_v2.patch"
Content-Disposition: attachment; filename="fix_crashkernel_low_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he5zb9e20

U3ViamVjdDogW1BBVENIXSB4ODYsIGtkdW1wLCA2NGJpdDogVHJ5IGFsbG9jYXRlIGNyYXNoa2Vy
bmVsIHVuZGVyIDg5Nk0gYXQgZmlyc3QKCk9uIDY0Yml0IHN5c3RlbSwgd2UgdHJ5IGFsbG9jYXRl
IGNyYXNoa2VybmVsIGFib3ZlIDRHIGF0IGZpcnN0LAphbmQgZG9lcyBub3Qgc2V0IGxvdyByYW5n
ZSBmb3IgY3Jhc2hrZXJuZWwgaWYgdGhlIHVzZXIgZG9lcyBub3QKc3BlY2lmeSB0aGF0LgoKVGhh
dCBjYXVzZSByZWdyZXNzaW9ucyBvbiBzeXN0ZW0gdGhhdCBkb2VzIG5vdCBzdXBwb3J0IGludGVs
X2lvbW11CnByb3Blcmx5LgoKQ2hhbyBzYWlkIHRoYXQgaGlzIHN5c3RlbSBkb2VzIHdvcmsgd2Vs
bCBvbiAzLjggd2l0aG91dCBleHRyYSBwYXJhbWV0ZXIuCmV2ZW4gaW9tbXUgZG9lcyBub3Qgd29y
ayB3aXRoIGtkdW1wLgoKQ2hhbmdlIHRvIHRyeSB1c2Ugb2xkIDg5Nk0gbGltaXQgYXQgZmlyc3Qg
YW5kIHRoZW4gdHJ5IHRvIGFsbG9jYXRlIGFib3ZlIDRHLgoKQWxzbyB1cGRhdGUga2VybmVsIHBh
cmFtZXRlcnMgdG8gbWFrZSBpdCBjbGVhciB3aGVuIHRoYXQgaXMgbmVlZGVkLgoKLXYyOiB0cnkg
NEcgYmVsb3cgYW5kIGF0IGxhc3QgdHJ5IE1BWE1FTSBhY2NvcmRpbmcgdG8gVml2ZWsuCgpSZXBv
cnRlZC1ieTogV0FORyBDaGFvIDxjaGFvd2FuZ0ByZWRoYXQuY29tPgpTdWdnZXN0ZWQtYnk6IFZp
dmVrIEdveWFsIDx2Z295YWxAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8
eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBEb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJz
LnR4dCB8ICAgMTAgKysrKysrKy0tLQogYXJjaC94ODYva2VybmVsL3NldHVwLmMgICAgICAgICAg
ICAgfCAgIDE1ICsrKysrKysrKysrKysrLQogMiBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9Eb2N1bWVudGF0aW9uL2tlcm5l
bC1wYXJhbWV0ZXJzLnR4dAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9Eb2N1bWVudGF0
aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dAorKysgbGludXgtMi42L0RvY3VtZW50YXRpb24va2Vy
bmVsLXBhcmFtZXRlcnMudHh0CkBAIC01OTYsOSArNTk2LDYgQEAgYnl0ZXMgcmVzcGVjdGl2ZWx5
LiBTdWNoIGxldHRlciBzdWZmaXhlcwogCQkJaXMgc2VsZWN0ZWQgYXV0b21hdGljYWxseS4gQ2hl
Y2sKIAkJCURvY3VtZW50YXRpb24va2R1bXAva2R1bXAudHh0IGZvciBmdXJ0aGVyIGRldGFpbHMu
CiAKLQljcmFzaGtlcm5lbF9sb3c9c2l6ZVtLTUddCi0JCQlbS05MLCB4ODZdIHBhcnRzIHVuZGVy
IDRHLgotCiAJY3Jhc2hrZXJuZWw9cmFuZ2UxOnNpemUxWyxyYW5nZTI6c2l6ZTIsLi4uXVtAb2Zm
c2V0XQogCQkJW0tOTF0gU2FtZSBhcyBhYm92ZSwgYnV0IGRlcGVuZHMgb24gdGhlIG1lbW9yeQog
CQkJaW4gdGhlIHJ1bm5pbmcgc3lzdGVtLiBUaGUgc3ludGF4IG9mIHJhbmdlIGlzCkBAIC02MDYs
NiArNjAzLDEzIEBAIGJ5dGVzIHJlc3BlY3RpdmVseS4gU3VjaCBsZXR0ZXIgc3VmZml4ZXMKIAkJ
CWEgbWVtb3J5IHVuaXQgKGFtb3VudFtLTUddKS4gU2VlIGFsc28KIAkJCURvY3VtZW50YXRpb24v
a2R1bXAva2R1bXAudHh0IGZvciBhbiBleGFtcGxlLgogCisJY3Jhc2hrZXJuZWxfbG93PXNpemVb
S01HXQorCQkJW0tOTCwgeDg2XzY0XSByYW5nZSB1bmRlciA0Ry4gV2hlbiBjcmFzaGtlcm5lbD0g
cmVxdWVzdAorCQkJbW9yZSB0aGFuIDUxMk0sIGtlcm5lbCBhbGxvY2F0ZSBwaHlzaWNhbCBtZW1v
cnkgcmVnaW9uCisJCQlhYm92ZSA0RywgdGhhdCBjYXVzZSBzZWNvbmQga2VybmVsIGNyYXNoIG9u
IHN5c3RlbSB0aGF0CisJCQluZWVkIHN3aW90bGIgbGF0ZXIuIFRoaXMgb25lIGxldCB1c2VyIHRv
IHNwZWNpZnkgZXh0cmEKKwkJCWxvdyByYW5nZSB1bmRlciA0RyBmb3Igc2Vjb25kIGtlcm5lbC4K
KwogCWNzODl4MF9kbWE9CVtIVyxORVRdCiAJCQlGb3JtYXQ6IDxkbWE+CiAKSW5kZXg6IGxpbnV4
LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9z
ZXR1cC5jCkBAIC01MDcsMTEgKzUwNywxMiBAQCBzdGF0aWMgdm9pZCBfX2luaXQgbWVtYmxvY2tf
eDg2X3Jlc2VydmVfCiAvKgogICogS2VlcCB0aGUgY3Jhc2gga2VybmVsIGJlbG93IHRoaXMgbGlt
aXQuICBPbiAzMiBiaXRzIGVhcmxpZXIga2VybmVscwogICogd291bGQgbGltaXQgdGhlIGtlcm5l
bCB0byB0aGUgbG93IDUxMiBNaUIgZHVlIHRvIG1hcHBpbmcgcmVzdHJpY3Rpb25zLgorICogT24g
NjQgYml0cywga2V4ZWMtdG9vbHMgKGJlZm9yZSAyLjAuNCkgbGltaXRzIHVzIHRvIDg5NiBNaUIu
CiAgKi8KICNpZmRlZiBDT05GSUdfWDg2XzMyCiAjIGRlZmluZSBDUkFTSF9LRVJORUxfQUREUl9N
QVgJKDUxMiA8PCAyMCkKICNlbHNlCi0jIGRlZmluZSBDUkFTSF9LRVJORUxfQUREUl9NQVgJTUFY
TUVNCisjIGRlZmluZSBDUkFTSF9LRVJORUxfQUREUl9NQVgJKDg5NiA8PCAyMCkKICNlbmRpZgog
CiBzdGF0aWMgdm9pZCBfX2luaXQgcmVzZXJ2ZV9jcmFzaGtlcm5lbF9sb3codm9pZCkKQEAgLTU3
MSw2ICs1NzIsMTggQEAgc3RhdGljIHZvaWQgX19pbml0IHJlc2VydmVfY3Jhc2hrZXJuZWwodgog
CQljcmFzaF9iYXNlID0gbWVtYmxvY2tfZmluZF9pbl9yYW5nZShhbGlnbm1lbnQsCiAJCQkgICAg
ICAgQ1JBU0hfS0VSTkVMX0FERFJfTUFYLCBjcmFzaF9zaXplLCBhbGlnbm1lbnQpOwogCisjaWZk
ZWYgQ09ORklHX1g4Nl82NAorCQkvKiB0cnkgdW5kZXIgNEcgYXQgZmlyc3QgKi8KKwkJaWYgKCFj
cmFzaF9iYXNlKQorCQkJY3Jhc2hfYmFzZSA9IG1lbWJsb2NrX2ZpbmRfaW5fcmFuZ2UoYWxpZ25t
ZW50LAorCQkJCSAgICAgICAxVUw8PDMyLCBjcmFzaF9zaXplLCBhbGlnbm1lbnQpOworCQkvKiBh
Ym92ZSA0RyBub3cgKi8KKwkJaWYgKCFjcmFzaF9iYXNlKQorCQkJY3Jhc2hfYmFzZSA9IG1lbWJs
b2NrX2ZpbmRfaW5fcmFuZ2UoYWxpZ25tZW50LAorCQkJCSAgICAgICBNQVhNRU0sIGNyYXNoX3Np
emUsIGFsaWdubWVudCk7CisKKyNlbmRpZgorCiAJCWlmICghY3Jhc2hfYmFzZSkgewogCQkJcHJf
aW5mbygiY3Jhc2hrZXJuZWwgcmVzZXJ2YXRpb24gZmFpbGVkIC0gTm8gc3VpdGFibGUgYXJlYSBm
b3VuZC5cbiIpOwogCQkJcmV0dXJuOwo=
--f46d04462e0a68228604d7aa8f94--

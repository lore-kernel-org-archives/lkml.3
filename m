Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3CKTGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:06:08 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:34955 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3CKTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <513E28B8.3000502@zytor.com>
References: <513D52BA.3070206@redhat.com>
	<1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
Date: Mon, 11 Mar 2013 12:06:06 -0700
X-Google-Sender-Auth: 2sQphoRlSDDPkrqFWRY8u8DLUoo
Message-ID: <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=90e6ba539e8670028604d7aadd4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba539e8670028604d7aadd4d
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Mar 11, 2013 at 11:55 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/11/2013 11:50 AM, Yinghai Lu wrote:
>>>
>>> What is the purpose of reserving that kind of memory below 896 MB?  If
>>> you have a 32-bit system, it will likely be useless since you are
>>> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
>>> a magic value in any way...?
>>
>> We did not touch 32 bit system.
>>
>> Do you mean that we should
>> For 64bit, we should try under 4G, and then try MAXMEM
>> instead of try under 896M, then 4G, and MAXMEM?
>>
>> Try 896M at first, we will let user to avoid updating their kexec-tools.
>>
>
> Are you saying 896M is somehow hardcoded into kexec-tools?

yes, before kexec-tools 2.0.4

>
> I actually disagree with trying low memory at all.  Push kdump as high
> into the memory range as we can go, if there is a performance penalty it
> is much better to take it in the kdump kernel.

Agreed, It's better let 64 bit all use one code path.
And we can find more bugs while load them all high.
otherwise it would be hard to fix them if the bugs only happens on systems
that have bunch of dimms.

>
> All the voodoo to try to keep people from updating kexec-tools is
> disturbing; although breaking userspace is bad, updating kexec-tools is
> probably easier than updating the kernel, and carrying the voodoo on
> indefinitely has serious consequences.

Yes.

So please check you are happy with this one. -v3 that set crashkernel_low
automatically.

Thanks

Yinghai

--90e6ba539e8670028604d7aadd4d
Content-Type: application/octet-stream; name="fix_crashkernel_low_v3.patch"
Content-Disposition: attachment; filename="fix_crashkernel_low_v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he6045af0

U3ViamVjdDogW1BBVENIXSB4ODYsIGtkdW1wOiBTZXQgY3Jhc2hrZXJuZWxfbG93IGF1dG9tYXRp
Y2FsbHkKCkN1cnJlbnQgY29kZSBkb2VzIG5vdCBzZXQgbG93IHJhbmdlIGZvciBjcmFzaGtlcm5l
bCBpZiB0aGUgdXNlcgpkb2VzIG5vdCBzcGVjaWZ5IHRoYXQuCgpUaGF0IGNhdXNlIHJlZ3Jlc3Np
b25zIG9uIHN5c3RlbSB0aGF0IGRvZXMgbm90IHN1cHBvcnQgaW50ZWxfaW9tbXUKcHJvcGVybHku
CgpDaGFvIHNhaWQgdGhhdCBoaXMgc3lzdGVtIGRvZXMgd29yayB3ZWxsIG9uIDMuOCB3aXRob3V0
IGV4dHJhIHBhcmFtZXRlci4KZXZlbiBpb21tdSBkb2VzIG5vdCB3b3JrIHdpdGgga2R1bXAuCgpT
ZXQgY3Jhc2hrZXJuZWxfbG93IGF1dG9tYXRpY2FsbHkgaWYgdGhlIHVzZXIgZG9lcyBub3Qgc3Bl
Y2lmeSB0aGF0LgoKRm9yIHN5c3RlbSB0aGF0IGRvZXMgc3VwcG9ydCBJT01NVSB3aXRoIGtkdW1w
IHByb3Blcmx5LCB1c2VyIGNvdWxkCnNwZWNpZnkgY3Jhc2hrZXJuZWxfbG93PTAgdG8gc2F2ZSB0
aGF0IDcyTSBsb3cgcmFtLgoKLXYzOiBhZGQgc3dpb3RsYl9zaXplKCkgYWNjb3JkaW5nIHRvIEtv
bnJhZC4KClJlcG9ydGVkLWJ5OiBXQU5HIENoYW8gPGNoYW93YW5nQHJlZGhhdC5jb20+ClRlc3Rl
ZC1ieTogV0FORyBDaGFvIDxjaGFvd2FuZ0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBZaW5n
aGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGFyY2gveDg2L2tlcm5lbC9zZXR1cC5j
IHwgICAxNSArKysrKysrKysrKystLS0KIGluY2x1ZGUvbGludXgvc3dpb3RsYi5oIHwgICAgMSAr
CiBsaWIvc3dpb3RsYi5jICAgICAgICAgICB8ICAgMTkgKysrKysrKysrKysrKysrLS0tLQogMyBm
aWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxp
bnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYu
b3JpZy9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5l
bC9zZXR1cC5jCkBAIC01MjIsMTkgKzUyMiwyOCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgcmVzZXJ2
ZV9jcmFzaGtlcm5lbF9sCiAJdW5zaWduZWQgbG9uZyBsb25nIGxvd19iYXNlID0gMCwgbG93X3Np
emUgPSAwOwogCXVuc2lnbmVkIGxvbmcgdG90YWxfbG93X21lbTsKIAl1bnNpZ25lZCBsb25nIGxv
bmcgYmFzZTsKKwlib29sIGF1dG9fc2V0ID0gZmFsc2U7CiAJaW50IHJldDsKIAogCXRvdGFsX2xv
d19tZW0gPSBtZW1ibG9ja19tZW1fc2l6ZSgxVUw8PCgzMi1QQUdFX1NISUZUKSk7CiAJcmV0ID0g
cGFyc2VfY3Jhc2hrZXJuZWxfbG93KGJvb3RfY29tbWFuZF9saW5lLCB0b3RhbF9sb3dfbWVtLAog
CQkJCQkJJmxvd19zaXplLCAmYmFzZSk7Ci0JaWYgKHJldCAhPSAwIHx8IGxvd19zaXplIDw9IDAp
Ci0JCXJldHVybjsKKwlpZiAocmV0ICE9IDApIHsKKwkJLyogc3dpb3RsYiBzaXplIGFuZCBldGMg
OE0gKi8KKwkJbG93X3NpemUgPSBzd2lvdGxiX3NpemVfb3JfZGVmYXVsdCgpICsgKDhVTDw8MjAp
OworCQlhdXRvX3NldCA9IHRydWU7CisJfSBlbHNlIHsKKwkJLyogcGFzc2VkIHdpdGggY3Jhc2hr
ZXJuZWxfbG93PTAgPyAqLworCQlpZiAoIWxvd19zaXplKQorCQkJcmV0dXJuOworCX0KIAogCWxv
d19iYXNlID0gbWVtYmxvY2tfZmluZF9pbl9yYW5nZShsb3dfc2l6ZSwgKDFVTEw8PDMyKSwKIAkJ
CQkJbG93X3NpemUsIGFsaWdubWVudCk7CiAKIAlpZiAoIWxvd19iYXNlKSB7Ci0JCXByX2luZm8o
ImNyYXNoa2VybmVsIGxvdyByZXNlcnZhdGlvbiBmYWlsZWQgLSBObyBzdWl0YWJsZSBhcmVhIGZv
dW5kLlxuIik7CisJCWlmICghYXV0b19zZXQpCisJCQlwcl9pbmZvKCJjcmFzaGtlcm5lbCBsb3cg
cmVzZXJ2YXRpb24gZmFpbGVkIC0gTm8gc3VpdGFibGUgYXJlYSBmb3VuZC5cbiIpOwogCiAJCXJl
dHVybjsKIAl9CkluZGV4OiBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9zd2lvdGxiLmgKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvaW5jbHVkZS9saW51eC9zd2lvdGxiLmgKKysrIGxpbnV4
LTIuNi9pbmNsdWRlL2xpbnV4L3N3aW90bGIuaApAQCAtMjUsNiArMjUsNyBAQCBleHRlcm4gaW50
IHN3aW90bGJfZm9yY2U7CiBleHRlcm4gdm9pZCBzd2lvdGxiX2luaXQoaW50IHZlcmJvc2UpOwog
aW50IHN3aW90bGJfaW5pdF93aXRoX3RibChjaGFyICp0bGIsIHVuc2lnbmVkIGxvbmcgbnNsYWJz
LCBpbnQgdmVyYm9zZSk7CiBleHRlcm4gdW5zaWduZWQgbG9uZyBzd2lvdGxiX25yX3RibCh2b2lk
KTsKK3Vuc2lnbmVkIGxvbmcgc3dpb3RsYl9zaXplX29yX2RlZmF1bHQodm9pZCk7CiBleHRlcm4g
aW50IHN3aW90bGJfbGF0ZV9pbml0X3dpdGhfdGJsKGNoYXIgKnRsYiwgdW5zaWduZWQgbG9uZyBu
c2xhYnMpOwogCiAvKgpJbmRleDogbGludXgtMi42L2xpYi9zd2lvdGxiLmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvbGliL3N3aW90bGIuYworKysgbGludXgtMi42L2xpYi9zd2lvdGxi
LmMKQEAgLTEwNSw5ICsxMDUsOSBAQCBzZXR1cF9pb190bGJfbnBhZ2VzKGNoYXIgKnN0cikKIAlp
ZiAoIXN0cmNtcChzdHIsICJmb3JjZSIpKQogCQlzd2lvdGxiX2ZvcmNlID0gMTsKIAotCXJldHVy
biAxOworCXJldHVybiAwOwogfQotX19zZXR1cCgic3dpb3RsYj0iLCBzZXR1cF9pb190bGJfbnBh
Z2VzKTsKK2Vhcmx5X3BhcmFtKCJzd2lvdGxiIiwgc2V0dXBfaW9fdGxiX25wYWdlcyk7CiAvKiBt
YWtlIGlvX3RsYl9vdmVyZmxvdyB0dW5hYmxlIHRvbz8gKi8KIAogdW5zaWduZWQgbG9uZyBzd2lv
dGxiX25yX3RibCh2b2lkKQpAQCAtMTE1LDYgKzExNSwxOCBAQCB1bnNpZ25lZCBsb25nIHN3aW90
bGJfbnJfdGJsKHZvaWQpCiAJcmV0dXJuIGlvX3RsYl9uc2xhYnM7CiB9CiBFWFBPUlRfU1lNQk9M
X0dQTChzd2lvdGxiX25yX3RibCk7CisKKy8qIGRlZmF1bHQgdG8gNjRNQiAqLworI2RlZmluZSBJ
T19UTEJfREVGQVVMVF9TSVpFICg2NFVMPDwyMCkKK3Vuc2lnbmVkIGxvbmcgc3dpb3RsYl9zaXpl
X29yX2RlZmF1bHQodm9pZCkKK3sKKwl1bnNpZ25lZCBsb25nIHNpemU7CisKKwlzaXplID0gaW9f
dGxiX25zbGFicyA8PCBJT19UTEJfU0hJRlQ7CisKKwlyZXR1cm4gc2l6ZSA/IHNpemUgOiAoSU9f
VExCX0RFRkFVTFRfU0laRSk7Cit9CisKIC8qIE5vdGUgdGhhdCB0aGlzIGRvZXNuJ3Qgd29yayB3
aXRoIGhpZ2htZW0gcGFnZSAqLwogc3RhdGljIGRtYV9hZGRyX3Qgc3dpb3RsYl92aXJ0X3RvX2J1
cyhzdHJ1Y3QgZGV2aWNlICpod2RldiwKIAkJCQkgICAgICB2b2xhdGlsZSB2b2lkICphZGRyZXNz
KQpAQCAtMTg4LDggKzIwMCw3IEBAIGludCBfX2luaXQgc3dpb3RsYl9pbml0X3dpdGhfdGJsKGNo
YXIgKnQKIHZvaWQgIF9faW5pdAogc3dpb3RsYl9pbml0KGludCB2ZXJib3NlKQogewotCS8qIGRl
ZmF1bHQgdG8gNjRNQiAqLwotCXNpemVfdCBkZWZhdWx0X3NpemUgPSA2NFVMPDwyMDsKKwlzaXpl
X3QgZGVmYXVsdF9zaXplID0gSU9fVExCX0RFRkFVTFRfU0laRTsKIAl1bnNpZ25lZCBjaGFyICp2
c3RhcnQ7CiAJdW5zaWduZWQgbG9uZyBieXRlczsKIAo=
--90e6ba539e8670028604d7aadd4d--

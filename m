Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3DLSjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:39:51 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42215 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3DLSju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <516849A9.1070206@gmx.de>
References: <51681FAA.7030108@gmx.de>
	<CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com>
	<516843C4.5030104@gmx.de>
	<CAFLxGvyp+zZx_TTyz1Zji5BGxd=JUFzhp594sxPLHgZ6kpsBCA@mail.gmail.com>
	<516849A9.1070206@gmx.de>
Date: Fri, 12 Apr 2013 20:39:49 +0200
Message-ID: <CAFLxGvx4KmTify-EEipcNr3GXUZwUx60Q+d=8=p5CXuJvqqh+Q@mail.gmail.com>
Subject: Re: build error with latest git kernel for a user mode linux build
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d043894055d37f404da2e3a0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043894055d37f404da2e3a0c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2013 at 7:51 PM, Toralf F=F6rster <toralf.foerster@gmx.de> =
wrote:
> On 04/12/2013 07:41 PM, richard -rw- weinberger wrote:
>> You .config build perfectly fine here.
>> Have you tried a "make mrproper"?
> ick - I forgot to un-apply your patch you sent to me related to the trini=
ty-madvise UML problem - compiles fine now again
>
> but this now seems not to work any longer :
>
> $ cat devel/stub_pte_fix.diff
> diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
> index b30f34a..db2d885 100644
> --- a/arch/um/include/asm/Kbuild
> +++ b/arch/um/include/asm/Kbuild
> @@ -3,3 +3,4 @@ generic-y +=3D hw_irq.h irq_regs.h kdebug.h percpu.h sect=
ions.h topology.h xor.h
>  generic-y +=3D ftrace.h pci.h io.h param.h delay.h mutex.h current.h exe=
c.h
>  generic-y +=3D switch_to.h clkdev.h
>  generic-y +=3D trace_clock.h
> +header-y +=3D mman.h
> diff --git a/arch/um/include/asm/mman.h b/arch/um/include/asm/mman.h
> new file mode 100644
> index 0000000..d8fb362
> --- /dev/null
> +++ b/arch/um/include/asm/mman.h
> @@ -0,0 +1,10 @@
> +#ifndef __UM_MMAN_H__
> ...

The attached patch is an updated version of stub_pte_fix.diff. It
should fix your issues. :-)

--
Thanks,
//richard

--f46d043894055d37f404da2e3a0c
Content-Type: application/octet-stream; name="stub_pte_fix.diff"
Content-Disposition: attachment; filename="stub_pte_fix.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hffpa5dj0

ZGlmZiAtLWdpdCBhL2FyY2gvdW0vaW5jbHVkZS9hc20vS2J1aWxkIGIvYXJjaC91bS9pbmNsdWRl
L2FzbS9LYnVpbGQKaW5kZXggYjMwZjM0YS4uZGIyZDg4NSAxMDA2NDQKLS0tIGEvYXJjaC91bS9p
bmNsdWRlL2FzbS9LYnVpbGQKKysrIGIvYXJjaC91bS9pbmNsdWRlL2FzbS9LYnVpbGQKQEAgLTMs
MyArMyw0IEBAIGdlbmVyaWMteSArPSBod19pcnEuaCBpcnFfcmVncy5oIGtkZWJ1Zy5oIHBlcmNw
dS5oIHNlY3Rpb25zLmggdG9wb2xvZ3kuaCB4b3IuaAogZ2VuZXJpYy15ICs9IGZ0cmFjZS5oIHBj
aS5oIGlvLmggcGFyYW0uaCBkZWxheS5oIG11dGV4LmggY3VycmVudC5oIGV4ZWMuaAogZ2VuZXJp
Yy15ICs9IHN3aXRjaF90by5oIGNsa2Rldi5oCiBnZW5lcmljLXkgKz0gdHJhY2VfY2xvY2suaAor
aGVhZGVyLXkgKz0gbW1hbi5oCmRpZmYgLS1naXQgYS9hcmNoL3VtL2luY2x1ZGUvYXNtL21tYW4u
aCBiL2FyY2gvdW0vaW5jbHVkZS9hc20vbW1hbi5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4
IDAwMDAwMDAuLmJiMGE4YzcKLS0tIC9kZXYvbnVsbAorKysgYi9hcmNoL3VtL2luY2x1ZGUvYXNt
L21tYW4uaApAQCAtMCwwICsxLDkgQEAKKyNpZm5kZWYgX19VTV9NTUFOX0hfXworI2RlZmluZSBf
X1VNX01NQU5fSF9fCisKKyNpbmNsdWRlIDx1YXBpL2FzbS9tbWFuLmg+CisKKyNkZWZpbmUgYXJj
aF9tbWFwX2NoZWNrIHVtbF9tbWFwX2NoZWNrCitpbnQgdW1sX21tYXBfY2hlY2sodW5zaWduZWQg
bG9uZyBhZGRyLCB1bnNpZ25lZCBsb25nIGxlbiwgdW5zaWduZWQgbG9uZyBmbGFncyk7CisKKyNl
bmRpZiAvKiBfX1VNX01NQU5fSF9fICovCmRpZmYgLS1naXQgYS9hcmNoL3VtL2tlcm5lbC9tZW0u
YyBiL2FyY2gvdW0va2VybmVsL21lbS5jCmluZGV4IDVhYmNiZmIuLjYzMmMwNjYgMTAwNjQ0Ci0t
LSBhL2FyY2gvdW0va2VybmVsL21lbS5jCisrKyBiL2FyY2gvdW0va2VybmVsL21lbS5jCkBAIC0x
MCw2ICsxMCw3IEBACiAjaW5jbHVkZSA8bGludXgvbW0uaD4KICNpbmNsdWRlIDxsaW51eC9zd2Fw
Lmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgorI2luY2x1ZGUgPGxpbnV4L21tYW4uaD4KICNp
bmNsdWRlIDxhc20vZml4bWFwLmg+CiAjaW5jbHVkZSA8YXNtL3BhZ2UuaD4KICNpbmNsdWRlIDxh
cy1sYXlvdXQuaD4KQEAgLTMyMCwzICszMjEsOCBAQCB2b2lkICp1bWxfa21hbGxvYyhpbnQgc2l6
ZSwgaW50IGZsYWdzKQogewogCXJldHVybiBrbWFsbG9jKHNpemUsIGZsYWdzKTsKIH0KKworaW50
IHVtbF9tbWFwX2NoZWNrKHVuc2lnbmVkIGxvbmcgYWRkciwgdW5zaWduZWQgbG9uZyBsZW4sIHVu
c2lnbmVkIGxvbmcgZmxhZ3MpCit7CisJcmV0dXJuIChmbGFncyAmIE1BUF9GSVhFRCAmJiBhZGRy
IDwgU1RVQl9TVEFSVCArIFNUVUJfRU5EKSA/IC1FSU5WQUwgOiAwOworfQpkaWZmIC0tZ2l0IGEv
YXJjaC91bS9rZXJuZWwvc2thcy9tbXUuYyBiL2FyY2gvdW0va2VybmVsL3NrYXMvbW11LmMKaW5k
ZXggZmYwMzA2Ny4uZGIwOTMyMiAxMDA2NDQKLS0tIGEvYXJjaC91bS9rZXJuZWwvc2thcy9tbXUu
YworKysgYi9hcmNoL3VtL2tlcm5lbC9za2FzL21tdS5jCkBAIC0xMDMsNyArMTAzLDcgQEAgaW50
IGluaXRfbmV3X2NvbnRleHQoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLCBzdHJ1Y3QgbW1fc3Ry
dWN0ICptbSkKIAogdm9pZCB1bWxfc2V0dXBfc3R1YnMoc3RydWN0IG1tX3N0cnVjdCAqbW0pCiB7
Ci0JaW50IGVyciwgcmV0OworCWludCByZXQ7CiAKIAlpZiAoIXNrYXNfbmVlZHNfc3R1YikKIAkJ
cmV0dXJuOwpAQCAtMTIwLDE1ICsxMjAsMTAgQEAgdm9pZCB1bWxfc2V0dXBfc3R1YnMoc3RydWN0
IG1tX3N0cnVjdCAqbW0pCiAJbW0tPmNvbnRleHQuc3R1Yl9wYWdlc1swXSA9IHZpcnRfdG9fcGFn
ZSgmX19zeXNjYWxsX3N0dWJfc3RhcnQpOwogCW1tLT5jb250ZXh0LnN0dWJfcGFnZXNbMV0gPSB2
aXJ0X3RvX3BhZ2UobW0tPmNvbnRleHQuaWQuc3RhY2spOwogCi0JLyogZHVwX21tYXAgYWxyZWFk
eSBob2xkcyBtbWFwX3NlbSAqLwotCWVyciA9IGluc3RhbGxfc3BlY2lhbF9tYXBwaW5nKG1tLCBT
VFVCX1NUQVJULCBTVFVCX0VORCAtIFNUVUJfU1RBUlQsCi0JCQkJICAgICAgVk1fUkVBRCB8IFZN
X01BWVJFQUQgfCBWTV9FWEVDIHwKLQkJCQkgICAgICBWTV9NQVlFWEVDIHwgVk1fRE9OVENPUFks
Ci0JCQkJICAgICAgbW0tPmNvbnRleHQuc3R1Yl9wYWdlcyk7Ci0JaWYgKGVycikgewotCQlwcmlu
dGsoS0VSTl9FUlIgImluc3RhbGxfc3BlY2lhbF9tYXBwaW5nIHJldHVybmVkICVkXG4iLCBlcnIp
OwotCQlnb3RvIG91dDsKLQl9CisJLyogWFhYOiB0aGUgc3R1YiBwYWdlcyBkb24ndCBoYXZlIGEg
Vk1BLCBlbnN1cmUgdGhhdCB0aGUgUFRSIGNvdW50ZXIKKwkgKiBpcyBjb3JyZWN0IGF0IHByb2Nl
c3MgZXhpdC4gKi8KKwltbS0+bnJfcHRlcy0tOworCiAJcmV0dXJuOwogCiBvdXQ6Cg==
--f46d043894055d37f404da2e3a0c--

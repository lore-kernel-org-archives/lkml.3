Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbaEGQ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:57:40 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53314 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaEGQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:57:38 -0400
MIME-Version: 1.0
In-Reply-To: <87zjiuymiu.fsf@turtle.gmx.de>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<87k3aspd1h.fsf@wine.dyndns.org>
	<87zjiuymiu.fsf@turtle.gmx.de>
Date: Wed, 7 May 2014 09:57:37 -0700
X-Google-Sender-Auth: QwgWJV5jYjveB3RmPO8KNFlmLrI
Message-ID: <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Alexandre Julliard <julliard@winehq.org>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: multipart/mixed; boundary=047d7b2e5168fb93fb04f8d242d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2e5168fb93fb04f8d242d2
Content-Type: text/plain; charset=UTF-8

On Wed, May 7, 2014 at 2:18 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>
> It seems that at least some 32-bit programs are also broken, since after
> upgrading the kernel to 3.14.3 I can no longer start my old chess
> database program:

So for backporting (and for 3.15) maybe this (TOTALLY UNTESTED) patch
would be acceptable.

It adds a "/proc/sys/abi/ldt16" sysctl that defaults to zero (off). If
you hit this issue and care about your old Windows program more than
you care about a kernel stack address information leak, you can do

   echo 1 > /proc/sys/abi/ldt16

as root (add it to your startup scripts), and you should be ok.

Afaik, 16-bit programs under wine already need

  echo 0 > /proc/sys/vm/mmap_min_addr

because they want to map things at address 0, so this isn't a new concept.

I would like to repeat that this is totally untested. And the sysct
table is only added if you have COMPAT support enabled on x86-64, but
I assume anybody who runs old windows binaries very much does that ;)

                        Linus

--047d7b2e5168fb93fb04f8d242d2
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huwvd1pc0

IGFyY2gveDg2L2tlcm5lbC9sZHQuYyAgICAgICAgfCA0ICsrKy0KIGFyY2gveDg2L3Zkc28vdmRz
bzMyLXNldHVwLmMgfCA4ICsrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvbGR0LmMgYi9h
cmNoL3g4Ni9rZXJuZWwvbGR0LmMKaW5kZXggYWYxZDE0YTllYmRhLi5kY2JiYWExNjViZGUgMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9sZHQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvbGR0
LmMKQEAgLTIwLDYgKzIwLDggQEAKICNpbmNsdWRlIDxhc20vbW11X2NvbnRleHQuaD4KICNpbmNs
dWRlIDxhc20vc3lzY2FsbHMuaD4KIAoraW50IHN5c2N0bF9sZHQxNiA9IDA7CisKICNpZmRlZiBD
T05GSUdfU01QCiBzdGF0aWMgdm9pZCBmbHVzaF9sZHQodm9pZCAqY3VycmVudF9tbSkKIHsKQEAg
LTIzNCw3ICsyMzYsNyBAQCBzdGF0aWMgaW50IHdyaXRlX2xkdCh2b2lkIF9fdXNlciAqcHRyLCB1
bnNpZ25lZCBsb25nIGJ5dGVjb3VudCwgaW50IG9sZG1vZGUpCiAJICogSVJFVCBsZWFraW5nIHRo
ZSBoaWdoIGJpdHMgb2YgdGhlIGtlcm5lbCBzdGFjayBhZGRyZXNzLgogCSAqLwogI2lmZGVmIENP
TkZJR19YODZfNjQKLQlpZiAoIWxkdF9pbmZvLnNlZ18zMmJpdCkgeworCWlmICghbGR0X2luZm8u
c2VnXzMyYml0ICYmICFzeXNjdGxfbGR0MTYpIHsKIAkJZXJyb3IgPSAtRUlOVkFMOwogCQlnb3Rv
IG91dF91bmxvY2s7CiAJfQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmRzby92ZHNvMzItc2V0dXAu
YyBiL2FyY2gveDg2L3Zkc28vdmRzbzMyLXNldHVwLmMKaW5kZXggMDAzNDg5ODBhM2E2Li5lMWYy
MjBlM2NhNjggMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3Zkc28vdmRzbzMyLXNldHVwLmMKKysrIGIv
YXJjaC94ODYvdmRzby92ZHNvMzItc2V0dXAuYwpAQCAtMzksNiArMzksNyBAQAogI2lmZGVmIENP
TkZJR19YODZfNjQKICNkZWZpbmUgdmRzb19lbmFibGVkCQkJc3lzY3RsX3ZzeXNjYWxsMzIKICNk
ZWZpbmUgYXJjaF9zZXR1cF9hZGRpdGlvbmFsX3BhZ2VzCXN5c2NhbGwzMl9zZXR1cF9wYWdlcwor
ZXh0ZXJuIGludCBzeXNjdGxfbGR0MTY7CiAjZW5kaWYKIAogLyoKQEAgLTI0OSw2ICsyNTAsMTMg
QEAgc3RhdGljIHN0cnVjdCBjdGxfdGFibGUgYWJpX3RhYmxlMltdID0gewogCQkubW9kZQkJPSAw
NjQ0LAogCQkucHJvY19oYW5kbGVyCT0gcHJvY19kb2ludHZlYwogCX0sCisJeworCQkucHJvY25h
bWUJPSAibGR0MTYiLAorCQkuZGF0YQkJPSAmc3lzY3RsX2xkdDE2LAorCQkubWF4bGVuCQk9IHNp
emVvZihpbnQpLAorCQkubW9kZQkJPSAwNjQ0LAorCQkucHJvY19oYW5kbGVyCT0gcHJvY19kb2lu
dHZlYworCX0sCiAJe30KIH07CiAK
--047d7b2e5168fb93fb04f8d242d2--

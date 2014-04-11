Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaDKTsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:48:50 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48650 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaDKTso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140411160312.GB31676@kroah.com>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
	<CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
	<20140401124824.GA13642@gondor.apana.org.au>
	<CAKv+Gu9bg1AgDSb3H-tMGBq53_ySaTZAeYsQeDYKS6cTnaBGUA@mail.gmail.com>
	<20140411160312.GB31676@kroah.com>
Date: Fri, 11 Apr 2014 21:48:42 +0200
Message-ID: <CAKv+Gu-ZKVz7JKhW9iWuZeKiRnyS3Z4uakPn2_UMW_CpSBgXkw@mail.gmail.com>
Subject: Re: Fwd: [crypto:master 60/60] arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25:
 sparse: cast to restricted __be64
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0160bb12fb498704f6c99e61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0160bb12fb498704f6c99e61
Content-Type: text/plain; charset=ISO-8859-1

On 11 April 2014 18:03, gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 04, 2014 at 10:11:19AM +0200, Ard Biesheuvel wrote:
>> Greg,
>>
>> This pertains to commit 8ceee72808d1 (crypto: ghash-clmulni-intel -
>> use C implementation for setkey()) that has been pulled by Linus
>> during the current merge window.
>>
>> It is missing two things:
>> - a cc to stable annotation
>> - a fix for the sparse warning below (change cast from __be64 to __force __be64)
>>
>> The reason for cc'ing stable on this patch is that it fixes a
>> potential data corruption issue where the ghash setkey() method uses
>> SSE registers without calling kernel_fpu_begin() first. This issue was
>> introduced by 0e1227d356e9b (crypto: ghash - Add PCLMULQDQ accelerated
>> implementation).
>>
>> So how would you like to proceed with this? Should I propose a new
>> patch somewhere?
>
> No problem, I'll apply this as-is.  But it doesn't apply to the
> 3.4-stable tree cleanly, can you send me a backported version if it's
> still needed there as well?
>

Yes, the code was broken from the start. 3.4 version is attached, the
only difference is the missing ENDPROC() at the end of the asm file.

In the mean time, Herbert has submitted a fix for the sparse warning,
but we settled on a different fix than I had suggested before.
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=0ea481466d1c

Note that this code has not been tested (not by me, at least), so I
wouldn't suggest you take it straight away, but if you care about the
sparse warning, we could add a cc stable to it as well, I suppose.

Regards,
Ard.

--089e0160bb12fb498704f6c99e61
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-crypto-ghash-clmulni-intel-use-C-implementation-for-.patch"
Content-Disposition: attachment; 
	filename="0001-crypto-ghash-clmulni-intel-use-C-implementation-for-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htvvqqf40

RnJvbSBkYjljNzBlOGYzMjkxNDkwZmVjMGRhNTZkY2UyYmZhNzgzN2U5OWYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJv
Lm9yZz4KRGF0ZTogRnJpLCAxMSBBcHIgMjAxNCAyMDozNzozNyArMDIwMApTdWJqZWN0OiBbUEFU
Q0hdIGNyeXB0bzogZ2hhc2gtY2xtdWxuaS1pbnRlbCAtIHVzZSBDIGltcGxlbWVudGF0aW9uIGZv
cgogc2V0a2V5KCkKCmNvbW1pdCA4Y2VlZTcyODA4ZDFhZTNmYjE5MTI4NGFmYzIyNTdhMmJlOTY0
NzI1IHVwc3RyZWFtLgoKVGhlIEdIQVNIIHNldGtleSgpIGZ1bmN0aW9uIHVzZXMgU1NFIHJlZ2lz
dGVycyBidXQgZmFpbHMgdG8gY2FsbAprZXJuZWxfZnB1X2JlZ2luKCkva2VybmVsX2ZwdV9lbmQo
KS4gSW5zdGVhZCBvZiBhZGRpbmcgdGhlc2UgY2FsbHMsIGFuZAp0aGVuIGhhdmluZyB0byBkZWFs
IHdpdGggdGhlIHJlc3RyaWN0aW9uIHRoYXQgdGhleSBjYW5ub3QgYmUgY2FsbGVkIGZyb20KaW50
ZXJydXB0IGNvbnRleHQsIG1vdmUgdGhlIHNldGtleSgpIGltcGxlbWVudGF0aW9uIHRvIHRoZSBD
IGRvbWFpbi4KCk5vdGUgdGhhdCBzZXRrZXkoKSBkb2VzIG5vdCB1c2UgYW55IHBhcnRpY3VsYXIg
U1NFIGZlYXR1cmVzIGFuZCBpcyBub3QKZXhwZWN0ZWQgdG8gYmVjb21lIGEgcGVyZm9ybWFuY2Ug
Ym90dGxlbmVjay4KClNpZ25lZC1vZmYtYnk6IEFyZCBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZl
bEBsaW5hcm8ub3JnPgpBY2tlZC1ieTogSC4gUGV0ZXIgQW52aW4gPGhwYUBsaW51eC5pbnRlbC5j
b20+CkZpeGVzOiAwZTEyMjdkMzU2ZTliIChjcnlwdG86IGdoYXNoIC0gQWRkIFBDTE1VTFFEUSBh
Y2NlbGVyYXRlZCBpbXBsZW1lbnRhdGlvbikKU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVy
YmVydEBnb25kb3IuYXBhbmEub3JnLmF1PgotLS0KIGFyY2gveDg2L2NyeXB0by9naGFzaC1jbG11
bG5pLWludGVsX2FzbS5TICB8IDI4IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGFyY2gv
eDg2L2NyeXB0by9naGFzaC1jbG11bG5pLWludGVsX2dsdWUuYyB8IDE0ICsrKysrKysrKysrLS0t
CiAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2NyeXB0by9naGFzaC1jbG11bG5pLWludGVsX2FzbS5TIGIvYXJj
aC94ODYvY3J5cHRvL2doYXNoLWNsbXVsbmktaW50ZWxfYXNtLlMKaW5kZXggMWViN2Y5MGNiN2I5
Li5lYjRkMmEyNTRiMzUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2NyeXB0by9naGFzaC1jbG11bG5p
LWludGVsX2FzbS5TCisrKyBiL2FyY2gveDg2L2NyeXB0by9naGFzaC1jbG11bG5pLWludGVsX2Fz
bS5TCkBAIC0yNCwxMCArMjQsNiBAQAogLmFsaWduIDE2CiAuTGJzd2FwX21hc2s6CiAJLm9jdGEg
MHgwMDAxMDIwMzA0MDUwNjA3MDgwOTBhMGIwYzBkMGUwZgotLkxwb2x5OgotCS5vY3RhIDB4YzIw
MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDEKLS5MdHdvX29uZToKLQkub2N0YSAweDAwMDAw
MDAxMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAxCiAKICNkZWZpbmUgREFUQQkleG1tMAogI2RlZmlu
ZSBTSEFTSAkleG1tMQpAQCAtMTMxLDI3ICsxMjcsMyBAQCBFTlRSWShjbG11bF9naGFzaF91cGRh
dGUpCiAJbW92dXBzIERBVEEsICglcmRpKQogLkx1cGRhdGVfanVzdF9yZXQ6CiAJcmV0Ci0KLS8q
Ci0gKiB2b2lkIGNsbXVsX2doYXNoX3NldGtleShiZTEyOCAqc2hhc2gsIGNvbnN0IHU4ICprZXkp
OwotICoKLSAqIENhbGN1bGF0ZSBoYXNoX2tleSA8PCAxIG1vZCBwb2x5Ci0gKi8KLUVOVFJZKGNs
bXVsX2doYXNoX3NldGtleSkKLQltb3ZhcHMgLkxic3dhcF9tYXNrLCBCU1dBUAotCW1vdnVwcyAo
JXJzaSksICV4bW0wCi0JUFNIVUZCX1hNTSBCU1dBUCAleG1tMAotCW1vdmFwcyAleG1tMCwgJXht
bTEKLQlwc2xscSAkMSwgJXhtbTAKLQlwc3JscSAkNjMsICV4bW0xCi0JbW92YXBzICV4bW0xLCAl
eG1tMgotCXBzbGxkcSAkOCwgJXhtbTEKLQlwc3JsZHEgJDgsICV4bW0yCi0JcG9yICV4bW0xLCAl
eG1tMAotCSMgcmVkdWN0aW9uCi0JcHNodWZkICQwYjAwMTAwMTAwLCAleG1tMiwgJXhtbTEKLQlw
Y21wZXFkIC5MdHdvX29uZSwgJXhtbTEKLQlwYW5kIC5McG9seSwgJXhtbTEKLQlweG9yICV4bW0x
LCAleG1tMAotCW1vdnVwcyAleG1tMCwgKCVyZGkpCi0JcmV0CmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9jcnlwdG8vZ2hhc2gtY2xtdWxuaS1pbnRlbF9nbHVlLmMgYi9hcmNoL3g4Ni9jcnlwdG8vZ2hh
c2gtY2xtdWxuaS1pbnRlbF9nbHVlLmMKaW5kZXggYjRiZjBhNjNiNTIwLi5jMDc0NDZkMTc0NjMg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2NyeXB0by9naGFzaC1jbG11bG5pLWludGVsX2dsdWUuYwor
KysgYi9hcmNoL3g4Ni9jcnlwdG8vZ2hhc2gtY2xtdWxuaS1pbnRlbF9nbHVlLmMKQEAgLTMwLDgg
KzMwLDYgQEAgdm9pZCBjbG11bF9naGFzaF9tdWwoY2hhciAqZHN0LCBjb25zdCBiZTEyOCAqc2hh
c2gpOwogdm9pZCBjbG11bF9naGFzaF91cGRhdGUoY2hhciAqZHN0LCBjb25zdCBjaGFyICpzcmMs
IHVuc2lnbmVkIGludCBzcmNsZW4sCiAJCQljb25zdCBiZTEyOCAqc2hhc2gpOwogCi12b2lkIGNs
bXVsX2doYXNoX3NldGtleShiZTEyOCAqc2hhc2gsIGNvbnN0IHU4ICprZXkpOwotCiBzdHJ1Y3Qg
Z2hhc2hfYXN5bmNfY3R4IHsKIAlzdHJ1Y3QgY3J5cHRkX2FoYXNoICpjcnlwdGRfdGZtOwogfTsK
QEAgLTU4LDEzICs1NiwyMyBAQCBzdGF0aWMgaW50IGdoYXNoX3NldGtleShzdHJ1Y3QgY3J5cHRv
X3NoYXNoICp0Zm0sCiAJCQljb25zdCB1OCAqa2V5LCB1bnNpZ25lZCBpbnQga2V5bGVuKQogewog
CXN0cnVjdCBnaGFzaF9jdHggKmN0eCA9IGNyeXB0b19zaGFzaF9jdHgodGZtKTsKKwliZTEyOCAq
eCA9IChiZTEyOCAqKWtleTsKKwl1NjQgYSwgYjsKIAogCWlmIChrZXlsZW4gIT0gR0hBU0hfQkxP
Q0tfU0laRSkgewogCQljcnlwdG9fc2hhc2hfc2V0X2ZsYWdzKHRmbSwgQ1JZUFRPX1RGTV9SRVNf
QkFEX0tFWV9MRU4pOwogCQlyZXR1cm4gLUVJTlZBTDsKIAl9CiAKLQljbG11bF9naGFzaF9zZXRr
ZXkoJmN0eC0+c2hhc2gsIGtleSk7CisJLyogcGVyZm9ybSBtdWx0aXBsaWNhdGlvbiBieSAneCcg
aW4gR0YoMl4xMjgpICovCisJYSA9IGJlNjRfdG9fY3B1KHgtPmEpOworCWIgPSBiZTY0X3RvX2Nw
dSh4LT5iKTsKKworCWN0eC0+c2hhc2guYSA9IChfX2JlNjQpKChiIDw8IDEpIHwgKGEgPj4gNjMp
KTsKKwljdHgtPnNoYXNoLmIgPSAoX19iZTY0KSgoYSA8PCAxKSB8IChiID4+IDYzKSk7CisKKwlp
ZiAoYSA+PiA2MykKKwkJY3R4LT5zaGFzaC5iIF49IGNwdV90b19iZTY0KDB4YzIpOwogCiAJcmV0
dXJuIDA7CiB9Ci0tIAoxLjguMy4yCgo=
--089e0160bb12fb498704f6c99e61--

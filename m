Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3C3RWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 13:22:52 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:35337 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3C3RWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 13:22:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gKKNf2105vi93t=KBs5fVRUcaD6BP5hhYE-8cwy2OBAx8w@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	<1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
	<CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
	<CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
	<CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
	<CA+55aFy7OtkWiqO+CxmDgkyfR_58=hdkc-VoaqWCngETw19Euw@mail.gmail.com>
	<CA+i8gKKNf2105vi93t=KBs5fVRUcaD6BP5hhYE-8cwy2OBAx8w@mail.gmail.com>
Date: Sat, 30 Mar 2013 10:22:49 -0700
X-Google-Sender-Auth: ZEdYstq2PNBQPjWEXZxtnmfHqTc
Message-ID: <CA+55aFyqhacFz9xc3igO2mpmwFHdMKGGMVbbrUiOOrkyjVxMXg@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: multipart/mixed; boundary=089e0158b3aa187c6e04d927a358
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0158b3aa187c6e04d927a358
Content-Type: text/plain; charset=UTF-8

On Fri, Mar 29, 2013 at 10:57 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
> On Sat, Mar 30, 2013 at 12:10 PM, Linus Torvalds
>>
>> This came from the gcc build?
>
> yes, very early in the build process, IIRC this line was repeated a
> few times and the build just stalled.

Ok, we're bringing out the crazy hacks now.

The attached patch is just insane, doesn't really even work in
general, and only even compiles on 64-bit. But it should work in
*practice* to find if somebody adds the same RCU head to the RCU lists
twice, and ignore the second time it happens (and give a warning that
hopefully pinpoints the backtrace).

It's ugly. It's broken. It may not work. In other words, I'm not proud
of it. But you seem to be the only one able to trigger the issue
easily, willing to try crazy crap, so "tag, you're it". Maybe this
gives us more information. And maybe it doesn't, and I'm totally wrong
about the whole "rcu head added twice" theory.

                        Linus

--089e0158b3aa187c6e04d927a358
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hex1sypn0

IGluY2x1ZGUvbGludXgvdHlwZXMuaCB8IDEgKwogaW5jbHVkZS9uZXQvZHN0LmggICAgIHwgMiAr
LQoga2VybmVsL3JjdS5oICAgICAgICAgIHwgMSArCiBrZXJuZWwvcmN1dHJlZS5jICAgICAgfCA2
ICsrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L3R5cGVz
LmgKaW5kZXggNGQxMThiYTExMzQ5Li4zZjBkOWRhZmY5MDYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bGludXgvdHlwZXMuaAorKysgYi9pbmNsdWRlL2xpbnV4L3R5cGVzLmgKQEAgLTIwOSw2ICsyMDks
NyBAQCBzdHJ1Y3QgdXN0YXQgewogc3RydWN0IGNhbGxiYWNrX2hlYWQgewogCXN0cnVjdCBjYWxs
YmFja19oZWFkICpuZXh0OwogCXZvaWQgKCpmdW5jKShzdHJ1Y3QgY2FsbGJhY2tfaGVhZCAqaGVh
ZCk7CisJdW5zaWduZWQgbG9uZyBtYWdpYzsKIH07CiAjZGVmaW5lIHJjdV9oZWFkIGNhbGxiYWNr
X2hlYWQKIApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvZHN0LmggYi9pbmNsdWRlL25ldC9kc3Qu
aAppbmRleCAxZjhmZDEwOWUyMjUuLjZmOGFjZDAzMTk0OCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9u
ZXQvZHN0LmgKKysrIGIvaW5jbHVkZS9uZXQvZHN0LmgKQEAgLTg5LDcgKzg5LDcgQEAgc3RydWN0
IGRzdF9lbnRyeSB7CiAJICogKEwxX0NBQ0hFX1NJWkUgd291bGQgYmUgdG9vIG11Y2gpCiAJICov
CiAjaWZkZWYgQ09ORklHXzY0QklUCi0JbG9uZwkJCV9fcGFkX3RvX2FsaWduX3JlZmNudFsyXTsK
Kwlsb25nCQkJX19wYWRfdG9fYWxpZ25fcmVmY250WzFdOwogI2VuZGlmCiAJLyoKIAkgKiBfX3Jl
ZmNudCB3YW50cyB0byBiZSBvbiBhIGRpZmZlcmVudCBjYWNoZSBsaW5lIGZyb20KZGlmZiAtLWdp
dCBhL2tlcm5lbC9yY3UuaCBiL2tlcm5lbC9yY3UuaAppbmRleCA3ZjhlNzU5MGUzZTUuLjAzODFl
ZDM3MjFiYiAxMDA2NDQKLS0tIGEva2VybmVsL3JjdS5oCisrKyBiL2tlcm5lbC9yY3UuaApAQCAt
OTgsNiArOTgsNyBAQCBzdGF0aWMgaW5saW5lIGJvb2wgX19yY3VfcmVjbGFpbShjaGFyICpybiwg
c3RydWN0IHJjdV9oZWFkICpoZWFkKQogewogCXVuc2lnbmVkIGxvbmcgb2Zmc2V0ID0gKHVuc2ln
bmVkIGxvbmcpaGVhZC0+ZnVuYzsKIAorCWhlYWQtPm1hZ2ljID0gMDsKIAlpZiAoX19pc19rZnJl
ZV9yY3Vfb2Zmc2V0KG9mZnNldCkpIHsKIAkJUkNVX1RSQUNFKHRyYWNlX3JjdV9pbnZva2Vfa2Zy
ZWVfY2FsbGJhY2socm4sIGhlYWQsIG9mZnNldCkpOwogCQlrZnJlZSgodm9pZCAqKWhlYWQgLSBv
ZmZzZXQpOwpkaWZmIC0tZ2l0IGEva2VybmVsL3JjdXRyZWUuYyBiL2tlcm5lbC9yY3V0cmVlLmMK
aW5kZXggNWI4YWQ4MjdmZDg2Li44MGY5Y2ZiNjM3NDggMTAwNjQ0Ci0tLSBhL2tlcm5lbC9yY3V0
cmVlLmMKKysrIGIva2VybmVsL3JjdXRyZWUuYwpAQCAtMjIyMSw2ICsyMjIxLDkgQEAgc3RhdGlj
IHZvaWQgX19jYWxsX3JjdV9jb3JlKHN0cnVjdCByY3Vfc3RhdGUgKnJzcCwgc3RydWN0IHJjdV9k
YXRhICpyZHAsCiAJfQogfQogCisvKiBVbmxpa2VseSBiaXQtcGF0dGVybiB0byBjaGVjayBkb3Vi
bGUgUkNVIGNhbGxzISAqLworI2RlZmluZSBSQ1VfSEVBRF9NQUdJQyAoKHVuc2lnbmVkIGxvbmcp
KDB4ZmVlZGRlYWQxYWNlZjhlZGxsKSkKKwogLyoKICAqIEhlbHBlciBmdW5jdGlvbiBmb3IgY2Fs
bF9yY3UoKSBhbmQgZnJpZW5kcy4gIFRoZSBjcHUgYXJndW1lbnQgd2lsbAogICogbm9ybWFsbHkg
YmUgLTEsIGluZGljYXRpbmcgImN1cnJlbnRseSBydW5uaW5nIENQVSIuICBJdCBtYXkgc3BlY2lm
eQpAQCAtMjIzNSw5ICsyMjM4LDEyIEBAIF9fY2FsbF9yY3Uoc3RydWN0IHJjdV9oZWFkICpoZWFk
LCB2b2lkICgqZnVuYykoc3RydWN0IHJjdV9oZWFkICpyY3UpLAogCXN0cnVjdCByY3VfZGF0YSAq
cmRwOwogCiAJV0FSTl9PTl9PTkNFKCh1bnNpZ25lZCBsb25nKWhlYWQgJiAweDMpOyAvKiBNaXNh
bGlnbmVkIHJjdV9oZWFkISAqLworCWlmIChXQVJOX09OX09OQ0UoaGVhZC0+bWFnaWMgPT0gUkNV
X0hFQURfTUFHSUMpKQorCQlyZXR1cm47CiAJZGVidWdfcmN1X2hlYWRfcXVldWUoaGVhZCk7CiAJ
aGVhZC0+ZnVuYyA9IGZ1bmM7CiAJaGVhZC0+bmV4dCA9IE5VTEw7CisJaGVhZC0+bWFnaWMgPSBS
Q1VfSEVBRF9NQUdJQzsKIAogCS8qCiAJICogT3Bwb3J0dW5pc3RpY2FsbHkgbm90ZSBncmFjZS1w
ZXJpb2QgZW5kaW5ncyBhbmQgYmVnaW5uaW5ncy4K
--089e0158b3aa187c6e04d927a358--

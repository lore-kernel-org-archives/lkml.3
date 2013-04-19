Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3DSVYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:24:14 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:60978 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3DSVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUVjx7pDJWo3tGxX3ANXtiTP0_Q1YyOowANhn1wzcSgWaA@mail.gmail.com>
References: <CA+icZUVWC+Rgd9wh4Z4CPZkEa9Pm2=2udnY5=UD1nnH0Wot1pQ@mail.gmail.com>
	<CAKMK7uFEaiT_1siQBcp_-S0RwLvy3XSjqLn1ksq70VhNTZSfLw@mail.gmail.com>
	<CA+icZUWQEiGecR8jgw4P-2YCKyqSDMMP0Ufwn8aBU_-AOf0a-Q@mail.gmail.com>
	<CA+icZUWcwvFFVesJDoFNT3DbgRMXvDp7QLn+S5Ze_5d8gJRx1g@mail.gmail.com>
	<CA+icZUXjTGSG+tejOAFgXr8EpKd7dL=-W41ha_-0N=roAxN3eg@mail.gmail.com>
	<CA+icZUVE-ikxEp65bUHMp0WEPX_MDbA06ykzeSxygJv=9f45ig@mail.gmail.com>
	<CA+icZUUp84vzF_0n77wsJ6dBOS26vSRCXaFUDbCQi-wG0b-Osg@mail.gmail.com>
	<517198A7.8020904@surriel.com>
	<1366402328.5317.9.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUVjx7pDJWo3tGxX3ANXtiTP0_Q1YyOowANhn1wzcSgWaA@mail.gmail.com>
Date: Fri, 19 Apr 2013 14:24:10 -0700
X-Google-Sender-Auth: Fxp1fA-8ExdPHus66ZTkuACmKpY
Message-ID: <CA+55aFzU5C9UQGNFx+wQ_Rp0gZAAwLj77qO7fH7LEduD7bk1Kg@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 18 [ call-trace: drm | x86 | smp | rcu
 related? ]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@surriel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Emmanuel Benisty <benisty.e@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b342de00cb39504dabd57d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b342de00cb39504dabd57d5
Content-Type: text/plain; charset=UTF-8

On Fri, Apr 19, 2013 at 2:09 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> I have applied all three patches and see still call-traces.
> New are apparmor related messages.

Can you try the crazy rcu double-free debug hack?

See

    https://lkml.org/lkml/2013/3/30/113

and I'm re-attaching the ugly-ass crazy hack patch here too..

                    Linus

--047d7b342de00cb39504dabd57d5
Content-Type: application/octet-stream; name="rcu-double-free-hack.patch"
Content-Disposition: attachment; filename="rcu-double-free-hack.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfpv87i14

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
--047d7b342de00cb39504dabd57d5--

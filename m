Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaAJAmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:42:37 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:53496 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaAJAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140109225815.GI11594@pd.tnic>
References: <52C0C9F4.50101@zytor.com>
	<52C196C3.1040300@halfdog.net>
	<52C31027.2030101@zytor.com>
	<20131231192106.GA22535@phenom.dumpdata.com>
	<52C347F0.8070902@zytor.com>
	<52CD022E.9040107@halfdog.net>
	<52CD8E10.3010204@zytor.com>
	<20140108193655.GD5098@pd.tnic>
	<52CDC316.4050503@halfdog.net>
	<52CDD3AE.4030301@zytor.com>
	<20140109225815.GI11594@pd.tnic>
Date: Fri, 10 Jan 2014 08:42:33 +0800
X-Google-Sender-Auth: m3Ew6sk1YIyTMVjb-g12BQ-O_cQ
Message-ID: <CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, halfdog <me@halfdog.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: multipart/mixed; boundary=001a11c290de767d9904ef9300e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c290de767d9904ef9300e4
Content-Type: text/plain; charset=UTF-8

On Fri, Jan 10, 2014 at 6:58 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> Ok, I was able to reproduce

Looking at this, I think this is just a bug in our
restore_fpu_checking() hackery for X86_FEATURE_FXSAVE_LEAK..

Which also explains why it only triggers on E-350 - it's only relevant
for those K7/K8 CPU's that use this.

Maybe just add a fcnlex to before the emms? Something like this
(TOTALLY UNTESTED!!) attached patch.

                 Linus

--001a11c290de767d9904ef9300e4
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hq8pxcn00

IGFyY2gveDg2L2luY2x1ZGUvYXNtL2ZwdS1pbnRlcm5hbC5oIHwgMTMgKysrKysrKy0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUtaW50ZXJuYWwuaCBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2ZwdS1pbnRlcm5hbC5oCmluZGV4IGM0OWE2MTNjNjQ1Mi4uY2VhMWM3NmQ0OWJmIDEw
MDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUtaW50ZXJuYWwuaAorKysgYi9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9mcHUtaW50ZXJuYWwuaApAQCAtMjkzLDEyICsyOTMsMTMgQEAgc3Rh
dGljIGlubGluZSBpbnQgcmVzdG9yZV9mcHVfY2hlY2tpbmcoc3RydWN0IHRhc2tfc3RydWN0ICp0
c2spCiAJLyogQU1EIEs3L0s4IENQVXMgZG9uJ3Qgc2F2ZS9yZXN0b3JlIEZEUC9GSVAvRk9QIHVu
bGVzcyBhbiBleGNlcHRpb24KIAkgICBpcyBwZW5kaW5nLiAgQ2xlYXIgdGhlIHg4NyBzdGF0ZSBo
ZXJlIGJ5IHNldHRpbmcgaXQgdG8gZml4ZWQKIAkgICB2YWx1ZXMuICJtIiBpcyBhIHJhbmRvbSB2
YXJpYWJsZSB0aGF0IHNob3VsZCBiZSBpbiBMMSAqLwotCWFsdGVybmF0aXZlX2lucHV0KAotCQlB
U01fTk9QOCBBU01fTk9QMiwKLQkJImVtbXNcblx0IgkJLyogY2xlYXIgc3RhY2sgdGFncyAqLwot
CQkiZmlsZGwgJVBbYWRkcl0iLAkvKiBzZXQgRj9QIHRvIGRlZmluZWQgdmFsdWUgKi8KLQkJWDg2
X0ZFQVRVUkVfRlhTQVZFX0xFQUssCi0JCVthZGRyXSAibSIgKHRzay0+dGhyZWFkLmZwdS5oYXNf
ZnB1KSk7CisJaWYgKHVubGlrZWx5KHN0YXRpY19jcHVfaGFzKFg4Nl9GRUFUVVJFX0ZYU0FWRV9M
RUFLKSkpIHsKKwkJYXNtIHZvbGF0aWxlKAorCQkJImZuY2xleFxuXHQiCisJCQkiZW1tc1xuXHQi
CisJCQkiZmlsZGwgJVBbYWRkcl0iCS8qIHNldCBGP1AgdG8gZGVmaW5lZCB2YWx1ZSAqLworCQkJ
OiA6IFthZGRyXSAibSIgKHRzay0+dGhyZWFkLmZwdS5oYXNfZnB1KSk7CisJfQogCiAJcmV0dXJu
IGZwdV9yZXN0b3JlX2NoZWNraW5nKCZ0c2stPnRocmVhZC5mcHUpOwogfQo=
--001a11c290de767d9904ef9300e4--

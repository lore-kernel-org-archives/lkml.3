Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3EGKh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:37:28 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:36385 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab3EGKh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:37:26 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 13:41:32 +0500
Message-ID: <CANymLzXWFy8N6cthuU7U6oywURFSoqeT4RnYvcxSrkM8bn7nMw@mail.gmail.com>
Subject: [PATCH] Enable A20 gate
From: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
Content-Type: multipart/mixed; boundary=001a11c2b9ecce222704dc1cc83e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2b9ecce222704dc1cc83e
Content-Type: text/plain; charset=ISO-8859-1

>From a5e4cd6cb1956d288b5a001f60699dc8b5528963 Mon Sep 17 00:00:00 2001
From: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
Date: Tue, 7 May 2013 12:49:24 +0500
Subject: [PATCH] Enable A20 gate
 This is a patch to the a20.c file that fixes following
warnings/errors found by the checkpatch.pl tool
 i)  WARNING: please, no spaces at the start of a line
 ii) WARNING: suspect code indent for conditional statements
 iii) ERROR: trailing whitespace
Signed-off-by: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>

---
 arch/x86/boot/a20.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 64a31a6..911d729 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -129,37 +129,37 @@ static void enable_a20_fast(void)

 int enable_a20(void)
 {
-       int loops = A20_ENABLE_LOOPS;
-       int kbc_err;
+ int loops = A20_ENABLE_LOOPS;
+ int kbc_err;

-       while (loops--) {
-       /* First, check to see if A20 is already enabled
+ while (loops--) {
+ /* First, check to see if A20 is already enabled
   (legacy free, etc.) */
-       if (a20_test_short())
-       return 0;
-
+ if (a20_test_short())
+ return 0;
+
        /* Next, try the BIOS (INT 0x15, AX=0x2401) */
        enable_a20_bios();
-       if (a20_test_short())
-       return 0;
-
+ if (a20_test_short())
+ return 0;
+
        /* Try enabling A20 through the keyboard controller */
        kbc_err = empty_8042();

-       if (a20_test_short())
-       return 0; /* BIOS worked, but with delayed reaction */
-
-       if (!kbc_err) {
-       enable_a20_kbc();
-       if (a20_test_long())
-       return 0;
+ if (a20_test_short())
+ return 0; /* BIOS worked, but with delayed reaction */
+
+ if (!kbc_err) {
+ enable_a20_kbc();
+ if (a20_test_long())
+ return 0;
        }
-
+
        /* Finally, try enabling the "fast A20 gate" */
        enable_a20_fast();
-       if (a20_test_long())
-       return 0;
-       }
-
-       return -1;
+ if (a20_test_long())
+ return 0;
+ }
+
+ return -1;
 }
--
1.7.2.5

--001a11c2b9ecce222704dc1cc83e
Content-Type: application/octet-stream; name="0001-Enable-A20-gate.patch"
Content-Disposition: attachment; filename="0001-Enable-A20-gate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgetq8v70

RnJvbSBhNWU0Y2Q2Y2IxOTU2ZDI4OGI1YTAwMWY2MDY5OWRjOGI1NTI4OTYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTeWVkIFNhbG1hbiBNYW5zb29yIDxzeWVkLnNhbG1hbi5tYW5z
b29yQGdtYWlsLmNvbT4KRGF0ZTogVHVlLCA3IE1heSAyMDEzIDEyOjQ5OjI0ICswNTAwClN1Ympl
Y3Q6IFtQQVRDSF0gRW5hYmxlIEEyMCBnYXRlCiBUaGlzIGlzIGEgcGF0Y2ggdG8gdGhlIGEyMC5j
IGZpbGUgdGhhdCBmaXhlcyBmb2xsb3dpbmcgd2FybmluZ3MvZXJyb3JzIGZvdW5kIGJ5IHRoZSBj
aGVja3BhdGNoLnBsIHRvb2wKIGkpICBXQVJOSU5HOiBwbGVhc2UsIG5vIHNwYWNlcyBhdCB0aGUg
c3RhcnQgb2YgYSBsaW5lCiBpaSkgV0FSTklORzogc3VzcGVjdCBjb2RlIGluZGVudCBmb3IgY29u
ZGl0aW9uYWwgc3RhdGVtZW50cwogaWlpKSBFUlJPUjogdHJhaWxpbmcgd2hpdGVzcGFjZQpTaWdu
ZWQtb2ZmLWJ5OiBTeWVkIFNhbG1hbiBNYW5zb29yIDxzeWVkLnNhbG1hbi5tYW5zb29yQGdtYWls
LmNvbT4KCi0tLQogYXJjaC94ODYvYm9vdC9hMjAuYyB8ICAgNDYgKysrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRp
b25zKCspLCAyMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9ib290L2EyMC5j
IGIvYXJjaC94ODYvYm9vdC9hMjAuYwppbmRleCA2NGEzMWE2Li45MTFkNzI5IDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni9ib290L2EyMC5jCisrKyBiL2FyY2gveDg2L2Jvb3QvYTIwLmMKQEAgLTEyOSwz
NyArMTI5LDM3IEBAIHN0YXRpYyB2b2lkIGVuYWJsZV9hMjBfZmFzdCh2b2lkKQogCiBpbnQgZW5h
YmxlX2EyMCh2b2lkKQogewotICAgICAgIGludCBsb29wcyA9IEEyMF9FTkFCTEVfTE9PUFM7Ci0g
ICAgICAgaW50IGtiY19lcnI7CisJaW50IGxvb3BzID0gQTIwX0VOQUJMRV9MT09QUzsKKwlpbnQg
a2JjX2VycjsKIAotICAgICAgIHdoaWxlIChsb29wcy0tKSB7Ci0JICAgICAgIC8qIEZpcnN0LCBj
aGVjayB0byBzZWUgaWYgQTIwIGlzIGFscmVhZHkgZW5hYmxlZAorCXdoaWxlIChsb29wcy0tKSB7
CisJCS8qIEZpcnN0LCBjaGVjayB0byBzZWUgaWYgQTIwIGlzIGFscmVhZHkgZW5hYmxlZAogCQkg
IChsZWdhY3kgZnJlZSwgZXRjLikgKi8KLQkgICAgICAgaWYgKGEyMF90ZXN0X3Nob3J0KCkpCi0J
CSAgICAgICByZXR1cm4gMDsKLQkgICAgICAgCisJCWlmIChhMjBfdGVzdF9zaG9ydCgpKQorCQkJ
cmV0dXJuIDA7CisKIAkgICAgICAgLyogTmV4dCwgdHJ5IHRoZSBCSU9TIChJTlQgMHgxNSwgQVg9
MHgyNDAxKSAqLwogCSAgICAgICBlbmFibGVfYTIwX2Jpb3MoKTsKLQkgICAgICAgaWYgKGEyMF90
ZXN0X3Nob3J0KCkpCi0JCSAgICAgICByZXR1cm4gMDsKLQkgICAgICAgCisJCWlmIChhMjBfdGVz
dF9zaG9ydCgpKQorCQkJcmV0dXJuIDA7CisKIAkgICAgICAgLyogVHJ5IGVuYWJsaW5nIEEyMCB0
aHJvdWdoIHRoZSBrZXlib2FyZCBjb250cm9sbGVyICovCiAJICAgICAgIGtiY19lcnIgPSBlbXB0
eV84MDQyKCk7CiAKLQkgICAgICAgaWYgKGEyMF90ZXN0X3Nob3J0KCkpCi0JCSAgICAgICByZXR1
cm4gMDsgLyogQklPUyB3b3JrZWQsIGJ1dCB3aXRoIGRlbGF5ZWQgcmVhY3Rpb24gKi8KLQkKLQkg
ICAgICAgaWYgKCFrYmNfZXJyKSB7Ci0JCSAgICAgICBlbmFibGVfYTIwX2tiYygpOwotCQkgICAg
ICAgaWYgKGEyMF90ZXN0X2xvbmcoKSkKLQkJCSAgICAgICByZXR1cm4gMDsKKwkJaWYgKGEyMF90
ZXN0X3Nob3J0KCkpCisJCQlyZXR1cm4gMDsgLyogQklPUyB3b3JrZWQsIGJ1dCB3aXRoIGRlbGF5
ZWQgcmVhY3Rpb24gKi8KKworCQlpZiAoIWtiY19lcnIpIHsKKwkJCWVuYWJsZV9hMjBfa2JjKCk7
CisJCQlpZiAoYTIwX3Rlc3RfbG9uZygpKQorCQkJCXJldHVybiAwOwogCSAgICAgICB9Ci0JICAg
ICAgIAorCiAJICAgICAgIC8qIEZpbmFsbHksIHRyeSBlbmFibGluZyB0aGUgImZhc3QgQTIwIGdh
dGUiICovCiAJICAgICAgIGVuYWJsZV9hMjBfZmFzdCgpOwotCSAgICAgICBpZiAoYTIwX3Rlc3Rf
bG9uZygpKQotCQkgICAgICAgcmV0dXJuIDA7Ci0gICAgICAgfQotICAgICAgIAotICAgICAgIHJl
dHVybiAtMTsKKwkJaWYgKGEyMF90ZXN0X2xvbmcoKSkKKwkJCXJldHVybiAwOworCX0KKworCXJl
dHVybiAtMTsKIH0KLS0gCjEuNy4yLjUKCg==
--001a11c2b9ecce222704dc1cc83e--

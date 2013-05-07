Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3EGNUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:20:52 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38259 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab3EGNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:20:51 -0400
From: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
Subject: [PATCH] x86, setup: Removed spaces, trailing character and suspect code indent warnings and errors in a20.c This is a patch to the a20.c file that fixes following warnings/errors found by the checkpatch.pl tool i)  WARNING: please, no spaces at the start of a line ii) WARNING: suspect code indent for conditional statements iii) ERROR: trailing whitespace
Date: Tue,  7 May 2013 18:20:22 +0500
Message-Id: <1367932822-31980-1-git-send-email-syed.salman.mansoor@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
---
 arch/x86/boot/a20.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 64a31a6..4565f4d 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -129,37 +129,37 @@ static void enable_a20_fast(void)
 
 int enable_a20(void)
 {
-       int loops = A20_ENABLE_LOOPS;
-       int kbc_err;
+	int loops = A20_ENABLE_LOOPS;
+	int kbc_err;
 
-       while (loops--) {
-	       /* First, check to see if A20 is already enabled
+	while (loops--) {
+		/* First, check to see if A20 is already enabled
 		  (legacy free, etc.) */
-	       if (a20_test_short())
-		       return 0;
-	       
+		if (a20_test_short())
+			return 0;
+
 	       /* Next, try the BIOS (INT 0x15, AX=0x2401) */
 	       enable_a20_bios();
-	       if (a20_test_short())
-		       return 0;
-	       
+		if (a20_test_short())
+			return 0;
+
 	       /* Try enabling A20 through the keyboard controller */
 	       kbc_err = empty_8042();
 
-	       if (a20_test_short())
-		       return 0; /* BIOS worked, but with delayed reaction */
-	
-	       if (!kbc_err) {
-		       enable_a20_kbc();
-		       if (a20_test_long())
-			       return 0;
+		if (a20_test_short())
+			return 0; /* BIOS worked, but with delayed reaction */
+
+		if (!kbc_err) {
+			enable_a20_kbc();
+			if (a20_test_long())
+				return 0;
 	       }
-	       
+
 	       /* Finally, try enabling the "fast A20 gate" */
-	       enable_a20_fast();
-	       if (a20_test_long())
-		       return 0;
-       }
-       
-       return -1;
+		enable_a20_fast();
+		if (a20_test_long())
+			return 0;
+	}
+
+	return -1;
 }
-- 
1.7.9.5


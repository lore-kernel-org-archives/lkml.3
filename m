Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3KRRvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:51:05 -0500
Received: from lucifer.kyriasis.com ([106.186.112.63]:43910 "EHLO kyriasis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab3KRRu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:50:58 -0500
From: =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
Subject: [PATCH] x86: boot: Fix mixed indentation in a20.c
Date: Mon, 18 Nov 2013 18:50:09 +0100
Message-Id: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all mixed indentation with tabs

Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
---
 arch/x86/boot/a20.c | 62 ++++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 64a31a6..c837ac6 100644
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
-	       /* Next, try the BIOS (INT 0x15, AX=0x2401) */
-	       enable_a20_bios();
-	       if (a20_test_short())
-		       return 0;
-	       
-	       /* Try enabling A20 through the keyboard controller */
-	       kbc_err = empty_8042();
-
-	       if (a20_test_short())
-		       return 0; /* BIOS worked, but with delayed reaction */
-	
-	       if (!kbc_err) {
-		       enable_a20_kbc();
-		       if (a20_test_long())
-			       return 0;
-	       }
-	       
-	       /* Finally, try enabling the "fast A20 gate" */
-	       enable_a20_fast();
-	       if (a20_test_long())
-		       return 0;
-       }
-       
-       return -1;
+		if (a20_test_short())
+			return 0;
+
+		/* Next, try the BIOS (INT 0x15, AX=0x2401) */
+		enable_a20_bios();
+		if (a20_test_short())
+			return 0;
+
+		/* Try enabling A20 through the keyboard controller */
+		kbc_err = empty_8042();
+
+		if (a20_test_short())
+			return 0; /* BIOS worked, but with delayed reaction */
+
+		if (!kbc_err) {
+			enable_a20_kbc();
+			if (a20_test_long())
+				return 0;
+		}
+
+		/* Finally, try enabling the "fast A20 gate" */
+		enable_a20_fast();
+		if (a20_test_long())
+			return 0;
+	}
+
+	return -1;
 }
-- 
1.8.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaHQInv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 04:43:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37484 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaHQInt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 04:43:49 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE: clean up trivial coding style problem
Date: Sun, 17 Aug 2014 16:43:15 +0800
Message-Id: <1408264995-7157-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of white-spaces that against the rule of coding style
in __mcheck_cpu_apply_quirks(). This problem had been introduced by
'575203b4747c(x86, MCE, AMD: Disable error thresholding bank 4
on some models)' and '2e6f694fde0a(x86, mce: port K7 bank 0 quirk
to 64bit mce code)'

This may be an insignificant patch. However, if we allow them continue
to survive, then this may make someone uncomfortable.


Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   54 +++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd9ccda..0d15f72 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1530,45 +1530,45 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 * Various K7s with broken bank 0 around. Always disable
 		 * by default.
 		 */
-		 if (c->x86 == 6 && cfg->banks > 0)
+		if (c->x86 == 6 && cfg->banks > 0)
 			mce_banks[0].ctl = 0;
 
-		 /*
-		  * Turn off MC4_MISC thresholding banks on those models since
-		  * they're not supported there.
-		  */
-		 if (c->x86 == 0x15 &&
-		     (c->x86_model >= 0x10 && c->x86_model <= 0x1f)) {
-			 int i;
-			 u64 val, hwcr;
-			 bool need_toggle;
-			 u32 msrs[] = {
+		/*
+		 * Turn off MC4_MISC thresholding banks on those models since
+		 * they're not supported there.
+		 */
+		if (c->x86 == 0x15 &&
+		    (c->x86_model >= 0x10 && c->x86_model <= 0x1f)) {
+			int i;
+			u64 val, hwcr;
+			bool need_toggle;
+			u32 msrs[] = {
 				0x00000413, /* MC4_MISC0 */
 				0xc0000408, /* MC4_MISC1 */
-			 };
+			};
 
-			 rdmsrl(MSR_K7_HWCR, hwcr);
+			rdmsrl(MSR_K7_HWCR, hwcr);
 
-			 /* McStatusWrEn has to be set */
-			 need_toggle = !(hwcr & BIT(18));
+			/* McStatusWrEn has to be set */
+			need_toggle = !(hwcr & BIT(18));
 
-			 if (need_toggle)
-				 wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
+			if (need_toggle)
+				wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
 
-			 for (i = 0; i < ARRAY_SIZE(msrs); i++) {
-				 rdmsrl(msrs[i], val);
+			for (i = 0; i < ARRAY_SIZE(msrs); i++) {
+				rdmsrl(msrs[i], val);
 
-				 /* CntP bit set? */
-				 if (val & BIT_64(62)) {
+				/* CntP bit set? */
+				if (val & BIT_64(62)) {
 					val &= ~BIT_64(62);
 					wrmsrl(msrs[i], val);
-				 }
-			 }
+				}
+			}
 
-			 /* restore old settings */
-			 if (need_toggle)
-				 wrmsrl(MSR_K7_HWCR, hwcr);
-		 }
+			/* restore old settings */
+			if (need_toggle)
+				wrmsrl(MSR_K7_HWCR, hwcr);
+		}
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
-- 
1.7.10.4


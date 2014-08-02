Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaHBOol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 10:44:41 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57294 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaHBOoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 10:44:39 -0400
From: Daniele Forsi <dforsi@gmail.com>
To: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Cc: Daniele Forsi <dforsi@gmail.com>
Subject: [PATCH] arch/x86/kernel/cpu/cyrix.c: remove redundant code
Date: Sat,  2 Aug 2014 16:44:31 +0200
Message-Id: <1406990672-2382-1-git-send-email-dforsi@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function doesn't read dir1 so it doesn't need to set a default
value and code for case 3 and case 5 is identical so replace it with
a "fall through" comment.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
---
 arch/x86/kernel/cpu/cyrix.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index aaf152e..6026664 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -167,16 +167,14 @@ static void geode_configure(void)
 
 static void early_init_cyrix(struct cpuinfo_x86 *c)
 {
-	unsigned char dir0, dir0_msn, dir1 = 0;
+	unsigned char dir0, dir0_msn, dir1;
 
 	__do_cyrix_devid(&dir0, &dir1);
 	dir0_msn = dir0 >> 4; /* identifies CPU "family"   */
 
 	switch (dir0_msn) {
 	case 3: /* 6x86/6x86L */
-		/* Emulate MTRRs using Cyrix's ARRs. */
-		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
-		break;
+		/* Fall through */
 	case 5: /* 6x86MX/M II */
 		/* Emulate MTRRs using Cyrix's ARRs. */
 		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
-- 
2.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaHPNSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 09:18:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39495 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaHPNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 09:18:05 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE: eliminate the strange combination of return and break
Date: Sat, 16 Aug 2014 21:17:30 +0800
Message-Id: <1408195050-5626-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What do you feel when you see the code snippet like that shown below?

        switch (c) {
        case X:
                ... ...
                return 1;
                break;
        case Y:
                ... ...
                return 1;
                break;
        }

All in all, in many ways I'm not feeling well. I think a small change
is needed here. This patch aims to eliminate the strange combination of
*return* and *break* in the above switch-statement.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd9ccda..5915be5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1618,15 +1618,15 @@ static int __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
-		return 1;
 		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
-		return 1;
 		break;
+	default:
+		return 0;
 	}
 
-	return 0;
+	return 1;
 }
 
 static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
-- 
1.7.10.4


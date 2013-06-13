Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3FMMXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:23:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31966 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab3FMMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:28 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 06/10] metag/setup: Restrict scope for the capabilities variable
Date: Thu, 13 Jun 2013 13:19:37 +0100
Message-ID: <1371125981-5184-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/setup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index e18cebb..c396cd0 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -591,20 +591,20 @@ PTBI pTBI_get(unsigned int cpu)
 EXPORT_SYMBOL(pTBI_get);
 
 #if defined(CONFIG_METAG_DSP) && defined(CONFIG_METAG_FPU)
-char capabilites[] = "dsp fpu";
+static char capabilities[] = "dsp fpu";
 #elif defined(CONFIG_METAG_DSP)
-char capabilites[] = "dsp";
+static char capabilities[] = "dsp";
 #elif defined(CONFIG_METAG_FPU)
-char capabilites[] = "fpu";
+static char capabilities[] = "fpu";
 #else
-char capabilites[] = "";
+static char capabilities[] = "";
 #endif
 
 static struct ctl_table caps_kern_table[] = {
 	{
 		.procname	= "capabilities",
-		.data		= capabilites,
-		.maxlen		= sizeof(capabilites),
+		.data		= capabilities,
+		.maxlen		= sizeof(capabilities),
 		.mode		= 0444,
 		.proc_handler	= proc_dostring,
 	},
-- 
1.8.1.2



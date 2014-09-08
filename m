Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaIHRs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:48:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40047 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbaIHRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:56 -0400
X-Sasl-enc: EZYxsx7MYWkx6wI+ODtLJPELBROarOk9Hyh/hjY1arAS 1410197886
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 8/8] x86, microcode, intel: defend apply_microcode_intel with BUG_ON
Date: Mon,  8 Sep 2014 14:37:54 -0300
Message-Id: <1410197875-19252-9-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcode updates that requires an unknown loader should never reach the
apply_* functions (the code should have rejected it earlier).  Likewise
for an unknown microcode header layout.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel.c       |    2 ++
 arch/x86/kernel/cpu/microcode/intel_early.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 40caef1..439681f 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -157,6 +157,8 @@ static int apply_microcode_intel(int cpu)
 	if (mc_intel == NULL)
 		return 0;
 
+	BUG_ON(mc_intel->hdr.hdrver != 1 || mc_intel->hdr.ldrver != 1);
+
 	/* Intel SDM vol 3A section 9.11.6, page 9-34 */
 	if (WARN_ONCE((unsigned long)(mc_intel->bits) % 16,
 		"microcode data incorrectly aligned"))
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 994c59b..095db11 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -671,6 +671,8 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 	if (mc_intel == NULL)
 		return 0;
 
+	BUG_ON(mc_intel->hdr.hdrver != 1 || mc_intel->hdr.ldrver != 1);
+
 	mcu_data = mc_intel->bits;
 	aligned_mcu_data = mc_intel->bits;
 
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbbAGFwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:52:30 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40737 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbbAGFwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:52:25 -0500
From: Leo Yan <leo.yan@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>, Xiaolong Ye <yexl@marvell.com>
Subject: [PATCH] arm64: mm: support instruction SETEND
Date: Wed,  7 Jan 2015 13:52:10 +0800
Message-Id: <1420609930-1689-1-git-send-email-leo.yan@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernel has set the bit SCTLR_EL1.SED, so the SETEND
instruction will be treated as UNALLOCATED; this error can be
reproduced when ARMv8 cpu runs with EL1/aarch64 and EL0/aarch32
mode, finally kernel will trap the exception if the userspace
libs use SETEND instruction.

So this patch clears bit SCTLR_EL1.SED to support SETEND instruction.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Xiaolong Ye <yexl@marvell.com>
---
 arch/arm64/mm/proc.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 4e778b1..66a7363 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -249,9 +249,9 @@ ENDPROC(__cpu_setup)
 	 *       CE0      XWHW CZ     ME TEEA S
 	 * .... .IEE .... NEAI TE.I ..AD DEN0 ACAM
 	 * 0011 0... 1101 ..0. ..0. 10.. .... .... < hardware reserved
-	 * .... .1.. .... 01.1 11.1 ..01 0001 1101 < software settings
+	 * .... .1.. .... 01.1 11.1 ..00 0001 1101 < software settings
 	 */
 	.type	crval, #object
 crval:
-	.word	0x000802e2			// clear
-	.word	0x0405d11d			// set
+	.word	0x000803e2			// clear
+	.word	0x0405d01d			// set
-- 
1.9.1


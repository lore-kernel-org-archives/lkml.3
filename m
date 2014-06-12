Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbaFLPc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:32:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43423 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaFLPcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:32:23 -0400
From: Andy Hsu <andy.jhshiu@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Cc: Andy Hsu <andy.jhshiu@gmail.com>
Subject: [PATCH 1/1] Remove an extra operation: The ESR has been stored into x1, and should be directly pass to do_sp_pc_abort function
Date: Thu, 12 Jun 2014 08:32:12 -0700
Message-Id: <1402587132-4853-1-git-send-email-andy.jhshiu@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andy Hsu <andy.jhshiu@gmail.com>
---
 arch/arm64/kernel/entry.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index fa78916..56ef569 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -275,7 +275,6 @@ el1_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x0, far_el1
-	mov	x1, x25
 	mov	x2, sp
 	b	do_sp_pc_abort
 el1_undef:
-- 
1.7.0.4


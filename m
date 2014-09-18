Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbaIRVnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:43:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36116 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbaIRVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:43:17 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/3] ARM: vfp: Workaround bad MVFR1 register on some Kraits
Date: Thu, 18 Sep 2014 14:43:10 -0700
Message-Id: <1411076592-6157-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain versions of the Krait processor don't report that they
support the fused multiply accumulate instruction via the MVFR1
register despite the fact that they actually do. Unfortunately we
use this register to identify support for VFPv4. Override the
hwcap on all Krait processors to indicate support for VFPv4 to
workaround this.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mm/proc-v7.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 3db2c2f04a30..3fd22f79a013 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -547,9 +547,10 @@ __krait_proc_info:
 	/*
 	 * Some Krait processors don't indicate support for SDIV and UDIV
 	 * instructions in the ARM instruction set, even though they actually
-	 * do support them.
+	 * do support them. They also don't indicate support for fused multiply
+	 * instructions even though they actually do support them.
 	 */
-	__v7_proc __v7_setup, hwcaps = HWCAP_IDIV
+	__v7_proc __v7_setup, hwcaps = HWCAP_IDIV | HWCAP_VFPv4
 	.size	__krait_proc_info, . - __krait_proc_info
 
 	/*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


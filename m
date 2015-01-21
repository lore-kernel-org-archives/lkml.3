Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbbAUTss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:48:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51981 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbbAUTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:48:20 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/2] ARM: Add a secondary_startup that assumes ARM mode
Date: Wed, 21 Jan 2015 11:48:17 -0800
Message-Id: <1421869698-27341-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
In-Reply-To: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
References: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms always enter the kernel in ARM mode even if the
kernel is compiled for THUMB2. Add a small wrapper on top of
secondary_startup() that switches into THUMB2 mode.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/head.S | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 664eee8c4a26..22bb6d54e90d 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -346,6 +346,12 @@ __turn_mmu_on_loc:
 
 #if defined(CONFIG_SMP)
 	.text
+ENTRY(secondary_startup_arm)
+	.arm
+ THUMB(	adr	r9, BSYM(1f)	)	@ Kernel is entered in ARM.
+ THUMB(	bx	r9		)	@ If this is a Thumb-2 kernel,
+ THUMB(	.thumb			)	@ switch to Thumb now.
+ THUMB(1:			)
 ENTRY(secondary_startup)
 	/*
 	 * Common entry point for secondary CPUs.
@@ -385,6 +391,7 @@ ENTRY(secondary_startup)
  THUMB(	add	r12, r10, #PROCINFO_INITFUNC	)
  THUMB(	ret	r12				)
 ENDPROC(secondary_startup)
+ENDPROC(secondary_startup_arm)
 
 	/*
 	 * r6  = &secondary_data
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


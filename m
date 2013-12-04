Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab3LDTk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:40:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52119 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab3LDTjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:39:17 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/5] ARM: msm: Only build clock.c on proc_comm based platforms
Date: Wed,  4 Dec 2013 11:39:10 -0800
Message-Id: <1386185952-27259-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.19.gdaad3aa
In-Reply-To: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality provided by clock.c in mach-msm is only needed
on proc_comm based platforms. Only build the file if proc_comm is
enabled. This prevents compile failures for platforms that are
part of the multi-platform kernel.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 7ed4c1b..6baae6e 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,5 +1,5 @@
 obj-y += timer.o
-obj-y += clock.o
+obj-$(CONFIG_MSM_PROC_COMM) += clock.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


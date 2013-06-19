Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab3FSAFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:05:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35535 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab3FSAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:48 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC/PATCH 10/11] ARM: msm: Only build clock.c on proc_comm based platforms
Date: Tue, 18 Jun 2013 17:04:40 -0700
Message-Id: <1371600281-6118-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality provided by clock.c in mach-msm is only needed
on proc_comm based platforms. Only build the file if proc_comm is
enabled. This prevents compile failures for platforms that are
part of the multi-platform kernel.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This patch also breaks compile for msm_sdcc and usb because clk_reset
no longer exists.

 arch/arm/mach-msm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index d872634c..4801a25 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab3LDTjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:39:24 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52107 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3LDTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:39:16 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>
Subject: [PATCH 1/5] mmc: msm_sdcc: Limit driver to platforms that use it
Date: Wed,  4 Dec 2013 11:39:08 -0800
Message-Id: <1386185952-27259-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.19.gdaad3aa
In-Reply-To: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm_sdcc driver uses mach specific dma APIs. This is not
compatible with the multi-platform ARM effort. Let's only compile
this driver on MSM devices that are prepared to support it,
allowing the DT based MSM devices to enter the multi-platform ARM
build.

Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mmc/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 7fc5099..4e8ca9d 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -324,7 +324,7 @@ config MMC_ATMELMCI
 
 config MMC_MSM
 	tristate "Qualcomm SDCC Controller Support"
-	depends on MMC && ARCH_MSM
+	depends on MMC && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
 	help
 	  This provides support for the SD/MMC cell found in the
 	  MSM and QSD SOCs from Qualcomm. The controller also has
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


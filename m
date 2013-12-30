Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3L3VPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:15:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40054 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3L3VPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:15:37 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v2 3/7] tty: serial: Limit msm_serial_hs driver to platforms that use it
Date: Mon, 30 Dec 2013 13:15:29 -0800
Message-Id: <1388438133-431-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm_serial_hs driver uses mach specific dma APIs. This is not
compatible with the multi-platform ARM effort. Let's only compile
this driver on MSM devices that are prepared to support it;
allowing the DT based MSM devices to enter the multi-platform ARM
build.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index a3817ab..a53159c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1035,7 +1035,7 @@ config SERIAL_MSM_CONSOLE
 
 config SERIAL_MSM_HS
 	tristate "MSM UART High Speed: Serial Driver"
-	depends on ARCH_MSM
+	depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
 	select SERIAL_CORE
 	help
 	  If you have a machine based on MSM family of SoCs, you
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


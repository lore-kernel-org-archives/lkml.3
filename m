Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab3LDTj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:39:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52111 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3LDTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:39:16 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/5] tty: serial: Limit msm_serial_hs driver to platforms that use it
Date: Wed,  4 Dec 2013 11:39:09 -0800
Message-Id: <1386185952-27259-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.19.gdaad3aa
In-Reply-To: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm_serial_hs driver uses mach specific dma APIs. This is not
compatible with the multi-platform ARM effort. Let's only compile
this driver on MSM devices that are prepared to support it;
allowing the DT based MSM devices to enter the multi-platform ARM
build.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


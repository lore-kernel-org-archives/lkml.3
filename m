Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaGaEbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 00:31:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46175 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaGaEa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 00:30:26 -0400
From: Kever Yang <kever.yang@gmail.com>
X-Google-Original-From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, wulf@rock-chips.com, lyz@rock-chips.com,
        hj@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] usb: dwc2: add compatible data for rockchip soc
Date: Wed, 30 Jul 2014 21:29:57 -0700
Message-Id: <1406780999-17798-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406780999-17798-1-git-send-email-kever.yang@rock-chips.com>
References: <1406780999-17798-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add compatible data for dwc2 controller found on
rk3066, rk3188 and rk3288 processors from rockchip.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v2:
- set most parameters as driver auto-detect

 drivers/usb/dwc2/platform.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 5f0c4bb..5e610dd 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -77,6 +77,34 @@ static const struct dwc2_core_params params_bcm2835 = {
 	.uframe_sched			= 0,
 };
 
+static const struct dwc2_core_params params_rk3066 = {
+	.otg_cap			= 2,	/* non-HNP/non-SRP */
+	.otg_ver			= -1,
+	.dma_enable			= -1,
+	.dma_desc_enable		= 0,
+	.speed				= -1,
+	.enable_dynamic_fifo		= 1,
+	.en_multiple_tx_fifo		= -1,
+	.host_rx_fifo_size		= 520,	/* 520 DWORDs */
+	.host_nperio_tx_fifo_size	= 128,	/* 128 DWORDs */
+	.host_perio_tx_fifo_size	= 256,	/* 256 DWORDs */
+	.max_transfer_size		= -1,
+	.max_packet_count		= -1,
+	.host_channels			= -1,
+	.phy_type			= -1,
+	.phy_utmi_width			= -1,
+	.phy_ulpi_ddr			= -1,
+	.phy_ulpi_ext_vbus		= -1,
+	.i2c_enable			= -1,
+	.ulpi_fs_ls			= -1,
+	.host_support_fs_ls_low_power	= -1,
+	.host_ls_low_power_phy_clk	= -1,
+	.ts_dline			= -1,
+	.reload_ctl			= -1,
+	.ahbcfg				= 0x7, /* INCR16 */
+	.uframe_sched			= -1,
+};
+
 /**
  * dwc2_driver_remove() - Called when the DWC_otg core is unregistered with the
  * DWC_otg driver
@@ -99,6 +127,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
 
 static const struct of_device_id dwc2_of_match_table[] = {
 	{ .compatible = "brcm,bcm2835-usb", .data = &params_bcm2835 },
+	{ .compatible = "rockchip,rk3066-usb", .data = &params_rk3066 },
 	{ .compatible = "snps,dwc2", .data = NULL },
 	{},
 };
-- 
1.7.9.5


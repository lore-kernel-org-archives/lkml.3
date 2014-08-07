Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbaHGJfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:35:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62399 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaHGJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:35:29 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>, heiko@sntech.de
Cc: dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org,
        addy.ke@rock-chips.com, cf@rock-chips.com, xjq@rock-chips.com,
        wulf@rock-chips.com, lyz@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
Date: Thu,  7 Aug 2014 17:34:53 +0800
Message-Id: <1407404095-3265-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add compatible data for dwc2 controller found on
rk3066, rk3188 and rk3288 processors from rockchip.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---

Changes in v4:
- max_transfer_size change to 65536, this should be enough
  for most transfer, the hardware auto-detect will set this
  to 0x7ffff which may make dma_alloc_coherent fail when
  non-dword aligned buf from driver like usbnet happen.

Changes in v3: None
Changes in v2:
- set most parameters as driver auto-detect

 drivers/usb/dwc2/platform.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index a10e7a3..832b103 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -75,6 +75,34 @@ static const struct dwc2_core_params params_bcm2835 = {
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
+	.max_transfer_size		= 65536,
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
@@ -97,6 +125,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
 
 static const struct of_device_id dwc2_of_match_table[] = {
 	{ .compatible = "brcm,bcm2835-usb", .data = &params_bcm2835 },
+	{ .compatible = "rockchip,rk3066-usb", .data = &params_rk3066 },
 	{ .compatible = "snps,dwc2", .data = NULL },
 	{},
 };
-- 
1.9.1


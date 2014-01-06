Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbaAFXvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:51:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbaAFWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Nelson <eric.nelson@boundarydevices.com>,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhu <r65037@freescale.com>,
        Linux-IDE <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 097/144] ahci: imx: Explicitly clear IMX6Q_GPR13_SATA_MPLL_CLK_EN
Date: Mon,  6 Jan 2014 14:37:38 -0800
Message-Id: <20140106223748.140256754@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 10becdb402af4fd4808a0491a726b96128c41076 upstream.

We must clear this IMX6Q_GPR13_SATA_MPLL_CLK_EN bit on i.MX6Q, otherwise
Linux will fail to find the attached drive on some boards.

This entire fix was:
Reported-by: Eric Nelson <eric.nelson@boundarydevices.com>

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Richard Zhu <r65037@freescale.com>
Cc: Linux-IDE <linux-ide@vger.kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -60,7 +60,7 @@ static int imx6q_sata_init(struct device
 	/*
 	 * set PHY Paremeters, two steps to configure the GPR13,
 	 * one write for rest of parameters, mask of first write
-	 * is 0x07fffffd, and the other one write for setting
+	 * is 0x07ffffff, and the other one write for setting
 	 * the mpll_clk_en.
 	 */
 	regmap_update_bits(imxpriv->gpr, 0x34, IMX6Q_GPR13_SATA_RX_EQ_VAL_MASK
@@ -71,6 +71,7 @@ static int imx6q_sata_init(struct device
 			| IMX6Q_GPR13_SATA_TX_ATTEN_MASK
 			| IMX6Q_GPR13_SATA_TX_BOOST_MASK
 			| IMX6Q_GPR13_SATA_TX_LVL_MASK
+			| IMX6Q_GPR13_SATA_MPLL_CLK_EN
 			| IMX6Q_GPR13_SATA_TX_EDGE_RATE
 			, IMX6Q_GPR13_SATA_RX_EQ_VAL_3_0_DB
 			| IMX6Q_GPR13_SATA_RX_LOS_LVL_SATA2M



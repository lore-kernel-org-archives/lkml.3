Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbbALTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:16:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbALSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 010/216] [media] smiapp-pll: Correct clock debug prints
Date: Mon, 12 Jan 2015 18:02:07 +0000
Message-Id: <1421085933-32536-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit bc47150ab93988714d1fab7bc82fe5f505a107ad upstream.

The PLL flags were not used correctly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/i2c/smiapp-pll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 2335529b195c..ab5d9a3adebf 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -67,7 +67,7 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 {
 	dev_dbg(dev, "pre_pll_clk_div\t%d\n",  pll->pre_pll_clk_div);
 	dev_dbg(dev, "pll_multiplier \t%d\n",  pll->pll_multiplier);
-	if (pll->flags != SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
 		dev_dbg(dev, "op_sys_clk_div \t%d\n", pll->op_sys_clk_div);
 		dev_dbg(dev, "op_pix_clk_div \t%d\n", pll->op_pix_clk_div);
 	}
@@ -77,7 +77,7 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "ext_clk_freq_hz \t%d\n", pll->ext_clk_freq_hz);
 	dev_dbg(dev, "pll_ip_clk_freq_hz \t%d\n", pll->pll_ip_clk_freq_hz);
 	dev_dbg(dev, "pll_op_clk_freq_hz \t%d\n", pll->pll_op_clk_freq_hz);
-	if (pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
 		dev_dbg(dev, "op_sys_clk_freq_hz \t%d\n",
 			pll->op_sys_clk_freq_hz);
 		dev_dbg(dev, "op_pix_clk_freq_hz \t%d\n",
-- 
2.1.4


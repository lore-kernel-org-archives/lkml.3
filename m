Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaBJTKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:10:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBJTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:10:10 -0500
From: Colin King <colin.king@canonical.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: omap-usb-tll: allocate correct size for ch_clk
Date: Mon, 10 Feb 2014 19:10:07 +0000
Message-Id: <1392059407-15452-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

ch_clk was erroneously being allocated the incorrect size which
can be problematic for larger sizes of tll->nch

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/mfd/omap-usb-tll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 5ee50f7..532eacab 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -252,7 +252,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
-	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
+	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk *) * tll->nch,
 						GFP_KERNEL);
 	if (!tll->ch_clk) {
 		ret = -ENOMEM;
-- 
1.9.rc1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaBKJi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:38:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKJi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:38:56 -0500
From: Colin King <colin.king@canonical.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: rogerq@ti.com
Subject: [PATCH][v2] mfd: omap-usb-tll: fix cppcheck sizeof warning
Date: Tue, 11 Feb 2014 09:38:53 +0000
Message-Id: <1392111533-23053-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Static analysis from cppcheck issued the following warning:

[drivers/mfd/omap-usb-tll.c:255]: (warning) Found calculation
  inside sizeof().

The current size calculation is not obvious and is easy to
miscomprehend, so re-work the size of the allocation based
on the size of the struct pointer and quantity to allocate.

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


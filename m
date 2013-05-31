Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3EaMBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:01:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54589 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3EaMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:01:32 -0400
MIME-Version: 1.0
Date: Fri, 31 May 2013 20:01:30 +0800
Message-ID: <CAPgLHd8ULtaP23U96nygh-Sr6ySS4-aOuuK3NkvGz1bGj8Dh_A@mail.gmail.com>
Subject: [PATCH] pcie-gadget-spear: fix error return code in spear_pcie_gadget_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the clk_get_sys() and clk_enable()
error handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/spear13xx_pcie_gadget.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 7deb25d..288c35b 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -814,9 +814,11 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 		clk = clk_get_sys("pcie1", NULL);
 		if (IS_ERR(clk)) {
 			pr_err("%s:couldn't get clk for pcie1\n", __func__);
+			status = PTR_ERR(clk);
 			goto err_irq;
 		}
-		if (clk_enable(clk)) {
+		status = clk_enable(clk);
+		if (status) {
 			pr_err("%s:couldn't enable clk for pcie1\n", __func__);
 			goto err_irq;
 		}
@@ -828,9 +830,11 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 		clk = clk_get_sys("pcie2", NULL);
 		if (IS_ERR(clk)) {
 			pr_err("%s:couldn't get clk for pcie2\n", __func__);
+			status = PTR_ERR(clk);
 			goto err_irq;
 		}
-		if (clk_enable(clk)) {
+		status = clk_enable(clk);
+		if (status) {
 			pr_err("%s:couldn't enable clk for pcie2\n", __func__);
 			goto err_irq;
 		}


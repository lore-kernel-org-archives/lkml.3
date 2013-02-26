Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab3B0Ai0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:38:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab3BZX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [ 150/150] usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
Date: Tue, 26 Feb 2013 15:56:47 -0800
Message-Id: <20130226235540.178907541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Baltieri <fabio.baltieri@linaro.org>

commit 99d17cfa3bbc6f4edb175f819af59c6b9e245e82 upstream.

This patch converts the module to use clk_prepare_enable and
clk_disable_unprepare variants as required by common clock framework.

Without this the system crash during probe function.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/ux500.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -108,7 +108,7 @@ static int ux500_probe(struct platform_d
 		goto err3;
 	}
 
-	ret = clk_enable(clk);
+	ret = clk_prepare_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
 		goto err4;
@@ -148,7 +148,7 @@ static int ux500_probe(struct platform_d
 	return 0;
 
 err5:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 
 err4:
 	clk_put(clk);
@@ -168,7 +168,7 @@ static int ux500_remove(struct platform_
 	struct ux500_glue	*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
-	clk_disable(glue->clk);
+	clk_disable_unprepare(glue->clk);
 	clk_put(glue->clk);
 	kfree(glue);
 
@@ -182,7 +182,7 @@ static int ux500_suspend(struct device *
 	struct musb		*musb = glue_to_musb(glue);
 
 	usb_phy_set_suspend(musb->xceiv, 1);
-	clk_disable(glue->clk);
+	clk_disable_unprepare(glue->clk);
 
 	return 0;
 }
@@ -193,7 +193,7 @@ static int ux500_resume(struct device *d
 	struct musb		*musb = glue_to_musb(glue);
 	int			ret;
 
-	ret = clk_enable(glue->clk);
+	ret = clk_prepare_enable(glue->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clock\n");
 		return ret;



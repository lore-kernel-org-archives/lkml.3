Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3LBUSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:18:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3LBTRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.12 044/212] gpio: rcar: NULL dereference on error in probe()
Date: Mon,  2 Dec 2013 11:13:55 -0800
Message-Id: <20131202191253.248957041@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0c8aab8e65e450f2bfea494c1b6a86ded653f88c upstream.

It's not obvious from the label name but "err1" tries to release
"p->irq_domain" which leads to a NULL dereference.

Fixes: 119f5e448d32 ('gpio: Renesas R-Car GPIO driver V3')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-rcar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -380,7 +380,7 @@ static int gpio_rcar_probe(struct platfo
 	if (!p->irq_domain) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
-		goto err1;
+		goto err0;
 	}
 
 	if (devm_request_irq(&pdev->dev, irq->start,



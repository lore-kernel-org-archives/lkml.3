Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3LFOMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:12:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161264Ab3LFNAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 048/272] gpio: rcar: NULL dereference on error in probe()
Date: Fri,  6 Dec 2013 12:55:37 +0000
Message-Id: <1386334761-25517-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0c8aab8e65e450f2bfea494c1b6a86ded653f88c upstream.

It's not obvious from the label name but "err1" tries to release
"p->irq_domain" which leads to a NULL dereference.

Fixes: 119f5e448d32 ('gpio: Renesas R-Car GPIO driver V3')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-rcar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index e8198dd..e73f437 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -381,7 +381,7 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 	if (!p->irq_domain) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
-		goto err1;
+		goto err0;
 	}
 
 	if (devm_request_irq(&pdev->dev, irq->start,
-- 
1.8.3.2


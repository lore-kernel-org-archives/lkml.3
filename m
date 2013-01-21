Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3AUKRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:17:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3AUKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:45 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 17/33] misc: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:10 +0100
Message-Id: <1358762966-20791-18-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:Ce6LymJvRBZUTxVwpCdPmgjhu5bk+Cvolyi16M19lr2
 zgqYAp1tI4KaYdtq+pqnN2HuPkZbZh+RJM7oyKnDiiZzDiMjxr
 svQSbIMHoXjrmuQBUIWwXLjzeBvi2gucGf4jkZLvWqYYW3GlH2
 UG+pUz2xgSILCzuK2X9PkTzLOmzzuhaLi3aDsiSxxCV7zYns5L
 ZdoCBe7c/YdoaJVy/Vj77WsE/OK1CxPoJqBjXn/gIIzYJKgWGS
 ealRd4dFZTZilxfP7wrJgY1p/0hmcxbjrOO8A644PgJAbItprU
 3okyGMAz+sZDi/DDVhif0PduGMo69UddYLKSohto3JLrdeIA/U
 NpQ0MElqtZ+OoD+PM7aCX11J0Xlw0a+5Y0Cy7PkS8EGwsVZ6R9
 OM6pN3L6GdX7eToncvVu4iHTVNxf30XXP7dZaftedn9t7fccTr
 3/4Jv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/misc/atmel-ssc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 3c09cbb..c208238 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -159,11 +159,9 @@ static int ssc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	ssc->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!ssc->regs) {
-		dev_dbg(&pdev->dev, "ioremap failed\n");
-		return -EINVAL;
-	}
+	ssc->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(ssc->regs))
+		return PTR_ERR(ssc->regs);
 
 	ssc->phybase = regs->start;
 
-- 
1.8.1.1


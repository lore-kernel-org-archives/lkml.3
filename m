Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbaJ3LhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:37:00 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759296AbaJ3Lg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:56 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_zevio
Date: Thu, 30 Oct 2014 12:36:46 +0100
Message-Id: <1414669007-9850-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced ci_hdrc_get_platdata function to help setup the
chipidea internal ci_hdrc_platform_data structure.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci_hdrc_zevio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_zevio.c b/drivers/usb/chipidea/ci_hdrc_zevio.c
index 3bf6489ef5ec..d50a6d9038bd 100644
--- a/drivers/usb/chipidea/ci_hdrc_zevio.c
+++ b/drivers/usb/chipidea/ci_hdrc_zevio.c
@@ -25,12 +25,16 @@ static struct ci_hdrc_platform_data ci_hdrc_zevio_platdata = {
 static int ci_hdrc_zevio_probe(struct platform_device *pdev)
 {
 	struct platform_device *ci_pdev;
+	struct ci_hdrc_platform_data *ci_pdata;
 
 	dev_dbg(&pdev->dev, "ci_hdrc_zevio_probe\n");
 
+	ci_pdata = ci_hdrc_get_platdata(&pdev->dev, &ci_hdrc_zevio_platdata);
+	if (IS_ERR(ci_pdata))
+		return PTR_ERR(ci_pdata);
+
 	ci_pdev = ci_hdrc_add_device(&pdev->dev,
-				pdev->resource, pdev->num_resources,
-				&ci_hdrc_zevio_platdata);
+				pdev->resource, pdev->num_resources, ci_pdata);
 
 	if (IS_ERR(ci_pdev)) {
 		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
-- 
2.1.0


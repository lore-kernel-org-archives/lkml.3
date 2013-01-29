Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3A2P4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:56:08 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:54415 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3A2P4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:56:07 -0500
X-Auth-Info: irU34mVHTzSR26D1VLN3RWCO7Op2y1AuPBLpC4u7AVU=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] uio_pdrv_genirq: don't re-setup irq if already configured by OF
Date: Tue, 29 Jan 2013 16:55:59 +0100
Message-Id: <1359474959-1708-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an OF node doesn't specify an interrupt property, 'uioinfo->irq'
will be assigned to the UIO_IRQ_NONE value meaning no interrupt
support. Trying to re-setup the irq later results in an error again
and probing fails. To prevent this do not try to re-setup the irq
if it was configured to UIO_IRQ_NONE by OF related code.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/uio/uio_pdrv_genirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index c122bca..16f7ae4 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -146,7 +146,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	priv->flags = 0; /* interrupt is enabled to begin with */
 	priv->pdev = pdev;
 
-	if (!uioinfo->irq) {
+	if (!pdev->dev.of_node && !uioinfo->irq) {
 		ret = platform_get_irq(pdev, 0);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");
-- 
1.7.5.4


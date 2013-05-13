Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3EMPTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:19:07 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34762 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3EMPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:19:05 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: wg@grandegger.com, mkl@pengutronix.de
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: net: can: grcan: use devm_ioremap_resource()
Date: Mon, 13 May 2013 17:27:51 +0200
Message-Id: <1368458871-7402-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
dev_err() message is no more needed since it's already displayed in
devm_ioremap_resource().

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/net/can/grcan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 17fbc7a..9e9d0d6 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1683,10 +1683,9 @@ static int grcan_probe(struct platform_device *ofdev)
 	}
 
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(&ofdev->dev, res);
-	if (!base) {
-		dev_err(&ofdev->dev, "couldn't map IO resource\n");
-		err = -EADDRNOTAVAIL;
+	base = devm_ioremap_resource(&ofdev->dev, res);
+	if (IS_ERR(base)) {
+		err = PTR_ERR(base);
 		goto exit_error;
 	}
 
-- 
1.7.10.4


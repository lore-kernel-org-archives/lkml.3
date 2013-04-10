Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936372Ab3DJU7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:59:43 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:51962 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760339Ab3DJU7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:59:30 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: media: platform: convert to devm_ioremap_resource()
Date: Wed, 10 Apr 2013 23:59:25 +0300
Message-Id: <1365627565-17401-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/media/platform/sh_veu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index cb54c69..911f562 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1164,9 +1164,9 @@ static int sh_veu_probe(struct platform_device *pdev)
 
 	veu->is_2h = resource_size(reg_res) == 0x22c;
 
-	veu->base = devm_request_and_ioremap(&pdev->dev, reg_res);
-	if (!veu->base)
-		return -ENOMEM;
+	veu->base = devm_ioremap_resource(&pdev->dev, reg_res);
+	if (IS_ERR(veu->base))
+		return PTR_ERR(veu->base);
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, sh_veu_isr, sh_veu_bh,
 					0, "veu", veu);
-- 
1.7.9.5


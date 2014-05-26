Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaEZPUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:20:55 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57323 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaEZPUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:20:53 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: benoit.taine@lip6.fr, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 15/18] Drivers: media: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:24 +0200
Message-Id: <1401117687-28911-16-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/media/platform/soc_camera/soc_camera.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index c8549bf..8646c11 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1346,13 +1346,11 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	ssdd = kzalloc(sizeof(*ssdd), GFP_KERNEL);
+	ssdd = kmemdup(&sdesc->subdev_desc, sizeof(*ssdd), GFP_KERNEL);
 	if (!ssdd) {
 		ret = -ENOMEM;
 		goto ealloc;
 	}
-
-	memcpy(ssdd, &sdesc->subdev_desc, sizeof(*ssdd));
 	/*
 	 * In synchronous case we request regulators ourselves in
 	 * soc_camera_pdrv_probe(), make sure the subdevice driver doesn't try


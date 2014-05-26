Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaEZPXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:23:08 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57255 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaEZPVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:21:03 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: benoit.taine@lip6.fr, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 17/18] drx-j: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:26 +0200
Message-Id: <1401117687-28911-18-git-send-email-benoit.taine@lip6.fr>
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
Not compile tested.

 drivers/media/dvb-frontends/drx39xyj/drxj.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 9482954..3795f65 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12272,22 +12272,20 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	if (demod == NULL)
 		goto error;
 
-	demod_addr = kmalloc(sizeof(struct i2c_device_addr), GFP_KERNEL);
+	demod_addr = kmemdup(&drxj_default_addr_g,
+			     sizeof(struct i2c_device_addr), GFP_KERNEL);
 	if (demod_addr == NULL)
 		goto error;
-	memcpy(demod_addr, &drxj_default_addr_g,
-	       sizeof(struct i2c_device_addr));
 
-	demod_comm_attr = kmalloc(sizeof(struct drx_common_attr), GFP_KERNEL);
+	demod_comm_attr = kmemdup(&drxj_default_comm_attr_g,
+				  sizeof(struct drx_common_attr), GFP_KERNEL);
 	if (demod_comm_attr == NULL)
 		goto error;
-	memcpy(demod_comm_attr, &drxj_default_comm_attr_g,
-	       sizeof(struct drx_common_attr));
 
-	demod_ext_attr = kmalloc(sizeof(struct drxj_data), GFP_KERNEL);
+	demod_ext_attr = kmemdup(&drxj_data_g, sizeof(struct drxj_data),
+				 GFP_KERNEL);
 	if (demod_ext_attr == NULL)
 		goto error;
-	memcpy(demod_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
 
 	/* setup the state */
 	state->i2c = i2c;


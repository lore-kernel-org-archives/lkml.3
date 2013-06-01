Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab3FAJqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:46:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:59424 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3FAJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:45:55 -0400
Message-ID: <1370079951.29224.19.camel@localhost.localdomain>
Subject: [PATCH] carma-fpga: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:45:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -954,10 +954,7 @@ static int data_debugfs_init(struct fpga
 {
 	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
 					      &data_debug_fops);
-	if (IS_ERR(priv->dbg_entry))
-		return PTR_ERR(priv->dbg_entry);
-
-	return 0;
+	return PTR_RET(priv->dbg_entry);
 }
 
 static void data_debugfs_exit(struct fpga_device *priv)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3FAJ66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:58:58 -0400
Received: from www17.your-server.de ([213.133.104.17]:60957 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3FAJ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:58:50 -0400
Message-ID: <1370080726.29224.35.camel@localhost.localdomain>
Subject: [PATCH] rbd: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:58:46 +0200
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

diff -u -p a/drivers/block/rbd.c b/drivers/block/rbd.c
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4466,7 +4466,7 @@ static int rbd_dev_image_id(struct rbd_d
 
 		image_id = ceph_extract_encoded_string(&p, p + ret,
 						NULL, GFP_NOIO);
-		ret = IS_ERR(image_id) ? PTR_ERR(image_id) : 0;
+		ret = PTR_RET(image_id);
 		if (!ret)
 			rbd_dev->image_format = 2;
 	} else {



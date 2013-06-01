Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3FAJLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:11:51 -0400
Received: from www17.your-server.de ([213.133.104.17]:55702 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab3FAJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:11:44 -0400
Message-ID: <1370077899.29224.0.camel@localhost.localdomain>
Subject: [PATCH] usb: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:11:39 +0200
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

diff -u -p a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -1928,11 +1928,10 @@ static int ene_load_bincode(struct us_da
 		usb_stor_dbg(us, "load firmware %s failed\n", fw_name);
 		goto nofw;
 	}
-	buf = kmalloc(sd_fw->size, GFP_KERNEL);
+	buf = kmemdup(sd_fw->data, sd_fw->size, GFP_KERNEL);
 	if (buf == NULL)
 		goto nofw;
 
-	memcpy(buf, sd_fw->data, sd_fw->size);
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = sd_fw->size;



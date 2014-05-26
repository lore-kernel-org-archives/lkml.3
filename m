Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaEZPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:25:56 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57395 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaEZPUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:20:45 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: benoit.taine@lip6.fr, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/18] USB: storage: ene_ub6250: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:10 +0200
Message-Id: <1401117687-28911-2-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/usb/storage/ene_ub6250.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 1bfc9a6..ef6efb5 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -1928,11 +1928,10 @@ static int ene_load_bincode(struct us_data *us, unsigned char flag)
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


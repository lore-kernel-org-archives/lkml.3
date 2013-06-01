Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3FAJlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:41:09 -0400
Received: from www17.your-server.de ([213.133.104.17]:58887 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab3FAJlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:41:03 -0400
Message-ID: <1370079657.29224.10.camel@localhost.localdomain>
Subject: [PATCH] memstick: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:40:57 +0200
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

diff -u -p a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1032,12 +1032,11 @@ static int mspro_block_read_attributes(s
 	}
 	msb->attr_group.name = "media_attributes";
 
-	buffer = kmalloc(attr_len, GFP_KERNEL);
+	buffer = kmemdup((char *)attr, attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
 	}
-	memcpy(buffer, (char *)attr, attr_len);
 
 	for (cnt = 0; cnt < attr_count; ++cnt) {
 		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);



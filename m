Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaEZPYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:24:07 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57355 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaEZPUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:20:48 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: benoit.taine@lip6.fr, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 16/18] HID: uhid: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:25 +0200
Message-Id: <1401117687-28911-17-git-send-email-benoit.taine@lip6.fr>
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

 drivers/hid/uhid.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 0d078c3..0cb92e3 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -441,12 +441,11 @@ static int uhid_dev_create2(struct uhid_device *uhid,
 	if (uhid->rd_size <= 0 || uhid->rd_size > HID_MAX_DESCRIPTOR_SIZE)
 		return -EINVAL;
 
-	uhid->rd_data = kmalloc(uhid->rd_size, GFP_KERNEL);
+	uhid->rd_data = kmemdup(ev->u.create2.rd_data, uhid->rd_size,
+				GFP_KERNEL);
 	if (!uhid->rd_data)
 		return -ENOMEM;
 
-	memcpy(uhid->rd_data, ev->u.create2.rd_data, uhid->rd_size);
-
 	hid = hid_allocate_device();
 	if (IS_ERR(hid)) {
 		ret = PTR_ERR(hid);


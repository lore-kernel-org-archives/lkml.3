Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3BFUNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:13:11 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:32905 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab3BFTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:29 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH 05/77] firewire: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:37 -0800
Message-Id: <1360179649-22465-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
---
 drivers/firewire/core-cdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index f8d2287..68c3138 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1779,7 +1779,6 @@ static int fw_device_op_release(struct inode *inode, struct file *file)
 	wait_event(client->tx_flush_wait, !has_outbound_transactions(client));
 
 	idr_for_each(&client->resource_idr, shutdown_resource, client);
-	idr_remove_all(&client->resource_idr);
 	idr_destroy(&client->resource_idr);
 
 	list_for_each_entry_safe(event, next_event, &client->event_list, link)
-- 
1.8.1


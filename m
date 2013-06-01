Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3FAJj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:39:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:58678 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab3FAJjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:39:22 -0400
Message-ID: <1370079554.29224.6.camel@localhost.localdomain>
Subject: [PATCH] remoteproc: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: ohad@wizery.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:39:14 +0200
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

diff -u -p a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -913,11 +913,10 @@ static void rproc_fw_config_virtio(const
 	 * will be stored in the cached_table. Before the device is started,
 	 * cached_table will be copied into devic memory.
 	 */
-	rproc->cached_table = kmalloc(tablesz, GFP_KERNEL);
+	rproc->cached_table = kmemdup(table, tablesz, GFP_KERNEL);
 	if (!rproc->cached_table)
 		goto out;
 
-	memcpy(rproc->cached_table, table, tablesz);
 	rproc->table_ptr = rproc->cached_table;
 
 	/* count the number of notify-ids */



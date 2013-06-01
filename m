Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3FAJqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:46:25 -0400
Received: from www17.your-server.de ([213.133.104.17]:59466 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3FAJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:46:09 -0400
Message-ID: <1370079964.29224.20.camel@localhost.localdomain>
Subject: [PATCH] DCA: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:46:04 +0200
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

diff -u -p a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -40,9 +40,7 @@ int dca_sysfs_add_req(struct dca_provide
 
 	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1), NULL,
 			   "requester%d", req_count++);
-	if (IS_ERR(cd))
-		return PTR_ERR(cd);
-	return 0;
+	return PTR_RET(cd);
 }
 
 void dca_sysfs_remove_req(struct dca_provider *dca, int slot)



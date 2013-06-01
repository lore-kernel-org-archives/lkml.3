Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3FAJwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:52:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:60119 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3FAJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:51:56 -0400
Message-ID: <1370080312.29224.22.camel@localhost.localdomain>
Subject: [PATCH] ethernet: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:51:52 +0200
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

diff -u -p a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -551,9 +551,7 @@ static struct net_device *apne_dev;
 static int __init apne_module_init(void)
 {
 	apne_dev = apne_probe(-1);
-	if (IS_ERR(apne_dev))
-		return PTR_ERR(apne_dev);
-	return 0;
+	return PTR_RET(apne_dev);
 }
 
 static void __exit apne_module_exit(void)



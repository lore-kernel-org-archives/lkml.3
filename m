Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaGJIbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:31:50 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58251 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaGJISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:18:24 -0400
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tom Gundersen <teg@jklm.no>, Ralf Baechle <ralf@linux-mips.org>,
        linux-hams@vger.kernel.org
Subject: [PATCH v7 11/33] net: af_netrom - set name assign type
Date: Thu, 10 Jul 2014 10:17:16 +0200
Message-Id: <1404980258-30853-12-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A given number of indistinguishable interfaces are allocated at init time, so
consider their names predictable.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-hams@vger.kernel.org
---
 net/netrom/af_netrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 71cf1bf..beb7cbe 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1418,7 +1418,7 @@ static int __init nr_proto_init(void)
 		struct net_device *dev;
 
 		sprintf(name, "nr%d", i);
-		dev = alloc_netdev(0, name, NET_NAME_UNKNOWN, nr_setup);
+		dev = alloc_netdev(0, name, NET_NAME_PREDICTABLE, nr_setup);
 		if (!dev) {
 			printk(KERN_ERR "NET/ROM: nr_proto_init - unable to allocate device structure\n");
 			goto fail;
-- 
1.9.3


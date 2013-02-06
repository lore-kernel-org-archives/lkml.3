Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3BFXad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:30:33 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37437 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab3BFXa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:30:27 -0500
From: Emil Goode <emilgoode@gmail.com>
To: akpm@linux-foundation.org, lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de,
        ordex@autistici.org, davem@davemloft.net
Cc: sasha.levin@oracle.com, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH v2] batman-adv: Remove unused variable
Date: Thu,  7 Feb 2013 00:32:37 +0100
Message-Id: <1360193557-27554-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below commit removed one node parameter from iterators.
ed242d01bbe22ea0877472db49b2752d866c921c
(hlist: drop the node parameter from iterators)

This patch removes a hlist_node struct that is no longer used.

Sparse gives a warning:

net/batman-adv/originator.c:411:21: warning:
	unused variable ‘node_tmp’ [-Wunused-variable]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
This patch applies to the linux-next tree.
v2: Added complete hash and message of dependant commit.

 net/batman-adv/originator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 43d0f89..96fb80b 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -408,7 +408,6 @@ int batadv_orig_seq_print_text(struct seq_file *seq, void *offset)
 	struct net_device *net_dev = (struct net_device *)seq->private;
 	struct batadv_priv *bat_priv = netdev_priv(net_dev);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	struct batadv_hard_iface *primary_if;
 	struct batadv_orig_node *orig_node;
-- 
1.7.10.4


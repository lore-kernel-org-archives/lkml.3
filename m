Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240AbbA2Ch2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbbA2ChR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 007/139] batman-adv: avoid NULL dereferences and fix if check
Date: Wed, 28 Jan 2015 14:19:10 -0800
Message-Id: <1422483682-15393-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@meshcoding.com>

[ Upstream commit 0d1644919578db525b9a7b6c8197ce02adbfce26 ]

Gateway having bandwidth_down equal to zero are not accepted
at all and so never added to the Gateway list.
For this reason checking the bandwidth_down member in
batadv_gw_out_of_range() is useless.

This is probably a copy/paste error and this check was supposed
to be "!gw_node" only. Moreover, the way the check is written
now may also lead to a NULL dereference.

Fix this by rewriting the if-condition properly.

Introduced by 414254e342a0d58144de40c3da777521ebaeeb07
("batman-adv: tvlv - gateway download/upload bandwidth container")

Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/batman-adv/gateway_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 68676cd..f62e30b 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -767,7 +767,7 @@ bool batadv_gw_out_of_range(struct batadv_priv *bat_priv,
 		goto out;
 
 	gw_node = batadv_gw_node_get(bat_priv, orig_dst_node);
-	if (!gw_node->bandwidth_down == 0)
+	if (!gw_node)
 		goto out;
 
 	ret = batadv_is_type_dhcprequest(skb, header_len);
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbbA0MSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbbA0MSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 063/126] batman-adv: avoid NULL dereferences and fix if check
Date: Tue, 27 Jan 2015 12:16:08 +0000
Message-Id: <1422361031-19364-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@meshcoding.com>

commit 0d1644919578db525b9a7b6c8197ce02adbfce26 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/batman-adv/gateway_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 90cff585b37d..e0bcf9e84273 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -810,7 +810,7 @@ bool batadv_gw_out_of_range(struct batadv_priv *bat_priv,
 		goto out;
 
 	gw_node = batadv_gw_node_get(bat_priv, orig_dst_node);
-	if (!gw_node->bandwidth_down == 0)
+	if (!gw_node)
 		goto out;
 
 	switch (atomic_read(&bat_priv->gw_mode)) {
-- 
2.1.4


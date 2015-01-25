Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbbAYT0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:26:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbbAYSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@meshcoding.com>,
        David Binderman <dcb314@hotmail.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 08/98] batman-adv: avoid NULL dereferences and fix if check
Date: Sun, 25 Jan 2015 10:06:26 -0800
Message-Id: <20150125180713.218644384@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -812,7 +812,7 @@ bool batadv_gw_out_of_range(struct batad
 		goto out;
 
 	gw_node = batadv_gw_node_get(bat_priv, orig_dst_node);
-	if (!gw_node->bandwidth_down == 0)
+	if (!gw_node)
 		goto out;
 
 	switch (atomic_read(&bat_priv->gw_mode)) {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbaE2Efv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbaE2Efp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.com>,
        Simon Wunderlich <simon@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH 3.14 120/140] batman-adv: fix neigh_ifinfo imbalance
Date: Wed, 28 May 2014 21:34:19 -0700
Message-Id: <20140529043105.043564643@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <simon@open-mesh.com>

[ Upstream commit c1e517fbbcdb13f50662af4edc11c3251fe44f86 ]

The neigh_ifinfo object must be freed if it has been used in
batadv_iv_ogm_process_per_outif().

This is a regression introduced by
89652331c00f43574515059ecbf262d26d885717
("batman-adv: split tq information in neigh_node struct")

Reported-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1545,6 +1545,8 @@ out_neigh:
 	if ((orig_neigh_node) && (!is_single_hop_neigh))
 		batadv_orig_node_free_ref(orig_neigh_node);
 out:
+	if (router_ifinfo)
+		batadv_neigh_ifinfo_free_ref(router_ifinfo);
 	if (router)
 		batadv_neigh_node_free_ref(router);
 	if (router_router)



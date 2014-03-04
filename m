Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaCDUDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbaCDUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russel Senior <russell@personaltelco.net>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 070/172] batman-adv: free skb on TVLV parsing success
Date: Tue,  4 Mar 2014 12:02:34 -0800
Message-Id: <20140304200301.981664134@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@open-mesh.com>

[ Upstream commit 05c3c8a636aa9ee35ce13f65afc5b665615cc786 ]

When the TVLV parsing routine succeed the skb is left
untouched thus leading to a memory leak.

Fix this by consuming the skb in case of success.

Introduced by ef26157747d42254453f6b3ac2bd8bd3c53339c3
("batman-adv: tvlv - basic infrastructure")

Reported-by: Russel Senior <russell@personaltelco.net>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
Tested-by: Russell Senior <russell@personaltelco.net>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1063,6 +1063,8 @@ int batadv_recv_unicast_tvlv(struct sk_b
 
 	if (ret != NET_RX_SUCCESS)
 		ret = batadv_route_unicast_packet(skb, recv_if);
+	else
+		consume_skb(skb);
 
 	return ret;
 }



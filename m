Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaIPQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:17:49 -0400
Received: from dub004-omc1s4.hotmail.com ([157.55.0.203]:56349 "EHLO
	DUB004-OMC1S4.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaIPQRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:17:46 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 12:17:46 EDT
X-TMN: [n2S1K6pChk/3heqY9a/iqdH3bAQJQuob]
X-Originating-Email: [mariopirker@hotmail.com]
Message-ID: <DUB123-W16816B212CDA9E8D7874ADA0C90@phx.gbl>
Reply-To: <mpirker@linux.com>
From: Mario Pirker <mariopirker@hotmail.com>
To: "mareklindner@neomailbox.ch" <mareklindner@neomailbox.ch>,
        "sw@simonwunderlich.de" <sw@simonwunderlich.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] 3.17.0-rc5 - Add sanity check for NULL in
 batadv_gw_out_of_range
Date: Tue, 16 Sep 2014 18:12:36 +0200
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Sep 2014 16:12:36.0960 (UTC) FILETIME=[07FBAE00:01CFD1C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b451e7317148e18bf6c5c8fd747d79ab34260354 Mon Sep 17 00:00:00 2001
From: Mario Pirker <mario.pirker@kellogg.ox.ac.uk>
Date: Tue, 16 Sep 2014 17:55:13 +0200
Subject: [PATCH] batman-adv: fix potential NULL pointer dereferencing

The call batadv_gw_node_get may return NULL. The return value has to
be sanity checked before the pointer is dereferenced.

Signed-off-by: Mario Pirker (mariopirker@hotmail.com)
---
 net/batman-adv/gateway_client.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 90cff58..7ee0913 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -810,6 +810,11 @@ bool batadv_gw_out_of_range(struct batadv_priv *bat_priv,
                goto out;
 
        gw_node = batadv_gw_node_get(bat_priv, orig_dst_node);
+
+       /* gw_node can be NULL. We need to check before dereferencing */
+       if (gw_node == NULL)
+               goto out;
+
        if (!gw_node->bandwidth_down == 0)
                goto out;
 
-- 
1.8.1.4 		 	   		  
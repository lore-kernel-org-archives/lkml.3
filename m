Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaLNUev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:34:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaLNUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 03/19] openvswitch: Fix flow mask validation.
Date: Sun, 14 Dec 2014 12:21:14 -0800
Message-Id: <20141214201823.641863978@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit f2a01517f2a1040a0b156f171a7cefd748f2fd03 ]

Following patch fixes typo in the flow validation. This prevented
installation of ARP and IPv6 flows.

Fixes: 19e7a3df72 ("openvswitch: Fix NDP flow mask validation")
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Reviewed-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -145,7 +145,7 @@ static bool match_validate(const struct
 	if (match->key->eth.type == htons(ETH_P_ARP)
 			|| match->key->eth.type == htons(ETH_P_RARP)) {
 		key_expected |= 1 << OVS_KEY_ATTR_ARP;
-		if (match->mask && (match->mask->key.tp.src == htons(0xff)))
+		if (match->mask && (match->mask->key.eth.type == htons(0xffff)))
 			mask_allowed |= 1 << OVS_KEY_ATTR_ARP;
 	}
 
@@ -220,7 +220,7 @@ static bool match_validate(const struct
 						htons(NDISC_NEIGHBOUR_SOLICITATION) ||
 				    match->key->tp.src == htons(NDISC_NEIGHBOUR_ADVERTISEMENT)) {
 					key_expected |= 1 << OVS_KEY_ATTR_ND;
-					if (match->mask && (match->mask->key.tp.src == htons(0xffff)))
+					if (match->mask && (match->mask->key.tp.src == htons(0xff)))
 						mask_allowed |= 1 << OVS_KEY_ATTR_ND;
 				}
 			}



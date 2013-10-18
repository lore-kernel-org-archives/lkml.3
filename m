Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JRMNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:13:46 -0400
Received: from mailrelay-out1.netcologne.de ([81.173.193.131]:19283 "EHLO
	mailrelay-out1.netcologne.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab3JRMNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:13:45 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2013 08:13:44 EDT
From: Guenther Kelleter <gkelleter@datus.com>
To: andrew.hendry@gmail.com, davem@davemloft.net
Cc: Guenther Kelleter <gkelleter@datus.com>, linux-x25@vger.kernel.org,
        linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] X.25: Fix address field length calculation
Date: Fri, 18 Oct 2013 14:03:14 +0200
Message-Id: <1382097794-14547-1-git-send-email-gkelleter@datus.com>
X-Mailer: git-send-email 1.8.3.4.71.g0878476
X-purgate-ID: 153929::1382097806-000005E4-D959FD46/0-0/0-0
X-purgate: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.

Signed-off-by: Guenther Kelleter <gkelleter@datus.com>
---
Wrong length calculation leads to rejection of CALL ACCEPT packets.

(patch resubmitted without corruption by stupid thunderbird. grrrr.)

 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 45a3ab5..2daf224 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
 	}
 
 	len = *skb->data;
-	needed = 1 + (len >> 4) + (len & 0x0f);
+	needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
 
 	if (!pskb_may_pull(skb, needed)) {
 		/* packet is too short to hold the addresses it claims
-- 
1.8.3.4.71.g0878476


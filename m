Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaFWReI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:34:08 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:36383 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157AbaFWReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:34:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHALBjqFNbskjJ/2dsb2JhbABZgw2rZwUBAQEBAQEFAZk1gQ8XdYQxLyOBGjeIRgHETReFY4kZHYQtBJpMk2ODRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: [PATCH V2] net/dsa/dsa.c: remove unnecessary null test before kfree
Date: Mon, 23 Jun 2014 19:32:47 +0200
Message-Id: <1403544767-12438-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: netdev@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: Use more appropriate subject (suggested by Joe Perches).

 net/dsa/dsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5db37ce..0a49632 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -351,8 +351,7 @@ static void dsa_of_free_platform_data(struct dsa_platform_data *pd)
 	for (i = 0; i < pd->nr_chips; i++) {
 		port_index = 0;
 		while (port_index < DSA_MAX_PORTS) {
-			if (pd->chip[i].port_names[port_index])
-				kfree(pd->chip[i].port_names[port_index]);
+			kfree(pd->chip[i].port_names[port_index]);
 			port_index++;
 		}
 		kfree(pd->chip[i].rtable);
-- 
1.8.4.5


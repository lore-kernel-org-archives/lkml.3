Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaLYLGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 06:06:00 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:35709 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbaLYLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 06:05:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUWALbum1RXQ7EK/2dsb2JhbABcgwaBKrQUBQEBAQEBAQUBd5cqBAKBChcBAQEBAX2EaSOBGjeIMAG4WI9OLIYAiQ5kHYQTBZcIkVAigUUBgik9MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 1/1 net-next] tipc: replace 0 by NULL for pointers
Date: Thu, 25 Dec 2014 12:05:50 +0100
Message-Id: <1419505550-17336-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
net/tipc/link.c:1924:40: warning: Using plain integer as NULL pointer

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 23bcc11..082c3b5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1921,7 +1921,7 @@ static struct tipc_node *tipc_link_find_owner(const char *link_name,
 {
 	struct tipc_link *l_ptr;
 	struct tipc_node *n_ptr;
-	struct tipc_node *found_node = 0;
+	struct tipc_node *found_node = NULL;
 	int i;
 
 	*bearer_id = 0;
-- 
1.9.1


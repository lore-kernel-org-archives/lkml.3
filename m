Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3C1Vcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:32:32 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62812 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3C1Vca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:32:30 -0400
From: Alexandru Copot <alex.mihai.c@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc: honkiko@gmail.com, tgraf@suug.ch, Alexandru Copot <alex.mihai.c@gmail.com>
Subject: [PATCH net-next] audit: pass int* to nlmsg_next
Date: Thu, 28 Mar 2013 23:31:29 +0200
Message-Id: <1364506289-9146-1-git-send-email-alex.mihai.c@gmail.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 941912133025926307c7a65b203fa38403b1063a replaced the macros
NLMSG_NEXT with calls to nlmsg_next which produces this warning:

kernel/audit.c: In function ‘audit_receive_skb’:
kernel/audit.c:928:3: warning: passing argument 2 of ‘nlmsg_next’ makes pointer from integer without a cast
In file included from include/net/rtnetlink.h:5:0,
                 from include/net/neighbour.h:28,
                 from include/net/dst.h:17,
                 from include/net/sock.h:68,
                 from kernel/audit.c:55:
include/net/netlink.h:359:1: note: expected ‘int *’ but argument is of type ‘int’

Fix this by sending the intended pointer.

Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4dbb047..488f85f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -925,7 +925,7 @@ static void audit_receive_skb(struct sk_buff *skb)
 		if (err || (nlh->nlmsg_flags & NLM_F_ACK))
 			netlink_ack(skb, nlh, err);
 
-		nlh = nlmsg_next(nlh, len);
+		nlh = nlmsg_next(nlh, &len);
 	}
 }
 
-- 
1.8.2


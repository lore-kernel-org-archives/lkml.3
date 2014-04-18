Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaDRJ0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46053 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbaDRJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 69/72] rds: prevent dereference of a NULL device in rds_iw_laddr_check
Date: Fri, 18 Apr 2014 11:22:42 +0200
Message-Id: <64005923ffdefe53e87138ec472c88877196d405.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit bf39b4247b8799935ea91d90db250ab608a58e50 ]

Binding might result in a NULL device which is later dereferenced
without checking.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/rds/iw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/iw.c b/net/rds/iw.c
index 7826d46baa70..589935661d66 100644
--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -239,7 +239,8 @@ static int rds_iw_laddr_check(__be32 addr)
 	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&sin);
 	/* due to this, we will claim to support IB devices unless we
 	   check node_type. */
-	if (ret || cm_id->device->node_type != RDMA_NODE_RNIC)
+	if (ret || !cm_id->device ||
+	    cm_id->device->node_type != RDMA_NODE_RNIC)
 		ret = -EADDRNOTAVAIL;
 
 	rdsdebug("addr %pI4 ret %d node type %d\n",
-- 
1.9.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaD1Bas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43091 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbaD1B3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sasha Levin" <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.141574225@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 15/94] rds: prevent dereference of a NULL device in 
 rds_iw_laddr_check
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit bf39b4247b8799935ea91d90db250ab608a58e50 ]

Binding might result in a NULL device which is later dereferenced
without checking.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/rds/iw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -239,7 +239,8 @@ static int rds_iw_laddr_check(__be32 add
 	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&sin);
 	/* due to this, we will claim to support IB devices unless we
 	   check node_type. */
-	if (ret || cm_id->device->node_type != RDMA_NODE_RNIC)
+	if (ret || !cm_id->device ||
+	    cm_id->device->node_type != RDMA_NODE_RNIC)
 		ret = -EADDRNOTAVAIL;
 
 	rdsdebug("addr %pI4 ret %d node type %d\n",


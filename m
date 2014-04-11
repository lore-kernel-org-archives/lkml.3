Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbaDKQJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429AbaDKQHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 34/41] rds: prevent dereference of a NULL device in rds_iw_laddr_check
Date: Fri, 11 Apr 2014 09:10:05 -0700
Message-Id: <20140411160935.299380110@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit bf39b4247b8799935ea91d90db250ab608a58e50 ]

Binding might result in a NULL device which is later dereferenced
without checking.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/iw.c |    3 ++-
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaJAVuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaJAVuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:50:00 -0400
From: "Herton R. Krzesinski" <herton@redhat.com>
To: Chien Yen <chien.yen@oracle.com>
Cc: rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        rmanes@redhat.com, dledford@redhat.com
Subject: [PATCH 1/3] net/rds: call rds_conn_drop instead of open code it at rds_connect_complete
Date: Wed,  1 Oct 2014 18:49:52 -0300
Message-Id: <1412200194-28902-2-git-send-email-herton@redhat.com>
In-Reply-To: <1412200194-28902-1-git-send-email-herton@redhat.com>
References: <1412200194-28902-1-git-send-email-herton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
---
 net/rds/threads.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/threads.c b/net/rds/threads.c
index 65eaefc..dc2402e 100644
--- a/net/rds/threads.c
+++ b/net/rds/threads.c
@@ -78,8 +78,7 @@ void rds_connect_complete(struct rds_connection *conn)
 				"current state is %d\n",
 				__func__,
 				atomic_read(&conn->c_state));
-		atomic_set(&conn->c_state, RDS_CONN_ERROR);
-		queue_work(rds_wq, &conn->c_down_w);
+		rds_conn_drop(conn);
 		return;
 	}
 
-- 
1.9.3


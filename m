Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaELBno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34737 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbaELBnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:42 -0400
Message-Id: <20140512003202.960147654@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 056/143] ifb: fix oops when loading the ifb failed
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit f2966cd5691058b8674a20766525bedeaea9cbcf ]

If __rtnl_link_register() return faild when loading the ifb, it will
take the wrong path and get oops, so fix it just like dummy.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ifb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index cfd5510..509c6f5 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -269,6 +269,8 @@ static int __init ifb_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&ifb_link_ops);
+	if (err < 0)
+		goto out;
 
 	for (i = 0; i < numifbs && !err; i++) {
 		err = ifb_init_one(i);
@@ -276,6 +278,8 @@ static int __init ifb_init_module(void)
 	}
 	if (err)
 		__rtnl_link_unregister(&ifb_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
-- 
1.7.12.2.21.g234cd45.dirty




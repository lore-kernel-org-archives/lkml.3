Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbaELCQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:16:40 -0400
Received: from 1wt.eu ([62.212.114.60]:34430 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaELBlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:55 -0400
Message-Id: <20140512003204.414582922@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 091/143] net: drop_monitor: fix the value of maxattr
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit d323e92cc3f4edd943610557c9ea1bb4bb5056e8 ]

maxattr in genl_family should be used to save the max attribute
type, but not the max command type. Drop monitor doesn't support
any attributes, so we should leave it as zero.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/drop_monitor.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 0a113f2..e65fa2f 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -63,7 +63,6 @@ static struct genl_family net_drop_monitor_family = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
-	.maxattr        = NET_DM_CMD_MAX,
 };
 
 static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);
-- 
1.7.12.2.21.g234cd45.dirty




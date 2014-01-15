Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaAOWLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:11:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaAOV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 148/166] net: drop_monitor: fix the value of maxattr
Date: Wed, 15 Jan 2014 13:52:42 -0800
Message-Id: <1389822780-4729-149-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit d323e92cc3f4edd943610557c9ea1bb4bb5056e8 ]

maxattr in genl_family should be used to save the max attribute
type, but not the max command type. Drop monitor doesn't support
any attributes, so we should leave it as zero.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/drop_monitor.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index d23b668..a974dfe 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -64,7 +64,6 @@ static struct genl_family net_drop_monitor_family = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
-	.maxattr        = NET_DM_CMD_MAX,
 };
 
 static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);
-- 
1.8.3.2


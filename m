Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaBLIN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:13:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50037 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbaBLINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Changli Gao" <xiaosuo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.993990959@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 04/79] net: drop_monitor: fix the value of maxattr
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit d323e92cc3f4edd943610557c9ea1bb4bb5056e8 ]

maxattr in genl_family should be used to save the max attribute
type, but not the max command type. Drop monitor doesn't support
any attributes, so we should leave it as zero.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/drop_monitor.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index b856f87..1d9a529 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -61,7 +61,6 @@ static struct genl_family net_drop_monitor_family = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
-	.maxattr        = NET_DM_CMD_MAX,
 };
 
 static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);


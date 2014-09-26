Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaIZGoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:44:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54765 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaIZGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:44:54 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-56-54250b62dd81
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/3] drivers: of: add return value to
 of_reserved_mem_device_init (fixup)
Date: Fri, 26 Sep 2014 08:44:25 +0200
Message-id: <1411713865-26192-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xK7pJ3KohBrO2G1jMWb+GzeLvpGPs
	Fgf+7GC0WNndzGaxc907RouzTW/YLbZ3zmC3+HLlIZPFpsfXWC0u75rDZrH2yF12iwXHW1gd
	eDx+/5rE6HG5r5fJo+vtFSaPO9f2sHmcmPGbxWPzknqP2/8eM3us+/OKyaNvyypGj8+b5AK4
	orhsUlJzMstSi/TtErgytq1YwlpwmK3icet1xgbGzaxdjJwcEgImEgffb2WHsMUkLtxbz9bF
	yMUhJLCUUeLQ+43MEE4fk8TC86+ZQarYBAwlut52sYHYIgJuEv/WHQLrYBaYzCxxbeEeJpCE
	sECcxJQznWANLAKqEqtefmEBsXkFPCQ+vuxghFgnJ/H/5Qqwek6gePuPZrAaIQF3iQtLfrJO
	YORdwMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkdL/sYFx8zOoQowAHoxIP7411KiFC
	rIllxZW5hxglOJiVRHg3cqiGCPGmJFZWpRblxxeV5qQWH2Jk4uCUamAU3vwz7dCpN3JXlP6s
	eS93dkthZ8vEtw4Rqo03OrhmWs/y2/rfSu9sWaOUnIzpHv/itob756eGes3931m14+yzc/vl
	pplLSOYc7nHWD215vODAJeerbN+ebWT9wTpz3bqJnp99VSI3bVt/LPLfx4trPW9xOp4IUzy7
	xOD1xAyhWVPYXjcc+Ln6lxJLcUaioRZzUXEiAIhyIeE7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing return value to error paths.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 7e7de03..e975156 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -250,13 +250,13 @@ int of_reserved_mem_device_init(struct device *dev)
 
 	np = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!np)
-		return;
+		return -ENODEV;
 
 	rmem = __find_rmem(np);
 	of_node_put(np);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
-		return;
+		return -ENIVAL;
 
 	rmem->ops->device_init(rmem, dev);
 	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
-- 
1.9.2


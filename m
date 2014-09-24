Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaIXTv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:51:29 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38925 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIXTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:51:28 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] genalloc: fix device node resource counter
Date: Wed, 24 Sep 2014 22:51:00 +0300
Message-ID: <1411588260-29825-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change balances a usage counter of np_pool device_node, which is
incremented on preceding of_parse_phandle() call.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/genalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index c7a91cf..cce4dd6 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -637,6 +637,7 @@ struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	if (!np_pool)
 		return NULL;
 	pdev = of_find_device_by_node(np_pool);
+	of_node_put(np_pool);
 	if (!pdev)
 		return NULL;
 	return dev_get_gen_pool(&pdev->dev);
-- 
1.7.10.4


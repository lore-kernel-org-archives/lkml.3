Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3HFQfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:35:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10703 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3HFQfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:35:02 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7efe6d000007b11-f5-520125b451ab
Content-transfer-encoding: 8BIT
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, t.figa@samsung.com, s.nawrocki@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] Regmap: Add missing header
Date: Tue, 06 Aug 2013 18:34:40 +0200
Message-id: <1375806880-13068-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t9jAd0tqoxBBm871CymPnzCZnG26Q27
	xeVdc9gsTq85xWxx+E07q8X6Ga9ZHNg8Nq3qZPM4+G4Pk0ffllWMHp83yQWwRHHZpKTmZJal
	FunbJXBlzNk9m6ngAXvFjNM32BsYL7B1MXJySAiYSCxs/g5li0lcuLcezBYSWMQocb29FMTm
	FRCU+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnzFjF3MXIBlbczSVxe8BKsl03AXGLis00sILYI
	0MzbczrBipgF1jFKTPreDZYQFtCWWPL+EJjNIqAq8fzfFyaIZX4S02/MZQRZJiGgIDFnks0E
	Rr5ZSM6YhXDGLCRnLGBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHJzPpHcwrmqwOMQo
	wMGoxMNbIcYYJMSaWFZcmXuIUYKDWUmE10cCKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1
	oJBAemJJanZqakFqEUyWiYNTqoHRxGui4iH5HYlptzWje2tOJS7eLWwiwNu/+NajnasYLypf
	TzvwsP3zZzHJuWvtm+JkgpW+fTVhcno512arvUrADLW33Z5/fr7pFfrrEh7ia5AUHXLB8oBy
	6JUSNfPTUZU5G8urGoLiTZwsN3LL3zWp/j0zSsLkq+XsU8ctS+fVuV5baM7PvVuJpTgj0VCL
	uag4EQBL2O/+SgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap.h requires linux/err.h if CONFIG_REGMAP is not defined. Without it I get
error.
CC      drivers/media/platform/exynos4-is/fimc-reg.o
In file included from drivers/media/platform/exynos4-is/fimc-reg.c:14:0:
include/linux/regmap.h: In function ‘regmap_write’:
include/linux/regmap.h:525:10: error: ‘EINVAL’ undeclared (first use in this function)
include/linux/regmap.h:525:10: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 include/linux/regmap.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a3c68aa..bafda87 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -15,6 +15,7 @@
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/err.h>
 
 struct module;
 struct device;
-- 
1.7.9.5


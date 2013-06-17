Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3FQIk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:40:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39542 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab3FQIkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:40:25 -0400
From: Ambresh K <ambresh@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Rajendra <rnayak@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V2 2/3] clk: skip re-parenting orphan clk
Date: Mon, 17 Jun 2013 14:09:43 +0530
Message-ID: <1371458384-23936-3-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371458384-23936-1-git-send-email-ambresh@ti.com>
References: <1371458384-23936-1-git-send-email-ambresh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

If clk is same as orphan clk then skip the iteration, there
by avoiding unnecessary look-up.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 drivers/clk/clk.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2842450..57bb94a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1633,6 +1633,10 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * this clock
 	 */
 	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
+		/* Skip if clk is same as orphan clk */
+		if (!strcmp(clk->name, orphan->name))
+			continue;
+
 		if (orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
 			if (i < 0) {
-- 
1.7.4.1


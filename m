Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3EBG03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:26:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53925 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab3EBG0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:26:08 -0400
From: Ambresh K <ambresh@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Rajendra <rnayak@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [Patch 2/3] clk: skip re-parenting orphan clk
Date: Thu, 2 May 2013 11:55:28 +0530
Message-ID: <1367475929-32166-3-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1367475929-32166-1-git-send-email-ambresh@ti.com>
References: <1367475929-32166-1-git-send-email-ambresh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

If clk is same as orphan clk than skip the iteration, there
by avoiding unnecessary look-up.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 drivers/clk/clk.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c187321..f4d2c73 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1635,6 +1635,10 @@ int __clk_init(struct device *dev, struct clk *clk)
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


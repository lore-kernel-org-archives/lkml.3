Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaBJU1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:27:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49982 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaBJU13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:27:29 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 1/2] clk: keystone: gate: fix clk_init_data initialization
Date: Mon, 10 Feb 2014 15:26:50 -0500
Message-ID: <1392064011-11986-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
References: <1392064011-11986-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

The clk_init_data struct is allocated in the stack. All members of
this struct should be initialized before using otherwise it will
lead to unpredictable situation as it can contain garbage.

Ultimately the clk->flag field contains garbage. In my case it leads
that flag CLK_IGNORE_UNUSED is set for most of clocks. As result a
bunch of unused clocks cannot be disabled.

So initialize flags in this structure too.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/clk/keystone/gate.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
index 17a5983..86f1e36 100644
--- a/drivers/clk/keystone/gate.c
+++ b/drivers/clk/keystone/gate.c
@@ -179,6 +179,7 @@ static struct clk *clk_register_psc(struct device *dev,
 
 	init.name = name;
 	init.ops = &clk_psc_ops;
+	init.flags = 0;
 	init.parent_names = (parent_name ? &parent_name : NULL);
 	init.num_parents = (parent_name ? 1 : 0);
 
-- 
1.7.9.5


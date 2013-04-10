Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937064Ab3DJJr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:47:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61430 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935049Ab3DJJr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:47:27 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] of: export of_get_next_parent
Date: Wed, 10 Apr 2013 17:47:07 +0800
Message-Id: <1365587227-26137-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is called by at least three drivers now:

	pinctrl
	mfd/vexpress
	v4l2-core

The 3rd one can be built as module, so export the function to
avoid build failure.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/of/base.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index c6443de..a2a0ddc 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -382,6 +382,7 @@ struct device_node *of_get_next_parent(struct device_node *node)
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return parent;
 }
+EXPORT_SYMBOL(of_get_next_parent);
 
 /**
  *	of_get_next_child - Iterate a node childs
-- 
1.7.9.5


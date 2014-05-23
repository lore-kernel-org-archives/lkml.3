Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbaEWTnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:43:45 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:56559 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaEWTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:43:43 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: devicetree@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] of: handle NULL node in of_get_next_available_child
Date: Fri, 23 May 2014 12:43:11 -0700
Message-Id: <1400874192-29400-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an early check for the node argument in
of_get_next_available_child() to avoid dereferencing a NULL node pointer
a few lines after.

CC: Daniel Mack <zonque@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index e67b308819c9..9a71bfac78ae 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -746,6 +746,9 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 	struct device_node *next;
 	unsigned long flags;
 
+	if (!node)
+		return NULL;
+
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling) {
-- 
1.9.1


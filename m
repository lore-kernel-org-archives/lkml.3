Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3KHPES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:04:18 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:36079 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307Ab3KHPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:04:15 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v4 2/5] OF: Clear detach flag on attach
Date: Fri,  8 Nov 2013 17:03:57 +0200
Message-Id: <1383923040-24803-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1383923040-24803-1-git-send-email-panto@antoniou-consulting.com>
References: <1383923040-24803-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attaching a node always clear the detach flag. Without this change
the sequence detach, attach fails.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7d4c70f..ca10916 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1641,6 +1641,7 @@ int of_attach_node(struct device_node *np)
 	np->allnext = of_allnodes;
 	np->parent->child = np;
 	of_allnodes = np;
+	of_node_clear_flag(np, OF_DETACHED);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	of_add_proc_dt_entry(np);
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3BGTJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:09:23 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55120 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3BGTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:09:21 -0500
From: Rob Herring <robherring2@gmail.com>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 1/4] clocksource: pass DT node pointer to init functions
Date: Thu,  7 Feb 2013 13:09:01 -0600
Message-Id: <1360264144-20714-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In cases where we have multiple nodes of the same type, we may need the
node pointer to know which node was matched. Passing the node pointer
also keeps the init function from having to match the node a 2nd time.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/clksrc-of.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index bdabdaa..3ef11fb 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -26,10 +26,10 @@ void __init clocksource_of_init(void)
 {
 	struct device_node *np;
 	const struct of_device_id *match;
-	void (*init_func)(void);
+	void (*init_func)(struct device_node *);
 
 	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
 		init_func = match->data;
-		init_func();
+		init_func(np);
 	}
 }
-- 
1.7.10.4


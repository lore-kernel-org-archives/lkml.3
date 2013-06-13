Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3FMXTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:19:53 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40042 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FMXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:19:51 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH] irqdomain: Remove temporary MIPS workaround code
Date: Fri, 14 Jun 2013 00:19:43 +0100
Message-Id: <1371165583-21907-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPS interrupt controllers are all registering their own irq_domains
now. Drop the MIPS specific code because it is no longer needed.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---

Ralf, this should be okay to pull out now. I'll be submitting it for
v3.11 unless someone yells. Even if so, all the irqdomain infrastructure
is in place to make it trivial to add an irqdomain where missing.

g.

 kernel/irq/irqdomain.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 13f2654..e0c3366 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -475,18 +475,6 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 
 	domain = controller ? irq_find_host(controller) : irq_default_domain;
 	if (!domain) {
-#ifdef CONFIG_MIPS
-		/*
-		 * Workaround to avoid breaking interrupt controller drivers
-		 * that don't yet register an irq_domain.  This is temporary
-		 * code. ~~~gcl, Feb 24, 2012
-		 *
-		 * Scheduled for removal in Linux v3.6.  That should be enough
-		 * time.
-		 */
-		if (intsize > 0)
-			return intspec[0];
-#endif
 		pr_warn("no irq domain found for %s !\n",
 			of_node_full_name(controller));
 		return 0;
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaIPUwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:52:24 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48977 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaIPUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:20 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 18/22] PNP: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:32 +0200
Message-Id: <1410900696-6481-19-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/pnp/interface.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index e6c403b..4b6808f 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -346,41 +346,41 @@ static ssize_t resources_store(struct device *dmdev,
 	}
 
 	buf = skip_spaces(buf);
-	if (!strnicmp(buf, "disable", 7)) {
+	if (!strncasecmp(buf, "disable", 7)) {
 		retval = pnp_disable_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "activate", 8)) {
+	if (!strncasecmp(buf, "activate", 8)) {
 		retval = pnp_activate_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "fill", 4)) {
+	if (!strncasecmp(buf, "fill", 4)) {
 		if (dev->active)
 			goto done;
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "auto", 4)) {
+	if (!strncasecmp(buf, "auto", 4)) {
 		if (dev->active)
 			goto done;
 		pnp_init_resources(dev);
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "clear", 5)) {
+	if (!strncasecmp(buf, "clear", 5)) {
 		if (dev->active)
 			goto done;
 		pnp_init_resources(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "get", 3)) {
+	if (!strncasecmp(buf, "get", 3)) {
 		mutex_lock(&pnp_res_mutex);
 		if (pnp_can_read(dev))
 			dev->protocol->get(dev);
 		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
-	if (!strnicmp(buf, "set", 3)) {
+	if (!strncasecmp(buf, "set", 3)) {
 		resource_size_t start;
 		resource_size_t end;
 		unsigned long flags;
@@ -392,31 +392,31 @@ static ssize_t resources_store(struct device *dmdev,
 		mutex_lock(&pnp_res_mutex);
 		while (1) {
 			buf = skip_spaces(buf);
-			if (!strnicmp(buf, "io", 2)) {
+			if (!strncasecmp(buf, "io", 2)) {
 				buf = pnp_get_resource_value(buf + 2,
 							     IORESOURCE_IO,
 							     &start, &end,
 							     &flags);
 				pnp_add_io_resource(dev, start, end, flags);
-			} else if (!strnicmp(buf, "mem", 3)) {
+			} else if (!strncasecmp(buf, "mem", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_MEM,
 							     &start, &end,
 							     &flags);
 				pnp_add_mem_resource(dev, start, end, flags);
-			} else if (!strnicmp(buf, "irq", 3)) {
+			} else if (!strncasecmp(buf, "irq", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_IRQ,
 							     &start, NULL,
 							     &flags);
 				pnp_add_irq_resource(dev, start, flags);
-			} else if (!strnicmp(buf, "dma", 3)) {
+			} else if (!strncasecmp(buf, "dma", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_DMA,
 							     &start, NULL,
 							     &flags);
 				pnp_add_dma_resource(dev, start, flags);
-			} else if (!strnicmp(buf, "bus", 3)) {
+			} else if (!strncasecmp(buf, "bus", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_BUS,
 							     &start, &end,
-- 
2.0.4


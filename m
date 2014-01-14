Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaANAUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:20:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:65480 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaANAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:20:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/3] arm: include module.h in drivers/bus/omap_l3_smx.c
Date: Mon, 13 Jan 2014 19:19:42 -0500
Message-ID: <1389658783-9876-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389658783-9876-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389658783-9876-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config OMAP_INTERCONNECT that this driver depends on (in
drivers/bus/Kconfig) is tristate.  So it can be a module.

Also there are module related setup calls within this driver.
Explicitly add module.h to includes so it won't be a build failure
when future cleanups are integrated and the implicit presence
of certain module prototypes disappears.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/bus/omap_l3_smx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc216491b8a..8a614332dcb9 100644
--- a/drivers/bus/omap_l3_smx.c
+++ b/drivers/bus/omap_l3_smx.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-- 
1.8.5.2


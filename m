Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3EaU4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:56:47 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60933 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3EaU4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:56:38 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mfd: twl-core: convert to module_init()
Date: Fri, 31 May 2013 13:56:34 -0700
Message-Id: <1370033794-5357-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for twl-core to be subsys_inicall anymore.  Anything
using twl that early needs a rethink, or deferred probe changes.

Boot tested and RTC wake tested (via TWL RTC) on OMAP platforms:
3530/Beagle, 3730/Beagle-xM, 3530/Overo, 3730/Overo-STORM, 4430/Panda,
4460/Panda-ES.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 89ab4d9..7749b9e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1309,7 +1309,7 @@ static int __init twl_init(void)
 {
 	return i2c_add_driver(&twl_driver);
 }
-subsys_initcall(twl_init);
+module_init(twl_init);
 
 static void __exit twl_exit(void)
 {
-- 
1.8.2


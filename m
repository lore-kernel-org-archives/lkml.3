Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbbAZQX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:23:56 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34751 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbbAZQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:23:20 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] coresight-etm: remove check for unknown Kconfig macro
Date: Mon, 26 Jan 2015 09:22:24 -0700
Message-Id: <1422289345-2084-9-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
References: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

The CoreSight ETM/PTM driver contains a check for a
CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE macro. But there's no related
Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE. Remove that check
and the single line of code it hides.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/coresight-etm3x.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
index 73c36696f1b6..c965f5724abd 100644
--- a/drivers/coresight/coresight-etm3x.c
+++ b/drivers/coresight/coresight-etm3x.c
@@ -34,14 +34,8 @@
 
 #include "coresight-etm.h"
 
-#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
-static int boot_enable = 1;
-#else
 static int boot_enable;
-#endif
-module_param_named(
-	boot_enable, boot_enable, int, S_IRUGO
-);
+module_param_named(boot_enable, boot_enable, int, S_IRUGO);
 
 /* The number of ETM/PTM currently registered */
 static int etm_count;
-- 
1.9.1


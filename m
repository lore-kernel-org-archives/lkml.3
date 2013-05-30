Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab3E3RBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:01:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:32585 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab3E3RBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="345807927"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/2] regmap: give users _choice_ to allow write access to debugfs
Date: Thu, 30 May 2013 21:54:01 +0530
Message-Id: <1369931042-9755-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is very handy is debug kernels and should _never_ be turned On in production
mode

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/base/regmap/Kconfig          |    9 +++++++++
 drivers/base/regmap/regmap-debugfs.c |    3 +--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index f0d3054..928d6e3 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -20,3 +20,12 @@ config REGMAP_MMIO
 
 config REGMAP_IRQ
 	bool
+
+
+config REGMAP_ALLOW_WRITE_DEBUGFS
+	bool "Regmap write access to usermode"
+	default n
+	help
+	   WARNING: This allows usermode to write to hardware registers. Writing
+	   to stuff like PMICs is _never_ advised due to obvious side effects, use
+	   at very extreme caution. Is helpful for debugging
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 23b701f..7989052 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -248,8 +248,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 				   count, ppos);
 }
 
-#undef REGMAP_ALLOW_WRITE_DEBUGFS
-#ifdef REGMAP_ALLOW_WRITE_DEBUGFS
+#ifdef CONFIG_REGMAP_ALLOW_WRITE_DEBUGFS
 /*
  * This can be dangerous especially when we have clients such as
  * PMICs, therefore don't provide any real compile time configuration option
-- 
1.7.0.4


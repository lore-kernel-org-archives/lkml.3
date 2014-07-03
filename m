Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbaGCOjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:39:21 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40779 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaGCOjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:39:18 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC v2 1/5] clk: Add temporary mapping to the existing API
Date: Thu,  3 Jul 2014 16:38:39 +0200
Message-Id: <1404398323-18934-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To preserve git-bisectability, add aliases from the future provider API to the
existing public API.

Also includes clk-provider.h and clk-dev.h in a few places so the right
functions are defined.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/berlin/bg2.c     |  1 +
 drivers/clk/berlin/bg2q.c    |  1 +
 drivers/clk/clkdev.c         |  1 +
 include/linux/clk-provider.h | 18 ++++++++++++++++++
 include/linux/clk/zynq.h     |  1 +
 5 files changed, 22 insertions(+)

diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
index 515fb13..4c81e09 100644
--- a/drivers/clk/berlin/bg2.c
+++ b/drivers/clk/berlin/bg2.c
@@ -19,6 +19,7 @@
 
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index 21784e4..748da9b 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -19,6 +19,7 @@
 
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index f890b90..000c1ae 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/of.h>
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 0c287db..f359f3e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -16,6 +16,24 @@
 
 #ifdef CONFIG_COMMON_CLK
 
+/* Temporarily map the to-be-added API to the old API, just so stuff compiles */
+#define clk_core			clk
+
+#define clk_core_to_clk
+
+#define clk_provider_get		clk_get
+#define clk_provider_get_sys		clk_get_sys
+#define devm_clk_provider_get		devm_clk_get
+#define of_clk_provider_get		of_clk_get
+#define of_clk_provider_get_by_name	of_clk_get_by_name
+
+#define clk_provider_set_rate		clk_set_rate
+#define clk_provider_get_rate		clk_get_rate
+#define clk_provider_set_parent		clk_set_parent
+#define clk_provider_get_parent		clk_get_parent
+#define clk_provider_prepare		clk_prepare
+#define clk_provider_unprepare		clk_unprepare
+
 /*
  * flags used across common struct clk.  these flags should only affect the
  * top-level framework.  custom flags for dealing with hardware specifics
diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
index 7a5633b..a990a59 100644
--- a/include/linux/clk/zynq.h
+++ b/include/linux/clk/zynq.h
@@ -21,6 +21,7 @@
 #define __LINUX_CLK_ZYNQ_H_
 
 #include <linux/spinlock.h>
+#include <linux/clk-provider.h>
 
 void zynq_clock_init(void);
 
-- 
1.9.3


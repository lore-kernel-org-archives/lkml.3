Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbbAVXk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:40:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33932 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAVXkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:40:23 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH] clk: ti: Drop use of clk-private.h
Date: Thu, 22 Jan 2015 15:40:20 -0800
Message-Id: <1421970020-11125-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These modules don't need to include clk-private.h. Replace the
include with clk.h because these modules are clock consumers and
also include clk-provider.h in clk/ti.h because struct
clk_hw_omap has a struct clk_hw embedded in it.

Cc: Tero Kristo <t-kristo@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/ti/clk-44xx.c | 2 +-
 drivers/clk/ti/clk-54xx.c | 2 +-
 drivers/clk/ti/clk-7xx.c  | 2 +-
 include/linux/clk/ti.h    | 1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
index 02517a8206bd..4f4c87751db5 100644
--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -12,7 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/clk-private.h>
+#include <linux/clk.h>
 #include <linux/clkdev.h>
 #include <linux/clk/ti.h>
 
diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index 5e183993e3ec..14160b223548 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -12,7 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/clk-private.h>
+#include <linux/clk.h>
 #include <linux/clkdev.h>
 #include <linux/io.h>
 #include <linux/clk/ti.h>
diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index 62ac8f6e480c..ee32f4deebf4 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -12,7 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/clk-private.h>
+#include <linux/clk.h>
 #include <linux/clkdev.h>
 #include <linux/clk/ti.h>
 
diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
index cfb9e554de6f..34042b56b0d0 100644
--- a/include/linux/clk/ti.h
+++ b/include/linux/clk/ti.h
@@ -15,6 +15,7 @@
 #ifndef __LINUX_CLK_TI_H__
 #define __LINUX_CLK_TI_H__
 
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


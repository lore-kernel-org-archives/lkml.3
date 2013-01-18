Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3ARVJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:09:34 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39583 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3ARVJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:09:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Prashant Gaikwad <pgaikwad@nvidia.com>, <swarren@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
References: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com>
Message-ID: <20130118210928.3982.75303@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 1/2] clk: Add composite clock type
Date: Fri, 18 Jan 2013 13:09:28 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Prashant Gaikwad (2013-01-03 21:51:45)
> Not all clocks are required to be decomposed into basic clock
> types but at the same time want to use the functionality
> provided by these basic clock types instead of duplicating.
> 
> For example, Tegra SoC has ~100 clocks which can be decomposed
> into Mux -> Div -> Gate clock types making the clock count to
> ~300. Also, parent change operation can not be performed on gate
> clock which forces to use mux clock in driver if want to change
> the parent.
> 
> Instead aggregate the basic clock types functionality into one
> clock and just use this clock for all operations. This clock
> type re-uses the functionality of basic clock types and not
> limited to basic clock types but any hardware-specific
> implementation.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Hi Prashant,

I'm OK with the general concept of the composite clock, but a V2 patch
addressing all of the comments needs to be submitted first.  You might
base your patch on top of the following cleanup:


>From 135a829744067cb825b48f7422e22861e57d5ecd Mon Sep 17 00:00:00 2001
From: Mike Turquette <mturquette@linaro.org>
Date: Fri, 18 Jan 2013 13:00:05 -0800
Subject: [PATCH] clk: beautify Makefile

The list of common clock types was getting a bit unmanageable.  This
patch puts only one file on each line and reorders the object files
alphabetically.  Also a newline is added to separate the sections.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Makefile |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index ee90e87..e73b1d6 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,8 +1,13 @@
 # common clock types
 obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
-obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
-				   clk-mux.o clk-divider.o clk-fixed-factor.o
+obj-$(CONFIG_COMMON_CLK)	+= clk.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-divider.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-factor.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
+
 # SoCs specific
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
-- 
1.7.10.4


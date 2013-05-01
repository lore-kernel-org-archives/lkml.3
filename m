Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab3EAA71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:59:27 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51903 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075Ab3EAA64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:58:56 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@nvidia.com>, Daniel Mack <zonque@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Marek Belisko <marek.belisko@streamunlimited.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] clk: add of_clk_provider stubs to enable clk-si5351 on non OF
Date: Wed,  1 May 2013 02:58:27 +0200
Message-Id: <1367369910-20402-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling drivers that provide clocks on DT on platforms that don't have
CONFIG_OF set fails due to compilation errors. This patch set first adds
some stubs for of_clk_provider functions if CONFIG_OF is not set. Second
it allows those platforms to build and use clk-si5351 i2c clock driver
by removing the dependency on CONFIG_OF.

The above approach has been suggested by Arnd Bergmann and replaces the
corresponding Kconfig patch for clk-si5351 posted earlier. It has been
compile tested with allmodconfig on x86_64 for post v3.9.

Sebastian Hesselbarth (2):
  clk: add non CONFIG_OF routines for clk-provider
  clk: si5351: Allow to build without CONFIG_OF

 drivers/clk/Kconfig          |    1 -
 include/linux/clk-provider.h |   47 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 9 deletions(-)
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Marek Belisko <marek.belisko@streamunlimited.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4


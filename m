Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKISmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 13:42:32 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:31097 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaKISma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 13:42:30 -0500
X-Mailbox-Line: From 33e64705e81810201349a09ac22d5e1f66e035e0 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1415557680.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 9 Nov 2014 19:28:00 +0100
Subject: [PATCH 0/2] of: Fix some 'const' problems
To: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cast is often needed to call some OF functions, removing
the 'const' attribute.
This patchset makes 'const' the device node pointers of the functions
of_clk_get() and of_node_put() and also removes some useless casts
in the sound/soc tree.

Jean-Francois Moine (2):
  of: Make const the device node pointers in of_clk_get and of_node_put
  ASoC: Remove useless casts

 drivers/clk/clkdev.c                  | 2 +-
 drivers/of/dynamic.c                  | 2 +-
 include/linux/clk.h                   | 4 ++--
 include/linux/of.h                    | 4 ++--
 sound/soc/generic/simple-card.c       | 7 ++-----
 sound/soc/samsung/odroidx2_max98090.c | 4 ++--
 sound/soc/ux500/mop500.c              | 6 ++----
 7 files changed, 12 insertions(+), 17 deletions(-)

-- 
2.1.3


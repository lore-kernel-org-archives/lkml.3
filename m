Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3HVFxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:53:24 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63513 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3HVFxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:53:22 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 0/5] clk: dt: bindings for mux, divider & gate clocks
Date: Wed, 21 Aug 2013 22:53:08 -0700
Message-Id: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces binding definitions for common register-mapped
clock multiplexer, divider and gate IP blocks along with the
corresponding setup functions for matching DT data.  The bindings are
similar to the struct definitions but please don't hold that against the
binding: the struct definitions closely model the hardware register
layout.

The delta from v3 is very small and only consists of cosmetic changes
and one functional change for better error handling.

Changes since v3:
* added Tested-by & Reviewed-by from Heiko
* replaced underscores with dashes in DT property names
* bail from of clock setup function early if of_iomap fails
* removed unecessary explict cast

Mike Turquette (5):
  clk: divider: replace bitfield width with mask
  clk: of: helper for determining number of parent clocks
  clk: dt: binding for basic multiplexer clock
  clk: dt: binding for basic divider clock
  clk: dt: binding for basic gate clock

 .../devicetree/bindings/clock/divider-clock.txt    |  90 +++++++++++++++
 .../devicetree/bindings/clock/gate-clock.txt       |  36 ++++++
 .../devicetree/bindings/clock/mux-clock.txt        |  79 +++++++++++++
 arch/arm/mach-imx/clk-busy.c                       |   2 +-
 drivers/clk/clk-divider.c                          | 128 ++++++++++++++++++---
 drivers/clk/clk-gate.c                             |  47 ++++++++
 drivers/clk/clk-mux.c                              |  68 ++++++++++-
 drivers/clk/clk.c                                  |   6 +
 drivers/clk/mxs/clk-div.c                          |   2 +-
 include/linux/clk-private.h                        |   2 +-
 include/linux/clk-provider.h                       |  12 +-
 11 files changed, 449 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/divider-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/gate-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt

-- 
1.8.1.2


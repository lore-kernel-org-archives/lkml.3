Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3FQC7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 22:59:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3FQC7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:59:32 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 0/5] clk: dt: bindings for mux, divider & gate clocks
Date: Sun, 16 Jun 2013 19:58:20 -0700
Message-Id: <1371437905-15567-1-git-send-email-mturquette@linaro.org>
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

This version incorporates review comments from the last RFC and includes
the basic gate clock as well. This version is not considered RFC and
hopefully can be agreed upon for 3.11, review comments notwithstanding.

Also this second version of the series converts the divider
implementation to use a bitmask internally. The registration APIs are
not changed so existing users are not affected. This gives us a cleaner
binding and a more flexible representation for more exotic hardware
designs.

I'm currently looking at the best way to match and setup these basic
clocks without requiring every platform to write a small clock driver
that matches the basic types. That is missing from this series but can
be merged later as a separate change.

Testing was done on OMAP4460 Panda ES using the experimental out-of-tree
OMAP CCF conversion patches posted recently.

Heiko, enough changed here such that I did not keep your Acked-by's and
Tested-by's. But I am happy to take them again :-)

Mike Turquette (5):
  clk: divider: replace bitfield width with mask
  clk: of: helper for determining number of parent clocks
  clk: dt: binding for basic multiplexer clock
  clk: dt: binding for basic divider clock
  clk: dt: binding for basic gate clock

 .../devicetree/bindings/clock/divider-clock.txt    |  87 +++++++++++++++
 .../devicetree/bindings/clock/gate-clock.txt       |  34 ++++++
 .../devicetree/bindings/clock/mux-clock.txt        |  77 +++++++++++++
 arch/arm/mach-imx/clk-busy.c                       |   2 +-
 drivers/clk/clk-divider.c                          | 121 ++++++++++++++++++---
 drivers/clk/clk-gate.c                             |  40 +++++++
 drivers/clk/clk-mux.c                              |  62 ++++++++++-
 drivers/clk/clk.c                                  |   6 +
 drivers/clk/mxs/clk-div.c                          |   2 +-
 include/linux/clk-private.h                        |   2 +-
 include/linux/clk-provider.h                       |  12 +-
 11 files changed, 422 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/divider-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/gate-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt

-- 
1.8.1.2


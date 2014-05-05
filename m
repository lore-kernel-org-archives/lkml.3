Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbaEEN5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:57:42 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41094 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbaEEN5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:57:40 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] clk: bcm: prerequisite and bus clock support
Date: Mon,  5 May 2014 08:57:31 -0500
Message-Id: <1399298256-10965-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only peripheral clocks are supported for Broadcom
platforms that use Kona style CCUs for clocking.  This series
adds support for bus clocks as well.

One motivation for doing this is that there exist peripheral clocks
that cannot be configured without having first enabled a related
bus; the peripheral clock registers are simply inaccessible if the
bus clock is not enabled.  So adding bus clock support allows such
clocks to be usable.

This also imposes a new requirement, however--that the bus clock
be enabled *before* the clock that depends on it.  For this, we
define the notion of a "prerequisite" clock.  If a clock has a
prerequisite specified, that prequisite clock will be initialized
first.  For now this only affects startup-time initialization.

These patches are based on Mike Turquette's current "clk-next"
branch.  They are available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-bus-clk

					-Alex

Alex Elder (5):
  clk: bcm281xx: add an initialized flag
  clk: bcm281xx: implement prerequisite clocks
  clk: bcm281xx: add bus clock support
  clk: bcm281xx: define a bus clock
  ARM: dts: add bus clock bsc3_apb for bcm281xx

 arch/arm/boot/dts/bcm11351.dtsi      |   3 +-
 drivers/clk/bcm/clk-bcm281xx.c       |  13 +++-
 drivers/clk/bcm/clk-kona-setup.c     | 112 ++++++++++++++++++++++++++++++--
 drivers/clk/bcm/clk-kona.c           | 120 ++++++++++++++++++++++++++++++++++-
 drivers/clk/bcm/clk-kona.h           |  35 +++++++++-
 include/dt-bindings/clock/bcm281xx.h |   3 +-
 6 files changed, 271 insertions(+), 15 deletions(-)

-- 
1.9.1


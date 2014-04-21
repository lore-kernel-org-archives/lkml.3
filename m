Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaDUV0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:26:40 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:55664 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDUV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:26:34 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 RESEND 0/5] clk: bcm21664: add common clock support
Date: Mon, 21 Apr 2014 16:26:22 -0500
Message-Id: <1398115587-32529-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is series has two parts.  The first two patches are changes
to the existing Broadcom Kona family clock code to prepare for the
addition of support for another SoC, bcm21664.

The remaining three define the binding and code for bcm21664, and
replace the use of "fake" clocks in the device tree with the real
ones.  This ends up being a fairly straightforward definition of
the clocks on this SoC; the rest of the clock code is shared with
other SoCs that use the Kona style clock system.

This series depends on the following patch, which has been taken
into the clk-fixes tree:
    clk: bcm281xx: don't use unnamed structs or unions
    https://lkml.org/lkml/2014/4/7/322

In addition, it depends on the version 4 of the following series,
just (re)posted for review:
    clk: bcm281xx: updates
    https://lkml.org/lkml/2014/4/8/485

The patches in this series--based on the current linus/master branch
plus the patches mentioned above--are available here:
    http://git.linaro.org/git/landing-teams/working/broadcom/kernel.git
    Branch review/bcm21664-clock-v2

Alex Elder (5):
  clk: bcm281xx: move compatible string definitions
  ARM: dts: revise kona clock binding document
  ARM: dts: define clock binding for bcm21664
  clk: bcm21664: use common clock framework
  ARM: dts: use real clocks for bcm21664

 .../devicetree/bindings/clock/bcm-kona-clock.txt   | 116 ++++++---
 arch/arm/boot/dts/bcm21664.dtsi                    | 190 +++++++++-----
 drivers/clk/bcm/Kconfig                            |   2 +-
 drivers/clk/bcm/Makefile                           |   1 +
 drivers/clk/bcm/clk-bcm21664.c                     | 290 +++++++++++++++++++++
 drivers/clk/bcm/clk-bcm281xx.c                     |  12 -
 include/dt-bindings/clock/bcm21664.h               |  62 +++++
 include/dt-bindings/clock/bcm281xx.h               |  12 +
 8 files changed, 565 insertions(+), 120 deletions(-)
 create mode 100644 drivers/clk/bcm/clk-bcm21664.c
 create mode 100644 include/dt-bindings/clock/bcm21664.h

-- 
1.9.1

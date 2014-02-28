Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaB1Ntc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:49:32 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41883 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaB1Nt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:49:29 -0500
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org,
        devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] clk: bcm21664: add common clock support
Date: Fri, 28 Feb 2014 07:49:26 -0600
Message-Id: <1393595371-3789-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is series has two parts.  The first two patches are changes
to the existing Broadcom Kona family clock code to prepare for the
addition of support for another SoC bcm21664.

The remaining three define the binding and code for bcm21664, and
replace the use of "fake" clocks in the device tree with the real
ones.  This ends up being a fairly straightforward definition of
the clocks on this SoC; the rest of the clock code is shared with
other SoCs that use the Kona style clock system.

This series depends on a number of other things that are
currently queued for Linux 3.15 or have already been sent
out for review:
    - Clock support for bcm281xx (code and DT file, queued for 3.15)
        https://github.com/broadcom/mach-bcm/
	    armsoc/for-3.15/drivers
	    armsoc/for-3.15/dt
    - Additional fixes and features for bcm281xx (out for review)
	https://lkml.org/lkml/2014/2/25/614
    - Initial BCM21664 support (from Markus Mayer, out for review)
	https://lkml.org/lkml/2014/2/27/615
This prerequisite code appears in the branch (below) as merges from
other publicly-available git branches.

This code is available in the "review/bcm21664-clock" branch of
the git repository here:
    http://git.linaro.org/git/landing-teams/working/broadcom/kernel.git


					-Alex

Alex Elder (5):
  clk: bcm281xx: move compatible string definitions
  ARM: dts: revise kona clock binding document
    Cleanup and prepare existing code for addition of new SoC.

  ARM: dts: define clock binding for bcm21664
  clk: bcm21664: use common clock framework
  ARM: dts: use real clocks for bcm21664
    Add support for the bcm21664 SoC.

 .../devicetree/bindings/clock/bcm-kona-clock.txt   |  116 +++++---
 arch/arm/boot/dts/bcm21664.dtsi                    |  190 ++++++++-----
 drivers/clk/bcm/Kconfig                            |    2 +-
 drivers/clk/bcm/Makefile                           |    1 +
 drivers/clk/bcm/clk-bcm21664.c                     |  290 ++++++++++++++++++++
 drivers/clk/bcm/clk-bcm281xx.c                     |   12 -
 include/dt-bindings/clock/bcm21664.h               |   62 +++++
 include/dt-bindings/clock/bcm281xx.h               |   12 +
 8 files changed, 565 insertions(+), 120 deletions(-)
 create mode 100644 drivers/clk/bcm/clk-bcm21664.c
 create mode 100644 include/dt-bindings/clock/bcm21664.h

-- 
1.7.9.5


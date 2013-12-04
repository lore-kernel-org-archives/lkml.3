Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3LDDzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 22:55:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42105 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3LDDy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 22:54:58 -0500
Message-ID: <529EA78E.7060904@linaro.org>
Date: Tue, 03 Dec 2013 21:54:54 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>
CC: bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] clk: bcm281xx: define Broadcom kona clocks
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for Kona clock control units (CCUs) and
clocks, used by Broadcom BCM281xx family SoCs.  Kona CCUs are
represented by nodes in the device tree, and the names of the clocks
provided by a CCU are included in its node.  Implementation details
of those clocks are defined in a C file separate from the code that
implements the functionality used by most of the common clock
framework.

This series depends on:
    "Update Kona drivers to use clocks"
    https://lkml.org/lkml/2013/11/14/450

This series (along with a version of those prerequisite patches) is
available in the "review/bcm-kona-clocks" branch of this git
repository:
    git://git.linaro.org/people/elder/linux.git

					-Alex

Alex Elder (3):
  clk: bcm281xx: define kona clock binding
  clk: bcm281xx: add initial clock framework support
  ARM: dts: bcm281xx: define real clocks

 .../devicetree/bindings/clock/bcm-kona-clock.txt   |   95 ++
 arch/arm/boot/dts/bcm11351.dtsi                    |  222 +++--
 drivers/clk/Kconfig                                |    1 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Kconfig                            |    8 +
 drivers/clk/bcm/Makefile                           |    3 +
 drivers/clk/bcm/clk-bcm281xx.c                     |  416 ++++++++
 drivers/clk/bcm/clk-kona-setup.c                   |  774 +++++++++++++++
 drivers/clk/bcm/clk-kona.c                         | 1033
++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h                         |  416 ++++++++
 include/dt-bindings/clock/bcm281xx.h               |   65 ++
 11 files changed, 2973 insertions(+), 61 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
 create mode 100644 drivers/clk/bcm/Kconfig
 create mode 100644 drivers/clk/bcm/Makefile
 create mode 100644 drivers/clk/bcm/clk-bcm281xx.c
 create mode 100644 drivers/clk/bcm/clk-kona-setup.c
 create mode 100644 drivers/clk/bcm/clk-kona.c
 create mode 100644 drivers/clk/bcm/clk-kona.h
 create mode 100644 include/dt-bindings/clock/bcm281xx.h

-- 1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaD1X2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:28:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54103 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbaD1X2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:28:13 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 0/2] Add Allwinner SoCs PWM support
Date: Tue, 29 Apr 2014 01:28:04 +0200
Message-Id: <1398727686-14496-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds support for the PWM controller found on the Allwinner SoCs.

The first patch adds the driver itself.
The second patch adds the DT binding documentation

Changes in v4:
 - use the non relaxed versions of readl/writel
 - dropped the DT patches that got applied

Changes in v3:
 - added COMPILE_TEST as a dependency
 - fixed indentation
 - modified the macros like suggested by Maxime

Changes in v2:
 - changed the compatible string
 - documented the clocks property
 - Added support in the A10 dtsi
 - split the patch adding pinctrl
 - a few cosmetic changes (removed empty lines, PWM_PRESCAL_MASK, ...)
 - fixed the period register calculation (the period is actually N + 1 cycles)
   so write prd - 1
 - properly locked accesses to PWM_CTRL_REG with a mutex

Alexandre Belloni (7):
  pwm: Add Allwinner SoC support
  pwm: sunxi: document OF bindings

 .../devicetree/bindings/pwm/pwm-sunxi.txt          |  20 ++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-sunxi.c                            | 345 +++++++++++++++++++++
 4 files changed, 375 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
 create mode 100644 drivers/pwm/pwm-sunxi.c

-- 
1.9.1


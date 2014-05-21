Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaEURgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:36:24 -0400
Received: from ring0.de ([5.45.105.125]:57756 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaEURgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:36:22 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv4 0/4] tsc2005 DT binding
Date: Wed, 21 May 2014 19:36:10 +0200
Message-Id: <1400693774-21306-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This adds device tree support for the tsc2005 touchscreen
controller, which is currently only used by the Nokia N900
board.

The patch does not update the reset pin handling for platform
data based probe to avoid merge conflicts. The n900 platform
code will be removed in the near future (3.17?) and the driver
can be simplified once that has happened.

Changes since v3 [0]:
 * Move common touchscreen DT handling code into its own file
 * Add regulator support to tsc2005 driver
 * Added N900 DTS patch for completeness. It should go via
   Tony's Tree of course.

[0] https://lkml.org/lkml/2014/4/25/694

-- Sebastian

Sebastian Reichel (4):
  Input: add common DT binding for touchscreens
  Input: tsc2005: add DT support
  Documentation: dt: Document TSC2005 DT binding
  DTS: ARM: OMAP3-N900: Add tsc2005 support

 .../bindings/input/touchscreen/touchscreen.txt     |  27 +++++
 .../bindings/input/touchscreen/tsc2005.txt         |  42 +++++++
 arch/arm/boot/dts/omap3-n900.dts                   |  17 ++-
 drivers/input/touchscreen/Kconfig                  |   4 +
 drivers/input/touchscreen/Makefile                 |   1 +
 drivers/input/touchscreen/of_touchscreen.c         |  44 ++++++++
 drivers/input/touchscreen/tsc2005.c                | 122 +++++++++++++++++----
 include/linux/input/touchscreen.h                  |  22 ++++
 8 files changed, 258 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt
 create mode 100644 drivers/input/touchscreen/of_touchscreen.c
 create mode 100644 include/linux/input/touchscreen.h

-- 
2.0.0.rc2


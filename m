Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaK1Qnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:43:47 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56034 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaK1Qnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:43:45 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 0/2] ARM: imx: src: vf610 system reset controller
Date: Fri, 28 Nov 2014 17:43:33 +0100
Message-Id: <1417193015-6033-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a system reset controller handler for Vybrid SoC family.
There is already a driver for the SRC (system reset controller)
module for i.MX6, but since the module in Vybrid is a bit different
I descided to create a new file (there are several MISC registers
with various functionality in the Vybrid case).

I'm not sure if it is acceptable to have that code still in the
machine folder. However, since the current i.MX6 implementation
is located there too, and the module has various functionality
we need for instance from suspend/resume code (future pm-vf610.c),
I descided to put it into the machine folder. If it needs to go
under driver/, my question is how can I properly export the
functionality (e.g. DDR Reset control on standby in MISC_2 or
SRC_GPR), from the PM code located in the machine folder.

Stefan Agner (2):
  ARM: dts: vf610: add system reset controller (SRC)
  ARM: imx: src: support vf610 system reset controller

 arch/arm/boot/dts/vf500.dtsi   |  4 ++++
 arch/arm/boot/dts/vfxxx.dtsi   |  5 ++++
 arch/arm/mach-imx/Makefile     |  2 +-
 arch/arm/mach-imx/common.h     |  1 +
 arch/arm/mach-imx/mach-vf610.c |  8 +++++++
 arch/arm/mach-imx/src-vf610.c  | 53 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-imx/src-vf610.c

-- 
2.1.3


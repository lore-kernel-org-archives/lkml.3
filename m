Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaKLWLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:11:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64415 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbaKLWLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:11:05 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        gta04-owner@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 0/5] omapdss: Add video output support for gta04 board
Date: Wed, 12 Nov 2014 23:10:42 +0100
Message-Id: <1415830247-31633-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for video output on gta04 board. It consist
of opa362 video amplifier driver + DT bindings, adding venc -> opa362 -> svideo-connecor
setup in DT and finally static setup for tvbypass anc acbias in devconf1 register
via pinctrl subsystem.

Changes from v1:
- fix opa362 compilation error
- fix opa362 DT documentation
- move devconf1 definition to omap3.dtsi

Marek Belisko (5):
  video: omapdss: Add opa362 driver
  Documentation: DT: Add documentation for ti,opa362 bindings
  arm: dts: omap3-gta04: Add handling for tv output
  arm: dts: omap3: Add definition for devconf1 register
  arm: dts: omap3-gta04: Add static configuration for devconf1 register

 .../devicetree/bindings/video/ti,opa362.txt        |  38 +++
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  59 ++++
 arch/arm/boot/dts/omap3.dtsi                       |  13 +
 arch/arm/boot/dts/omap34xx.dtsi                    |   4 +
 arch/arm/boot/dts/omap36xx.dtsi                    |   4 +
 drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
 drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
 .../fbdev/omap2/displays-new/amplifier-opa362.c    | 343 +++++++++++++++++++++
 include/video/omap-panel-data.h                    |  12 +
 9 files changed, 480 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/ti,opa362.txt
 create mode 100644 drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c

-- 
1.9.1


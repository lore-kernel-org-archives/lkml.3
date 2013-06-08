Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3FHKFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 06:05:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3FHKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:05:50 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/4] Add external interrupt support for Allwinner SoCs
Date: Sat,  8 Jun 2013 12:05:42 +0200
Message-Id: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch adds the support for the external interrupt sources found in
the PIO IP of the Allwinner SoCs.

This IP handles up to 32 external interrupt source, that are exposed
through a particular pin function on some pins handled by the PIO.

We thus need to change the muxing to enable these interrupts, which
leads to some additional logic.

Thanks,
Maxime

Maxime Ripard (4):
  pinctrl: sunxi: Search the description array by pin id
  pinctrl: sunxi: Add external interrupts support
  pinctrl: sunxi: Add external interrupt functions
  ARM: sunxi: dt: Register the pio node as interrupt controller

 arch/arm/boot/dts/sun4i-a10.dtsi |   2 +
 arch/arm/boot/dts/sun5i-a13.dtsi |   2 +
 drivers/pinctrl/pinctrl-sunxi.c  | 307 +++++++++++++++++++++++++++++++++------
 drivers/pinctrl/pinctrl-sunxi.h  |  68 +++++++++
 4 files changed, 331 insertions(+), 48 deletions(-)

-- 
1.8.3


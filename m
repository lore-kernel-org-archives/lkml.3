Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966641AbaFTKmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:42:21 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36541 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966233AbaFTKmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:42:20 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 0/2] clocksource: add rockchip rk3288 specific armv7-timer
Date: Fri, 20 Jun 2014 12:43:31 +0200
Message-ID: <70167479.zcs3JF0luJ@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The architected timer on Rockchip's RK3288 SoCs needs a bit of special handling
to start.

This seems to be similar to a recent discussion about the Exynos arch-timer
that also seems to need similar special handling (and mct timer running).

And, the arch-timer on recent Mediatek SoCs also uses this pattern of a
supplying timer below the arch-timer.

Therefore follow a suggestion from Arnd Bergmann and implement a separate
clocksource for it that does the setup and then initializes the arch-timer.

This series uses "of: Provide function to request and map memory" from
Matthias Brugger.

Heiko Stuebner (2):
  clocksource: arm_arch_timer: remove static from arch_timer_init
  clocksource: add rockchip-specific armv7-timer setup

 .../bindings/arm/rockchip/armv7-timer.txt          | 22 +++++++++
 drivers/clocksource/Makefile                       |  1 +
 drivers/clocksource/arm_arch_timer.c               |  2 +-
 drivers/clocksource/arm_arch_timer.h               |  7 +++
 drivers/clocksource/rockchip_timer.c               | 57 ++++++++++++++++++++++
 5 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/armv7-timer.txt
 create mode 100644 drivers/clocksource/arm_arch_timer.h
 create mode 100644 drivers/clocksource/rockchip_timer.c

-- 
1.9.0



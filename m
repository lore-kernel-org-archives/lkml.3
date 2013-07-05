Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3GEWvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:51:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37914 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3GEWvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:51:23 -0400
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 0/9] clocksource: dw_apb_timer: support for timer variant used in rk3188 SoCs
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
Date: Sat, 6 Jul 2013 00:51:08 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307060051.09716.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip rk3188 SoCs use a variant of the timer with some slight
modifications. This series implements them as quirks for the dw_apb_timer.

Tested on a rk3188 for the quirk handling and on a rk3066a to check that
nothing broke.

Heiko Stuebner (5):
  clocksource: dw_apb_timer: infrastructure to handle quirks
  clocksource: dw_apb_timer: flexible register addresses
  clocksource: dw_apb_timer: quirk for variants with 64bit counter
  clocksource: dw_apb_timer_of: add quirk handling
  clocksource: dw_apb_timer: special variant for rockchip rk3188 timers

Ulrich Prinz (4):
  clocksource: dw_apb_timer: use the eoi callback to clear pending interrupts
  clocksource: dw_apb_timer: quirk for variants without EOI register
  clocksource: dw_apb_timer: quirk for inverted int mask
  clocksource: dw_apb_timer: quirk for inverted timer mode setting

 .../bindings/arm/rockchip/rk3188-timer.txt         |   20 +++
 arch/x86/kernel/apb_timer.c                        |    4 +-
 drivers/clocksource/dw_apb_timer.c                 |  166 +++++++++++++++-----
 drivers/clocksource/dw_apb_timer_of.c              |   27 +++-
 include/linux/dw_apb_timer.h                       |   34 +++-
 5 files changed, 198 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/rk3188-timer.txt

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3FCT54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:57:56 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51380 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3FCT5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:57:54 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Jamie Iles <jamie@jamieiles.com>, Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] dw_apb_timer: osc as sched_clock, clocks and clocksource_of support
Date: Mon, 3 Jun 2013 21:57:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Rob Herring <rob.herring@calxeda.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306032157.40488.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is split off of my Rockchip support series from yesterday. It's now
a patch more than before, as the third patch enables the timer to be used
thru clocksource_of_init and moves picoxcell and socfpga to it.
 

Heiko Stuebner (3):
  clocksource: dw_apb_timer_of: use the clocksource as sched clock if
    necessary
  clocksource: dw_apb_timer_of: add clock-handling
  clocksource: dw_apb_timer_of: use clocksource_of_init

 Documentation/devicetree/bindings/rtc/dw-apb.txt |   19 +++++
 arch/arm/mach-picoxcell/Kconfig                  |    1 +
 arch/arm/mach-picoxcell/common.c                 |    2 -
 arch/arm/mach-socfpga/Kconfig                    |    1 +
 arch/arm/mach-socfpga/socfpga.c                  |    2 -
 drivers/clocksource/dw_apb_timer_of.c            |   95 ++++++++++++++-------
 include/linux/dw_apb_timer.h                     |    1 -
 7 files changed, 84 insertions(+), 37 deletions(-)

-- 
1.7.2.3


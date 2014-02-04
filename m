Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaBDLcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:32:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55666 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDLbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:31:53 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <daniel.lezcano@linaro.org>,
        <tglx@linutronix.de>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 0/3] Introduce clocksource driver for Keystone platform
Date: Tue, 4 Feb 2014 13:30:50 +0200
Message-ID: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a broadcast timer64 based clockevent driver for keystone arch.
This driver uses timer in 64-bit general purpose mode as clock event
device.

Documentation:
    http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf

Based on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

v3..v4:
	rebased on latest of linux-keystone.git keystone/master

v2..v3:
- clocksource: timer-keystone: introduce clocksource driver for
	changed "u64" type to "unsigned long" for hz_period as more appropriate
	hz_period rounded up by DIV_ROUND_UP(rate, HZ)
	corrected comments

v1..v2:
- clocksource: timer-keystone: introduce clocksource driver for
	renamed timer on "timer-keystone"
	in keystone_timer_interrupt() evet pointer is passed via "dev_id"
	used __relaxed variants of writel/readl and added explicit barriers
	added "keystone_timer_disable()" for using in keystone_set_mode()
	keystone_timer_config() is not used for disabling the timer any more
	in case of an unsupported mode the keystone_timer_config() returns -1.
	used request_irq() instead of setup_irq()
	assigned irq for event_device in event_dev->irq
	calculated timer.hz_period for CLOCK_EVT_MODE_PERIODIC at init
	deleted spare call of keystone_timer_config() in keystone_timer_init()
*

Ivan Khoronzhuk (3):
  clocksource: timer-keystone: introduce clocksource driver for Keystone
  clocksource: keystone: add bindings for keystone timer
  arm: dts: keystone: add keystone timer entry

 .../bindings/timer/ti,keystone-timer.txt           |  29 +++
 arch/arm/boot/dts/keystone-clocks.dtsi             |  10 +
 arch/arm/boot/dts/keystone.dtsi                    |   7 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/timer-keystone.c               | 233 +++++++++++++++++++++
 5 files changed, 280 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/ti,keystone-timer.txt
 create mode 100644 drivers/clocksource/timer-keystone.c

-- 
1.8.3.2


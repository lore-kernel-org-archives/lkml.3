Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3KYOJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:09:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37005 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab3KYOF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:05:56 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v3 0/6] Update Davinci watchdog driver
Date: Mon, 25 Nov 2013 16:04:39 +0200
Message-ID: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are intended to update Davinci watchdog to use WDT core
and reuse driver for keystone arch, because Keystone uses the similar
IP like Davinci.

See Documentation:
Davinci DM646x - http://www.ti.com/lit/ug/spruer5b/spruer5b.pdf
Keystone - http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf

Also:
 - improved to support GET_TIMELEFT option.
 - added "clocks" and "timeout-sec" properties to DT.

Based on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

v2..v3:
- watchdog: davinci: change driver to use WDT core
	removed "ti,keystone-wdt" compatible from driver
	renamed wdt device names for mach-davinci from
		"watchdog" to "davinci-wdt"

- watchdog: davinci: reuse driver for keystone arch
	moved "clocks" property under "Optional properties"
	improved decsription of "clocks" property

- arm: dts: keystone: add watchdog entry
	replaced "ti,keystone-wdt" compatible on
		 "ti,keystone-wdt","ti,davinci-wdt"

Ivan Khoronzhuk (6):
  watchdog: davinci: change driver to use WDT core
  watchdog: davinci: use davinci_wdt_device structure to hold device
    data
  watchdog: davinci: add GET_TIMELEFT option support
  watchdog: davinci: add "timeout-sec" property
  watchdog: davinci: reuse driver for keystone arch
  arm: dts: keystone: add watchdog entry

 .../devicetree/bindings/watchdog/davinci-wdt.txt   |   16 +-
 arch/arm/boot/dts/keystone.dtsi                    |    6 +
 arch/arm/mach-davinci/da8xx-dt.c                   |    2 +-
 arch/arm/mach-davinci/devices-da8xx.c              |    4 +-
 arch/arm/mach-davinci/devices.c                    |    2 +-
 drivers/watchdog/Kconfig                           |    6 +-
 drivers/watchdog/davinci_wdt.c                     |  225 +++++++++-----------
 7 files changed, 126 insertions(+), 135 deletions(-)

-- 
1.7.9.5


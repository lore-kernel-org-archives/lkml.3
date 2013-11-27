Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3K0MuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:50:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33743 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3K0Mt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:49:59 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 0/5] Update Davinci watchdog driver
Date: Wed, 27 Nov 2013 14:48:23 +0200
Message-ID: <1385556508-3935-1-git-send-email-ivan.khoronzhuk@ti.com>
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

v3..v4:
- watchdog: davinci: change driver to use WDT core
	reverted rename of platform driver to "davinci-wdt"
	as it causes a regression on Davinci platforms.

- arm: dts: keystone: add watchdog entry
	The patch will be sent separately after series is ready.

v2..v3:
- watchdog: davinci: change driver to use WDT core
	removed "ti,keystone-wdt" compatible from driver
	renamed wdt device names for mach-davinci from
		"watchdog" to "davinci-wdt"

- watchdog: davinci: reuse driver for keystone arch
	moved "clocks" property under "Optional properties"
	improved description of "clocks" property

- arm: dts: keystone: add watchdog entry
	replaced "ti,keystone-wdt" compatible on
		 "ti,keystone-wdt","ti,davinci-wdt"

v1..v2:
- watchdog: davinci: change driver to use WDT core
	corrected 2011 -> 2006-2013
	removed useless function comment
	corrected initialization of heartbeat
	switched on CONFIG_WATCHDOG_NOWAYOUT option

- watchdog: davinci: use davinci_wdt_device structure to hold device data
	substituted wdd to watchdog device in commit message

- watchdog: davinci: add GET_TIMELEFT option support
	corrected comment (is -> has)
	removed redundant error message "clock freq is not set"

- watchdog: davinci: add GET_STATUS option support
	dropped

- watchdog: davinci: add "timeout-sec" property
	use consistent formatting

- watchdog: davinci: reuse driver for keystone arch
	use consistent formatting

- watchdog: davinci: add "clocks" property
	merged with above patch

Ivan Khoronzhuk (5):
  watchdog: davinci: change driver to use WDT core
  watchdog: davinci: use davinci_wdt_device structure to hold device
    data
  watchdog: davinci: add GET_TIMELEFT option support
  watchdog: davinci: add "timeout-sec" property
  watchdog: davinci: reuse driver for keystone arch

 .../devicetree/bindings/watchdog/davinci-wdt.txt   |   16 +-
 drivers/watchdog/Kconfig                           |    6 +-
 drivers/watchdog/davinci_wdt.c                     |  221 +++++++++-----------
 3 files changed, 114 insertions(+), 129 deletions(-)

-- 
1.7.9.5


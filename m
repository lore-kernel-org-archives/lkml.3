Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3KRRUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:20:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59847 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab3KRRUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:20:34 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Sekhar Nori <nsekhar@ti.com>,
        <linux-watchdog@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Strashko Grygorii <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v2 0/6] Update Davinci watchdog driver
Date: Mon, 18 Nov 2013 19:18:53 +0200
Message-ID: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com>
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

Ivan Khoronzhuk (6):
  watchdog: davinci: change driver to use WDT core
  watchdog: davinci: use davinci_wdt_device structure to hold device
    data
  watchdog: davinci: add GET_TIMELEFT option support
  watchdog: davinci: add "timeout-sec" property
  watchdog: davinci: reuse driver for keystone arch
  arm: dts: keystone: add watchdog entry

 .../devicetree/bindings/watchdog/davinci-wdt.txt   |   15 +-
 arch/arm/boot/dts/keystone.dts                     |    6 +
 drivers/watchdog/Kconfig                           |    6 +-
 drivers/watchdog/davinci_wdt.c                     |  227 +++++++++-----------
 4 files changed, 122 insertions(+), 132 deletions(-)

-- 
1.7.9.5


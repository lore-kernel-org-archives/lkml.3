Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab3KFLbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:31:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52350 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab3KFLbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:31:07 -0500
Message-ID: <527A284A.8000901@ti.com>
Date: Wed, 6 Nov 2013 13:30:18 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Fwd: [PATCH 0/8] Update Davinci watchdog driver
References: <1383680783-12114-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1383680783-12114-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Forwarded-Message-Id: <1383680783-12114-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
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
 - improved to support GET_TIMELEFT and GET_STATUS options.
 - added "clocks" and "timeout-sec" properties to DT.

Based on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

TO:
Santosh Shilimkar <santosh.shilimkar@ti.com> (maintainer: TI KEYSTONE MACHIN...)
Wim Van Sebroeck <wim@iguana.be> (maintainer:WATCHDOG DEVICE D...)
Sekhar Nori <nsekhar@ti.com> (supporter:TI DAVINCI MACHIN...)
linux-watchdog@vger.kernel.org (open list:WATCHDOG DEVICE D...)
devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)

CC:
Grant Likely <grant.likely@linaro.org> (maintainer:OPEN FIRMWARE AND...)
Rob Herring <rob.herring@calxeda.com> (maintainer:OPEN FIRMWARE AND...)
Pawel Moll <pawel.moll@arm.com> (maintainer:OPEN FIRMWARE AND...)
Mark Rutland <mark.rutland@arm.com> (maintainer:OPEN FIRMWARE AND...)
Stephen Warren <swarren@wwwdotorg.org> (maintainer:OPEN FIRMWARE AND...)
Kumar Gala <galak@kernel.crashing.org>
Ian Campbell <ijc+devicetree@hellion.org.uk> (maintainer:OPEN FIRMWARE AND...)
linux-kernel@vger.kernel.org (open list)
linux-arm-kernel@lists.infradead.org (moderated list:ARM SUB-ARCHITECT...)

Ivan Khoronzhuk (8):
  watchdog: davinci: change driver to use WDT core
  watchdog: davinci: use davinci_wdt_device structure to hold device
    data
  watchdog: davinci: add GET_TIMELEFT option support
  watchdog: davinci: add GET_STATUS option support
  watchdog: davinci: add "timeout-sec" property
  watchdog: davinci: reuse driver for keystone arch
  watchdog: davinci: add "clocks" property
  arm: dts: keystone: add watchdog entry

 .../devicetree/bindings/watchdog/davinci-wdt.txt   |   21 +-
 arch/arm/boot/dts/keystone.dts                     |    6 +
 drivers/watchdog/Kconfig                           |    5 +-
 drivers/watchdog/davinci_wdt.c                     |  234 ++++++++++----------
 4 files changed, 139 insertions(+), 127 deletions(-)

-- 
1.7.9.5




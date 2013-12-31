Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3LaVkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:40:37 -0500
Received: from mail-gw6-out.broadcom.com ([216.31.217.47]:49561 "EHLO
	mail-gw6-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3LaVkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:40:17 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 16:40:17 EST
X-IronPort-AV: E=Sophos;i="4.95,582,1384329600"; 
   d="scan'208";a="273562"
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH 0/2] watchdog: bcm281xx: Debugfs support
Date: Tue, 31 Dec 2013 13:22:12 -0800
Message-ID: <1388524934-10563-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds debugfs support to the bcm281xx watchdog driver. Most
of the code submitted here was already included as part of v5 of the
original driver submission. See
http://www.spinics.net/lists/linux-watchdog/msg03328.html

However, the debugfs code has since been broken out of the original
driver submission and the following changes have been made over what
was submitted earlier:

- The global variable busy_count is now, instead, part of struct
  bcm_kona_wdt.
- As a result secure_register_read() now needs to take a struct
  bcm_kona_wdt * and a register offset as its arguments.
- debugfs setup and teardown is now performed by
  bcm_kona_wdt_debug_init() and bcm_kona_wdt_debug_exit() rather than
  by using #ifdefs in bcm_kona_wdt_probe() and
  bcm_kona_wdt_debug_exit().

This series is dependent on commit
bd90ccd42c5d6317979c62919ba1c79fd34fa785 in linux-watchdog-next.

Markus Mayer (2):
  watchdog: bcm281xx: Debugfs support
  watchdog: bcm281xx: Turn on debugfs support for watchdog driver

 arch/arm/configs/bcm_defconfig  |    1 +
 drivers/watchdog/Kconfig        |   10 ++++
 drivers/watchdog/bcm_kona_wdt.c |  116 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 123 insertions(+), 4 deletions(-)

-- 
1.7.9.5


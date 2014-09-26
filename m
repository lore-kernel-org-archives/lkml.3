Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaIZNIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:08:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37898 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaIZNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:08:09 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Walleij <linus.walleij@linaro.org>, Wim Van Sebroeck <wim@iguana.be>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Immutable branch with restart handler patches for v3.18
Date: Fri, 26 Sep 2014 06:07:54 -0700
Message-Id: <1411736874-15421-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

you may need to pull this set of patches if a patch in your scope
of responsibility is introducing the restart handlers.

Thanks,
Guenter
------

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/restart-handler-for-v3.18

for you to fetch changes up to 6cd6d94d96d9b1cd8a62da91aac44cf56e301e75:

  arm/arm64: unexport restart handlers (2014-09-26 00:00:48 -0700)

----------------------------------------------------------------
Immutable branch with restart handler patches for v3.18

----------------------------------------------------------------
Guenter Roeck (8):
      kernel: add support for kernel restart handler call chain
      power/restart: call machine_restart instead of arm_pm_restart
      arm64: support restart through restart handler call chain
      arm: support restart through restart handler call chain
      watchdog: moxart: register restart handler with kernel restart handler
      watchdog: alim7101: register restart handler with kernel restart handler
      watchdog: sunxi: register restart handler with kernel restart handler
      arm/arm64: unexport restart handlers

 arch/arm/kernel/process.c              | 12 +++--
 arch/arm64/kernel/process.c            |  3 +-
 drivers/power/reset/restart-poweroff.c |  3 +-
 drivers/watchdog/alim7101_wdt.c        | 42 +++++++++++++-----
 drivers/watchdog/moxart_wdt.c          | 32 +++++++++-----
 drivers/watchdog/sunxi_wdt.c           | 31 ++++++++-----
 include/linux/reboot.h                 |  3 ++
 kernel/reboot.c                        | 81 ++++++++++++++++++++++++++++++++++
 8 files changed, 165 insertions(+), 42 deletions(-)

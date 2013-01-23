Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3AWOot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:44:49 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:39421 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3AWOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:44:47 -0500
Date: Wed, 23 Jan 2013 14:44:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [GIT PULL] power: ab8500-bm: Latest Mainline<->STE delta
 reduction patch-set
Message-ID: <20130123144441.GN15873@gmail.com>
References: <20130123113854.GK15873@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130123113854.GK15873@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, after Linus Walleij's diligent observaions, I have removed all
new functionallity related to Deep Debug and will continue to
investigate what I need to do in that regard.

In the mean-time, here's the fresh deep-debug:less pull-request:

----------------------------------------------------------------

The following changes since commit 8fd526fd18233887ba652079a369f4eee0de9d9d:

  qnap-poweroff: Fix license string (2013-01-19 18:04:04 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/linux-3.0-ux500.git tb-power-2

for you to fetch changes up to 34c11a709e928090cf34ecd706f7d3170f4e5026:

  u8500-charger: Delay for USB enumeration (2013-01-23 14:39:22 +0000)

----------------------------------------------------------------
Hakan Berg (1):
      ab8500-fg: Adjust for RF bursts voltage drops

Henrik Sölver (1):
      ab8500-charger: AB workaround for invalid charger

Jonas Aaberg (2):
      ab8500-bm: Flush all work queues before suspending
      ab8500-charger: Do not touch VBUSOVV bits

Lee Jones (7):
      ab8500-charger: Kick watchdog
      ab8500-chargalg: Update battery health on safety timer exp
      pm2301: Move all configuration and emum structs out to a header
      file
      ab8500-chargalg: Only root should have write permission on sysfs
      file
      abx500-chargalg: Add new sysfs interface to get current charge
      status
      pm2301: LPN mode control support
      ab8500-bm: Remove individual [charger|btemp|fg|chargalg] pdata
      structures

Loic Pallardy (2):
      pm2301: Remove volt_now & curr_now properties
      pm2301: Update watchdog for pm2xxx support

Martin Bergström (1):
      ab8500-fg: Go to INIT_RECOVERY when charger removed

Michel JAOUEN (2):
      pm2301: Provide u9540 support for the pm2301 charger
      ab8500-btemp: Adaptation to AB8505 and AB9540 platforms

Nicolas Guion (1):
      ab8500-charger: Add support for autopower on AB8505 and AB9540

Olivier Clergeaud (1):
      pm2301: Clean-up PM2301 interrupt management

Paer-Olof Haakansson (1):
      u8500-charger: Delay for USB enumeration

Rajkumar Kasirajan (2):
      pm2301: Enable vbat low monitoring
      ab8500-fg: Use correct battery charge full design

 drivers/mfd/ab8500-core.c                 |    6 +
 drivers/power/Kconfig                     |    7 +
 drivers/power/Makefile                    |    1 +
 drivers/power/ab8500_btemp.c              |   67 +-
 drivers/power/ab8500_charger.c            |  617 ++++++++++++----
 drivers/power/ab8500_fg.c                 |   51 +-
 drivers/power/abx500_chargalg.c           |   43 +-
 drivers/power/pm2301_charger.c            | 1088 +++++++++++++++++++++++++++++
 drivers/power/pm2301_charger.h            |  513 ++++++++++++++
 include/linux/mfd/abx500.h                |    3 +
 include/linux/mfd/abx500/ab8500-bm.h      |   22 +-
 include/linux/mfd/abx500/ab8500.h         |   19 +
 include/linux/mfd/abx500/ux500_chargalg.h |    5 +
 include/linux/pm2301_charger.h            |   61 ++
 14 files changed, 2306 insertions(+), 197 deletions(-)
 create mode 100644 drivers/power/pm2301_charger.c
 create mode 100644 drivers/power/pm2301_charger.h
 create mode 100644 include/linux/pm2301_charger.h

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

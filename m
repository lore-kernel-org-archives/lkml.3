Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3BLV1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:27:00 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:20765 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3BLV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:26:59 -0500
Message-ID: <511AB39F.4090202@tilera.com>
Date: Tue, 12 Feb 2013 16:26:55 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile bug fixes for v3.8
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.8 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This includes a variety of minor bug fixes, mostly to do with testing
"make allyesconfig", "make allmodconfig", "make allnoconfig", inspired
to Tejun Heo's observation about Kconfig.freezer not being included.
The largest changes are just syntax changes removing the tile-specific use
of a macro named INT_MASK, which is way too commonly redefined throughout
driver code.

Chris Metcalf (9):
      tile: remove an unused variable in copy_thread()
      tile: include kernel/Kconfig.freezer in tile Kconfig
      drivers/input/joystick/analog.c: enable precise timer
      tile: provide "screen_info" when enabling VT
      tile: avoid defining INT_MASK macro in <arch/interrupts.h>
      drm: fix compile failure by including <linux/swiotlb.h>
      tile: export a handful of symbols appropriately
      tile: fix memcpy_*io functions for allnoconfig
      tile: tag some code with #ifdef CONFIG_COMPAT

 arch/tile/Kconfig                           |    2 +
 arch/tile/include/asm/io.h                  |    6 +-
 arch/tile/include/asm/irqflags.h            |   32 +--
 arch/tile/include/uapi/arch/interrupts_32.h |  394 ++++++++++++++-------------
 arch/tile/include/uapi/arch/interrupts_64.h |  346 +++++++++++------------
 arch/tile/kernel/intvec_64.S                |    4 +
 arch/tile/kernel/process.c                  |    2 +-
 arch/tile/kernel/reboot.c                   |    2 +
 arch/tile/kernel/setup.c                    |    5 +
 arch/tile/kernel/stack.c                    |    3 +-
 arch/tile/lib/cacheflush.c                  |    2 +
 arch/tile/lib/cpumask.c                     |    2 +
 arch/tile/lib/exports.c                     |    2 +
 arch/tile/mm/homecache.c                    |    1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c        |    1 +
 drivers/gpu/drm/radeon/radeon_ttm.c         |    1 +
 drivers/input/joystick/analog.c             |    2 +-
 17 files changed, 413 insertions(+), 394 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


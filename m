Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3EAVZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:25:37 -0400
Received: from longford.logfs.org ([213.229.74.203]:58942 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3EAVZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:25:27 -0400
Date: Wed, 1 May 2013 15:58:15 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PULL] blockconsole and netconsole changes
Message-ID: <20130501195815.GA22691@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the bcon2 tree.  It mainly contains blockconsole, which
allows directing printk to a block device (usually a cheap usb key).
Given your preference for WARN_ON_ONCE over BUG_ON, you might actually
have some personal interest.

CON_ALLDATA changes behaviour for blockconsole and netconsole.  They
now receive all messages, independent of console_loglevel.  I
personally have found this immensely useful and on a fundamental level
there really is no argument for having the same filter on a
user-interactive console and a debugging-only message dump.

All but the last two commit have soaked in -next for some weeks.  The
last two are a trivial bugfix with several machineyears of testing and
a documentation change.  Neither should collide with anyone else's
tree.

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joern/bcon2.git master

for you to fetch changes up to e284f3493206d4268267db4557c7ee6f89ed2314:

  netconsole: s/syslogd/cancd/ in documentation (2013-04-19 12:19:14 -0700)

----------------------------------------------------------------
Joern Engel (10):
      do_mounts: constify name_to_dev_t parameter
      add blockconsole version 1.1
      printk: add CON_ALLDATA console flag
      netconsole: use CON_ALLDATA
      blockconsole: use CON_ALLDATA
      bcon: add a release work struct
      bcon: check for hdparm in bcon_tail
      bcon: remove version 1.0 support
      bcon: Fix wrap-around behaviour
      netconsole: s/syslogd/cancd/ in documentation

Takashi Iwai (4):
      blockconsole: Allow to pass a device file path to bcon_tail
      blockconsole: Fix undefined MAX_RT_PRIO
      blockconsole: Rename device_lock with bc_device_lock
      blockconsole: Mark a local work struct static

 Documentation/block/blockconsole.txt            |   94 ++++
 Documentation/block/blockconsole/bcon_tail      |   82 +++
 Documentation/block/blockconsole/mkblockconsole |   29 ++
 Documentation/networking/netconsole.txt         |   16 +-
 block/partitions/Makefile                       |    1 +
 block/partitions/blockconsole.c                 |   22 +
 block/partitions/check.c                        |    3 +
 block/partitions/check.h                        |    3 +
 drivers/block/Kconfig                           |    6 +
 drivers/block/Makefile                          |    1 +
 drivers/block/blockconsole.c                    |  618 +++++++++++++++++++++++
 drivers/net/netconsole.c                        |    2 +-
 include/linux/blockconsole.h                    |    7 +
 include/linux/console.h                         |    1 +
 include/linux/mount.h                           |    2 +-
 init/do_mounts.c                                |    2 +-
 kernel/printk.c                                 |    5 +-
 17 files changed, 885 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/block/blockconsole.txt
 create mode 100755 Documentation/block/blockconsole/bcon_tail
 create mode 100755 Documentation/block/blockconsole/mkblockconsole
 create mode 100644 block/partitions/blockconsole.c
 create mode 100644 drivers/block/blockconsole.c
 create mode 100644 include/linux/blockconsole.h

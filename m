Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3EIWLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:11:25 -0400
Received: from longford.logfs.org ([213.229.74.203]:59063 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab3EIWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:11:23 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 00/14] Add blockconsole version 1.1 (try 3)
Date: Thu,  9 May 2013 16:42:56 -0400
Message-Id: <1368132193-25817-1-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blockconsole is a console driver very roughly similar to netconsole.
Instead of sending messages out via UDP, they are written to a block
device.  Typically a USB stick is chosen, although in principle any
block device will do.

In most cases blockconsole is useful where netconsole is not, i.e.
single machines without network access or without an accessable
netconsole capture server.  When using both blockconsole and
netconsole, I have found netconsole to sometimes create a mess under
high message load (sysrq-t, etc.) while blockconsole does not.

Most importantly, a number of bugs were identified and fixed that
would have been unexplained machine reboots without blockconsole.

More highlights:
* reasonably small and self-contained code,
* some 100+ machine years of runtime,
* nice tutorial with a 30-sec guide for the impatient.

Special thanks to Borislav Petkov for many improvements and kicking my
behind to provide a proper git tree and resend patches.

Git tree is on kernel.org and I intend to keep it stable, as people
seem to be using it already.  It has been in -next since Mar 7.

git://git.kernel.org/pub/scm/linux/kernel/git/joern/bcon2.git

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

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3EIWOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:14:53 -0400
Received: from longford.logfs.org ([213.229.74.203]:59139 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3EIWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:14:52 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 0/9] Add blockconsole version 1.1 (try 2)
Date: Thu,  9 May 2013 16:43:13 -0400
Message-Id: <1368132193-25817-18-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
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

A number of cleanup patches could be folded into the main patch, but I
decided not to mess with git history and leave any further mistakes
for the world to laugh at:
git://git.kernel.org/pub/scm/linux/kernel/git/joern/bcon2.git

Joern Engel (8):
  do_mounts: constify name_to_dev_t parameter
  add blockconsole version 1.1
  printk: add CON_ALLDATA console flag
  netconsole: use CON_ALLDATA
  blockconsole: use CON_ALLDATA
  bcon: add a release work struct
  bcon: check for hdparm in bcon_tail
  bcon: remove version 1.0 support

Takashi Iwai (1):
  blockconsole: Allow to pass a device file path to bcon_tail

 Documentation/block/blockconsole.txt            |   94 ++++
 Documentation/block/blockconsole/bcon_tail      |   82 +++
 Documentation/block/blockconsole/mkblockconsole |   29 ++
 block/partitions/Makefile                       |    1 +
 block/partitions/blockconsole.c                 |   22 +
 block/partitions/check.c                        |    3 +
 block/partitions/check.h                        |    3 +
 drivers/block/Kconfig                           |    6 +
 drivers/block/Makefile                          |    1 +
 drivers/block/blockconsole.c                    |  617 +++++++++++++++++++++++
 drivers/net/netconsole.c                        |    2 +-
 include/linux/blockconsole.h                    |    7 +
 include/linux/console.h                         |    1 +
 include/linux/mount.h                           |    2 +-
 init/do_mounts.c                                |    2 +-
 kernel/printk.c                                 |    5 +-
 16 files changed, 872 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/block/blockconsole.txt
 create mode 100755 Documentation/block/blockconsole/bcon_tail
 create mode 100755 Documentation/block/blockconsole/mkblockconsole
 create mode 100644 block/partitions/blockconsole.c
 create mode 100644 drivers/block/blockconsole.c
 create mode 100644 include/linux/blockconsole.h

-- 
1.7.10.4


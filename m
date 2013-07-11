Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3GKBfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab3GKBfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:35:15 -0400
Date: Thu, 11 Jul 2013 02:34:48 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Hannes Reinecke <hare@suse.de>,
        Jim Ramsay <jim_ramsay@dell.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Robin Dong <sanbai@taobao.com>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>
Subject: [git pull] device-mapper changes for 3.11
Message-ID: <20130711013448.GD32399@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>, Hannes Reinecke <hare@suse.de>,
	Jim Ramsay <jim_ramsay@dell.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <gmazyland@gmail.com>,
	Rob Herring <robherring2@gmail.com>, Robin Dong <sanbai@taobao.com>,
	stable@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.11-changes

to get the following device-mapper changes for 3.11.

Thanks,
Alasdair


----------------------------------------------------------------
Add a device-mapper target called dm-switch to provide a multipath
framework for storage arrays that dynamically reconfigure their
preferred paths for different device regions.

Fix a bug in the verity target that prevented its use with some
specific sizes of devices.

Improve some locking mechanisms in the device-mapper core and bufio.

Add Mike Snitzer as a device-mapper maintainer.

A few more clean-ups and fixes.

----------------------------------------------------------------
Alasdair G Kergon (2):
      dm flakey: correct ctr alloc failure mesg
      dm: update maintainers

Hannes Reinecke (1):
      dm mpath: fix ioctl deadlock when no paths

Jim Ramsay (1):
      dm: add switch target

Mikulas Patocka (9):
      dm ioctl: set noio flag to avoid __vmalloc deadlock
      dm verity: fix inability to use a few specific devices sizes
      dm: use __GFP_HIGHMEM in __vmalloc
      dm verity: remove pointless comparison
      dm verity: use __ffs and __fls
      dm cache: fix arm link errors with inline
      dm bufio: submit writes outside lock
      dm: optimize use SRCU and RCU
      dm: optimize reorder structure

 Documentation/device-mapper/switch.txt |  126 ++++++++
 MAINTAINERS                            |    2 +
 drivers/md/Kconfig                     |   14 +
 drivers/md/Makefile                    |    1 +
 drivers/md/dm-bufio.c                  |   75 ++++-
 drivers/md/dm-cache-target.c           |    4 +
 drivers/md/dm-flakey.c                 |    2 +-
 drivers/md/dm-ioctl.c                  |  127 +++++---
 drivers/md/dm-mpath.c                  |    8 +-
 drivers/md/dm-switch.c                 |  538 ++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c                  |   35 ---
 drivers/md/dm-verity.c                 |   17 +-
 drivers/md/dm.c                        |  177 ++++++-----
 include/linux/device-mapper.h          |    6 +-
 include/uapi/linux/dm-ioctl.h          |    4 +-
 15 files changed, 951 insertions(+), 185 deletions(-)
 create mode 100644 Documentation/device-mapper/switch.txt
 create mode 100644 drivers/md/dm-switch.c


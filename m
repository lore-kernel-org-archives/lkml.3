Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3I2UBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:01:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3I2UBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:01:04 -0400
Date: Sun, 29 Sep 2013 13:01:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.12-rc3
Message-ID: <20130929200105.GA30897@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.12-rc3

for you to fetch changes up to 8bbf9f440f196ee08cc5ab1c19e62b1c5a736ff0:

  Drivers: hv: vmbus: Terminate vmbus version negotiation on timeout (2013-09-26 14:20:22 -0700)

----------------------------------------------------------------
Char / Misc driver fixes for 3.12-rc3

Here are some HyperV and MEI driver fixes for 3.12-rc3.  They resolve some
issues that people have been reporting for them.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (1):
      mei: cancel stall timers in mei_reset

K. Y. Srinivasan (2):
      Drivers: hv: util: Correctly support ws2008R2 and earlier
      Drivers: hv: vmbus: Terminate vmbus version negotiation on timeout

Tomas Winkler (2):
      mei: make me client counters less error prone
      mei: bus: stop wait for read during cl state transition

 drivers/hv/connection.c    |  2 +-
 drivers/hv/hv_kvp.c        | 38 +++++++++++++++++--------
 drivers/hv/hv_snapshot.c   |  6 ++--
 drivers/hv/hv_util.c       | 71 +++++++++++++++++++++++++++++++++++-----------
 drivers/misc/mei/amthif.c  |  1 +
 drivers/misc/mei/bus.c     |  5 +++-
 drivers/misc/mei/client.h  |  6 ++++
 drivers/misc/mei/hbm.c     | 10 ++++---
 drivers/misc/mei/init.c    |  3 ++
 drivers/misc/mei/main.c    | 11 +++----
 drivers/misc/mei/mei_dev.h |  6 ++--
 include/linux/hyperv.h     |  7 +++--
 12 files changed, 116 insertions(+), 50 deletions(-)

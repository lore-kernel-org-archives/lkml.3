Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3GZQ5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:57:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3GZQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:57:19 -0400
Date: Fri, 26 Jul 2013 09:57:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.11-rc3
Message-ID: <20130726165718.GA22596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.11-rc3

for you to fetch changes up to 81b884c9dfe6753a78df0cbf4e96f095d718bd95:

  MAINTAINERS: Update the list of maintainers for staging/comedi driver. (2013-07-24 09:51:18 -0700)

----------------------------------------------------------------
Staging fixes for 3.11-rc3

Here are some tiny drivers/staging/ fixes for 3.11-rc3

A number of bugfixes, all pretty tiny, but resolve issues that have been
reported (the kstrtos32 change fixes a data corruption problem that Dan
found.)  And a MAINTAINERS file update for the comedi drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dan Carpenter (2):
      staging: frontier: use after free in disconnect()
      staging: gdm72xx: potential use after free in send_qos_list()

Ian Abbott (2):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
      staging: comedi: fix a race between do_cmd_ioctl() and read/write

Jingoo Han (1):
      staging: tidspbridge: replace strict_strtol() with kstrtos32()

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error

Lidza Louina (1):
      MAINTAINERS: Update the list of maintainers for staging/comedi driver.

Paul Bolle (1):
      staging: drm/imx: drop "select OF_VIDEOMODE"

Sergey Senozhatsky (1):
      staging: zram: protect zram_reset_device() call

 MAINTAINERS                             |  2 +-
 drivers/staging/android/logger.c        |  4 +++-
 drivers/staging/comedi/TODO             |  2 +-
 drivers/staging/comedi/comedi_fops.c    | 32 +++++++++++++++++++++-----------
 drivers/staging/frontier/alphatrack.c   |  2 +-
 drivers/staging/gdm72xx/gdm_qos.c       |  2 +-
 drivers/staging/imx-drm/Kconfig         |  1 -
 drivers/staging/tidspbridge/pmgr/dbll.c |  7 +++++--
 drivers/staging/zram/zram_drv.c         |  6 +++++-
 9 files changed, 38 insertions(+), 20 deletions(-)

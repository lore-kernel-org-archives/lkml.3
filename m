Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab3C1RRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:17:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50555 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab3C1RQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:16:58 -0400
Date: Thu, 28 Mar 2013 10:16:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.9-rc4
Message-ID: <20130328171655.GA2577@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3d374d09f16f64ab4d71704cbe621514d36cd0b1:

  final removal of CONFIG_EXPERIMENTAL (2013-03-12 16:30:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.9-rc4

for you to fetch changes up to 347e0899b1c75d907f01ac883ca38d37fe9bfa42:

  VMCI: Fix process-to-process DRGAMs. (2013-03-15 12:58:12 -0700)

----------------------------------------------------------------
char/misc driver fixes for 3.9-rc4

Here are some small char/misc driver fixes that resolve issues recently
reported against the 3.9-rc kernels.  All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andy King (1):
      VMCI: Fix process-to-process DRGAMs.

Chanwoo Choi (3):
      extcon: max8997: Check the pointer of platform data to protect null pointer error
      extcon: max77693: Fix bug of wrong pointer when platform data is not used
      extcon: max77693: Initialize register of MUIC device to bring up it without platform data

Greg Kroah-Hartman (1):
      Merge tag 'extcon-3.9-rc3' of git://git.kernel.org/.../chanwoo/extcon into char-misc-linus

Tomas Winkler (2):
      mei: add mei_stop function to stop mei device
      mei: ME hardware reset needs to be synchronized

 drivers/extcon/extcon-max77693.c      | 103 ++++++++++++++++++++++++++--------
 drivers/extcon/extcon-max8997.c       |  56 ++++++++++--------
 drivers/misc/mei/hw-me.c              |  29 +++++++---
 drivers/misc/mei/init.c               |  18 ++++++
 drivers/misc/mei/mei_dev.h            |   1 +
 drivers/misc/mei/pci-me.c             |  52 +++--------------
 drivers/misc/vmw_vmci/vmci_datagram.c |   4 +-
 include/linux/mfd/max77693-private.h  |  23 ++++++++
 8 files changed, 186 insertions(+), 100 deletions(-)

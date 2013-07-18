Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3GRToq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3GRTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:44:45 -0400
Date: Thu, 18 Jul 2013 12:44:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.11-rc2
Message-ID: <20130718194452.GA18493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.11-rc2

for you to fetch changes up to 08801f966571b522f0581de0fd400abdf295b16b:

  driver-core: fix new kernel-doc warning in base/platform.c (2013-07-16 22:43:50 -0700)

----------------------------------------------------------------
Driver core patches for 3.11-rc2

Here are some driver core patches for 3.11-rc2.  They aren't really
bugfixes, but a bunch of new helper macros for drivers to properly
create attribute groups, which drivers and subsystems need to fix up a
ton of race issues with incorrectly creating sysfs files (binary and
normal) after userspace has been told that the device is present.

Also here is the ability to create binary files as attribute groups, to
solve that race condition, which was impossible to do before this, so
that's my fault the drivers were broken.

The majority of the .c changes is indenting and moving code around a
bit.  It affects no existing code, but allows the large backlog of 70+
patches that I already have created to start flowing into the different
subtrees, instead of having to live in my driver-core tree, causing
merge nightmares in linux-next for the next few months.

These were finalized too late for the -rc1 merge window, which is why
they were didn't make that pull request, testing and review from others
didn't happen until a few weeks ago, and then there's the whole
distraction of the past few days, which prevented these from getting to
you sooner, sorry about that.

Oh, and there's a bugfix for the documentation build warning in here as
well.  All of these have been in linux-next this week, with no reported
problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (6):
      sysfs.h: add __ATTR_RW() macro
      sysfs.h: add ATTRIBUTE_GROUPS() macro
      sysfs.h: add BIN_ATTR macro
      driver core: device.h: add RW and RO attribute macros
      sysfs: add support for binary attributes in groups
      driver core: add default groups to struct class

Guenter Roeck (1):
      driver core: Introduce device_create_groups

Oliver Schinagl (3):
      sysfs: prevent warning when only using binary attributes
      sysfs: add more helper macro's for (bin_)attribute(_groups)
      sysfs: use file mode defines from stat.h

Randy Dunlap (1):
      driver-core: fix new kernel-doc warning in base/platform.c

 drivers/base/core.c     | 120 ++++++++++++++++++++++++++++++++++++------------
 drivers/base/platform.c |   1 +
 fs/sysfs/group.c        |  70 +++++++++++++++++++---------
 include/linux/device.h  |  37 +++++++++++----
 include/linux/sysfs.h   |  64 ++++++++++++++++++++++----
 kernel/events/core.c    |   2 -
 mm/backing-dev.c        |   2 -
 7 files changed, 224 insertions(+), 72 deletions(-)

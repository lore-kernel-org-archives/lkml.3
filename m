Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaJGWc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:32:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaJGWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:32:56 -0400
Date: Tue, 7 Oct 2014 15:32:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core patches for 3.18-rc1
Message-ID: <20141007223256.GA5547@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.18-rc1

for you to fetch changes up to 906d201530f2c52aeb4eee31895c71cdccf1e9a0:

  dynamic_debug: change __dynamic_<foo>_dbg return types to void (2014-10-03 14:55:48 -0700)

----------------------------------------------------------------
Driver core patches for 3.18-rc1

Here's the driver core patches for 3.18-rc1.  Just a few small things,
and the addition of a new interface to dump firmware "core dumps" to
userspace through sysfs that the wireless and graphic drivers want to
use.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ben Hutchings (1):
      drivers/base: Fix length checks in create_syslog_header()/dev_vprintk_emit()

Darren Hart (1):
      Documentation/sysfs-rules.txt: Add device attribute error code documentation

Geert Uytterhoeven (2):
      Documentation: devres: Add missing devm_kstrdup() managed interface
      devres: Improve devm_kasprintf()/kvasprintf() support

Joe Perches (1):
      dynamic_debug: change __dynamic_<foo>_dbg return types to void

Johannes Berg (1):
      device coredump: add new device coredump class

Kees Cook (1):
      firmware_class: make sure fw requests contain a name

Thierry Reding (1):
      driver core: Remove kerneldoc from local function

Tina Johnson (2):
      attribute_container: fix whitespace errors
      attribute_container: fix coding style issues

Tobias Klauser (1):
      Documentation: devres: Add missing IRQ functions

Yasuaki Ishimatsu (1):
      driver/base/node: remove unnecessary kfree of node struct from unregister_one_node

 Documentation/driver-model/devres.txt |   5 +
 Documentation/sysfs-rules.txt         |  21 +++
 MAINTAINERS                           |   7 +
 drivers/base/Kconfig                  |  21 +++
 drivers/base/Makefile                 |   1 +
 drivers/base/attribute_container.c    |  14 +-
 drivers/base/core.c                   |   9 ++
 drivers/base/dd.c                     |   2 +-
 drivers/base/devcoredump.c            | 265 ++++++++++++++++++++++++++++++++++
 drivers/base/devres.c                 |  15 +-
 drivers/base/firmware_class.c         |   3 +
 drivers/base/node.c                   |   1 -
 include/linux/devcoredump.h           |  35 +++++
 include/linux/device.h                |   4 +-
 include/linux/dynamic_debug.h         |  12 +-
 lib/dynamic_debug.c                   |  50 +++----
 16 files changed, 411 insertions(+), 54 deletions(-)
 create mode 100644 drivers/base/devcoredump.c
 create mode 100644 include/linux/devcoredump.h

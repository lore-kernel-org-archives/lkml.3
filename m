Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaBNVXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:23:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaBNVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:23:34 -0500
Date: Fri, 14 Feb 2014 13:24:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc fixes for 3.14-rc3
Message-ID: <20140214212453.GA19280@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.14-rc3

for you to fetch changes up to bf7471038840547c9328291b4d9d91c55581dcb8:

  Revert "misc: eeprom: sunxi: Add new compatibles" (2014-02-14 11:16:08 -0800)

----------------------------------------------------------------
Char/Misc fixes for 3.14-rc3

Here are some small char/misc driver fixes, along with some
documentation updates, for 3.14-rc3.  Nothing major, just a number of
fixes for reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (2):
      mei: clear write cb from waiting list on reset
      mei: don't unset read cb ptr on reset

Christian Engelmayer (1):
      misc: genwqe: Fix potential memory leak when pinning memory

Fu Wei (3):
      Documentation:Chinese translation of Documentation/arm64/tagged-pointers.txt
      Documentation:Update Documentation/zh_CN/arm64/booting.txt
      Documentation:Update Documentation/zh_CN/arm64/memory.txt

Greg Kroah-Hartman (2):
      Revert "ARM: sunxi: dt: Convert to the new SID compatibles"
      Revert "misc: eeprom: sunxi: Add new compatibles"

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Specify the target CPU that should receive notification
      Drivers: hv: vmbus: Don't timeout during the initial connection with host

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Maxime Ripard (2):
      misc: eeprom: sunxi: Add new compatibles
      ARM: sunxi: dt: Convert to the new SID compatibles

Paul Bolle (2):
      raw: test against runtime value of max_raw_minors
      raw: set range for MAX_RAW_DEVS

Sudeep Dutt (1):
      misc: mic: fix possible signed underflow (undefined behavior) in userspace API

 Documentation/zh_CN/arm64/booting.txt         | 65 +++++++++++++++++++--------
 Documentation/zh_CN/arm64/memory.txt          | 46 ++++++++++++++++---
 Documentation/zh_CN/arm64/tagged-pointers.txt | 52 +++++++++++++++++++++
 drivers/char/Kconfig                          |  1 +
 drivers/char/raw.c                            |  2 +-
 drivers/hv/connection.c                       | 13 ++----
 drivers/misc/genwqe/card_dev.c                |  1 +
 drivers/misc/mei/client.c                     | 11 ++++-
 drivers/misc/mic/host/mic_virtio.c            |  3 +-
 drivers/vme/bridges/vme_ca91cx42.c            |  4 +-
 drivers/vme/bridges/vme_tsi148.c              |  4 +-
 include/linux/hyperv.h                        |  2 +-
 include/uapi/linux/mic_ioctl.h                |  2 +-
 13 files changed, 161 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/zh_CN/arm64/tagged-pointers.txt

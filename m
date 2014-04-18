Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaDRViu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:38:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbaDRVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:38:45 -0400
Date: Fri, 18 Apr 2014 14:38:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc fixes for 3.15-rc2
Message-ID: <20140418213854.GA3818@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.15-rc2

for you to fetch changes up to 03367ef5ea811475187a0732aada068919e14d61:

  Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts (2014-04-16 14:14:07 -0700)

----------------------------------------------------------------
Char/Misc driver fixes for 3.15-rc2

Here are a few driver fixes for char/misc drivers that resolve reported
issues.

All have been in linux-next successfully for a few days.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaron Sierra (1):
      vme_tsi148: Utilize to_pci_dev() macro

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Christoph Jaeger (1):
      drivers: mcb: fix memory leak in chameleon_parse_cells() error path

Colin Ian King (1):
      GenWQE: Ensure rc is not returning an uninitialized value

David Fries (2):
      w1: fix netlink refcnt leak on error path
      w1: avoid recursive device_add

Frank Haverkamp (4):
      GenWQE: Enable access to VPD flash area
      GenWQE: Add wmb before DDCB is started
      GenWQE: Fix multithreading problems
      GenWQE: Increase driver version number

Geert Uytterhoeven (1):
      misc: Grammar s/addition/additional/

Joe Schultz (2):
      vme_tsi148: Fix typo in tsi148_slave_get()
      vme_tsi148: Fix PCI address mapping assumption

K. Y. Srinivasan (2):
      Tools: hv: Handle the case when the target file exists correctly
      Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts

Tomas Winkler (1):
      mei: me: do not load the driver if the FW doesn't support MEI interface

 drivers/hv/connection.c             |   5 +-
 drivers/mcb/mcb-parse.c             |   1 +
 drivers/misc/Kconfig                |   4 +-
 drivers/misc/genwqe/card_base.h     |  58 ++++++++----
 drivers/misc/genwqe/card_ddcb.c     |   6 +-
 drivers/misc/genwqe/card_dev.c      |  44 ++++------
 drivers/misc/genwqe/card_utils.c    | 170 +++++++++++++++++++++++++++---------
 drivers/misc/genwqe/genwqe_driver.h |   2 +-
 drivers/misc/mei/hw-me-regs.h       |   5 ++
 drivers/misc/mei/interrupt.c        |   3 +-
 drivers/misc/mei/main.c             |   3 +-
 drivers/misc/mei/pci-me.c           |  30 +++++--
 drivers/vme/bridges/vme_tsi148.c    |  22 +++--
 drivers/w1/w1.c                     |  32 ++-----
 drivers/w1/w1_netlink.c             |  44 ++++++----
 include/linux/hyperv.h              |   4 +-
 include/uapi/linux/hyperv.h         |   1 +
 tools/hv/hv_fcopy_daemon.c          |   4 +-
 18 files changed, 280 insertions(+), 158 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3ICQyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:54:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:43835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab3ICQye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:54:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1015,1367996400"; 
   d="scan'208";a="396106055"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Maxime Bizon <mbizon@freebox.fr>
Cc: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [GIT PULL] pstore changes for 3.12
Date: Tue, 03 Sep 2013 09:54:14 -0700
Message-Id: <5226143646912050@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to 3bd11cf56e4d9c9a79c0c1a4ebe381c674ec9709:

  pstore/ram: (really) fix undefined usage of rounddown_pow_of_two (2013-08-30 15:57:01 -0700)

----------------------------------------------------------------
Big part of this is the addition of compression to the
generic pstore layer so that all backends can use the
pitiful amounts of storage they control more effectively.
Three other small fixes/cleanups too.

----------------------------------------------------------------
Aruna Balakrishnaiah (11):
      powerpc/pseries: Remove (de)compression in nvram with pstore enabled
      pstore: Add new argument 'compressed' in pstore write callback
      pstore/Kconfig: Select ZLIB_DEFLATE and ZLIB_INFLATE when PSTORE is selected
      pstore: Add compression support to pstore
      pstore: Introduce new argument 'compressed' in the read callback
      pstore: Add decompression support to pstore
      pstore: Add file extension to pstore file if compressed
      powerpc/pseries: Read and write to the 'compressed' flag of pstore
      erst: Read and write to the 'compressed' flag of pstore
      efi-pstore: Read and write to the 'compressed' flag of pstore
      pstore/ram: Read and write to the 'compressed' flag of pstore

Dan Carpenter (1):
      pstore: d_alloc_name() doesn't return an ERR_PTR

Maxime Bizon (1):
      pstore/ram: (really) fix undefined usage of rounddown_pow_of_two

Wei Yongjun (1):
      acpi/apei/erst: Add missing iounmap() on error in erst_exec_move_data()

 arch/powerpc/platforms/pseries/nvram.c | 112 ++++-------------
 drivers/acpi/apei/erst.c               |  25 +++-
 drivers/firmware/efi/efi-pstore.c      |  27 ++++-
 fs/pstore/Kconfig                      |   2 +
 fs/pstore/inode.c                      |  10 +-
 fs/pstore/internal.h                   |   5 +-
 fs/pstore/platform.c                   | 212 ++++++++++++++++++++++++++++++---
 fs/pstore/ram.c                        |  47 ++++++--
 include/linux/pstore.h                 |   6 +-
 9 files changed, 306 insertions(+), 140 deletions(-)

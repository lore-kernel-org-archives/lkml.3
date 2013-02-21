Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3BURcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:32:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:41272 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3BURcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:32:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,710,1355126400"; 
   d="scan'208";a="294246486"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pstore patches for 3.9 merge window
Date: Thu, 21 Feb 2013 09:32:50 -0800
Message-Id: <51265a42210853da3f@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to fb0af3f2b1b613e5ea75426d454c7e5b1d1eef49:

  pstore: Create a convenient mount point for pstore (2013-02-12 13:07:22 -0800)

----------------------------------------------------------------
A few fixes to reduce places where pstore might hang
a system in the crash path. Plus a new mountpoint
(/sys/fs/pstore ... makes more sense then /dev/pstore).

----------------------------------------------------------------
Josh Boyer (1):
      pstore: Create a convenient mount point for pstore

Seiji Aguchi (4):
      pstore: Avoid deadlock in panic and emergency-restart path
      efi_pstore: Avoid deadlock in non-blocking paths
      efivars: Disable external interrupt while holding efivars->lock
      efi_pstore: Introducing workqueue updating sysfs

 Documentation/ABI/testing/pstore |  10 +--
 drivers/firmware/efivars.c       | 180 +++++++++++++++++++++++++++++----------
 fs/pstore/inode.c                |  18 +++-
 fs/pstore/platform.c             |  35 ++++++--
 include/linux/efi.h              |   3 +-
 include/linux/pstore.h           |   6 ++
 6 files changed, 192 insertions(+), 60 deletions(-)

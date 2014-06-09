Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaFIJxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:53:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:46334 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaFIJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:53:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1001,1392192000"; 
   d="scan'208";a="552558889"
Message-ID: <1402307589.20454.49.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.16
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jun 2014 12:53:09 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.16-rc1

for you to fetch changes up to 380347e9ca76828ee9bac63cfc338ca99cdee4f3:

  UBIFS: Add an assertion for clean_zn_cnt (2014-06-03 11:16:51 +0300)

----------------------------------------------------------------
condition between the mmap page fault path and fsync. The other
just removes a bogus assertion from the UBIFS memory shrinker.

UBIFS also started honoring the MS_SILENT mount flag, so now it won't print
many I/O errors when user-space just tries to probe for the FS.

Rest of the changes are rather minor UBI/UBIFS fixes, improvements, and
clean-ups.

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBIFS: fix debugging check

Daniel Golle (2):
      UBIFS: add missing ui pointer in debugging code
      UBIFS: respect MS_SILENT mount flag

Ezequiel Garcia (1):
      UBI: weaken the 'exclusive' constraint when opening volumes to rename

Helmut Schaa (1):
      UBI: block: Fix error path on alloc_workqueue failure

Mike Snitzer (1):
      UBI: fix rb_tree node comparison in add_map

hujianyang (5):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove unused variables in ubifs_budget_space
      UBIFS: Fix dump messages in ubifs_dump_lprops
      UBIFS: Remove incorrect assertion in shrink_tnc()
      UBIFS: Add an assertion for clean_zn_cnt

 drivers/mtd/ubi/block.c   |  4 +++-
 drivers/mtd/ubi/cdev.c    |  2 +-
 drivers/mtd/ubi/fastmap.c |  4 ++--
 fs/ubifs/budget.c         |  1 -
 fs/ubifs/debug.c          |  4 +++-
 fs/ubifs/file.c           |  6 +++---
 fs/ubifs/io.c             | 18 ++++++++++--------
 fs/ubifs/shrinker.c       |  1 -
 fs/ubifs/super.c          |  5 +++++
 fs/ubifs/tnc.c            |  5 +++--
 fs/ubifs/ubifs.h          | 11 +++++++++++
 11 files changed, 41 insertions(+), 20 deletions(-)

-- 
Best Regards,
Artem Bityutskiy


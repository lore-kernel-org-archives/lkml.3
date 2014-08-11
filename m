Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaHKIo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:44:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:53741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaHKIo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:44:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="586355466"
Message-ID: <1407746495.25561.112.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI/UBIFS fixes for 3.17-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 11 Aug 2014 11:41:35 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 033ead8230c2cf9cdc2d6e1148bfdf5674012a9c:

  Merge tag 'upstream-3.16-rc6' of git://git.infradead.org/linux-ubifs (2014-07-18 06:23:34 -1000)

are available in the git repository at:


  git://git.infradead.org/linux-ubifs.git tags/upstream-3.17-rc1

for you to fetch changes up to 25601a3c9737fed554169759582c690b98ead5d4:

  UBIFS: Add log overlap assertions (2014-07-31 15:52:51 +0300)

----------------------------------------------------------------
No significant changes, mostly small fixes here and there. The more important
fixes are:

* UBI deleted list items while iterating the list with 'list_for_each_entry'
* The UBI block driver did not work properly with very large UBI volumes

----------------------------------------------------------------
Artem Bityutskiy (5):
      UBIFS: fix spelling of "scanned"
      UBIFS: remove mst_mutex
      UBIFS: remove unnecessary check
      UBIFS: add a log overlap assertion
      Revert "UBIFS: add a log overlap assertion"

Ezequiel Garcia (2):
      UBI: block: Make ubiblock_resize return something
      UBI: block: Set disk_capacity out of the mutex

Fabian Frederick (4):
      UBIFS: kernel-doc warning fix
      UBIFS: replace count*size kzalloc by kcalloc
      UBIFS: replace seq_printf by seq_puts
      UBIFS: kernel-doc warning fix

Richard Weinberger (3):
      UBI: init_volumes: Ignore volumes with no LEBs
      UBI: block: Avoid disk size integer overflow
      UBI: bugfix in ubi_wl_flush()

Seunghun Lee (1):
      UBIFS: fix some comments

hujianyang (6):
      UBIFS: fix error handling in dump_lpt_leb()
      UBIFS: Add missing break statements in dbg_chk_pnode()
      UBIFS: remove useless statements
      UBIFS: remove useless @ecc in struct ubifs_scan_leb
      UBIFS: fix error path in create_default_filesystem()
      UBIFS: Add log overlap assertions

 drivers/mtd/ubi/block.c | 18 ++++++++++++------
 drivers/mtd/ubi/vtbl.c  |  2 +-
 drivers/mtd/ubi/wl.c    |  4 ++--
 fs/ubifs/commit.c       |  2 --
 fs/ubifs/io.c           |  2 +-
 fs/ubifs/log.c          | 12 ++++++------
 fs/ubifs/lpt.c          |  5 ++---
 fs/ubifs/lpt_commit.c   |  7 +++++--
 fs/ubifs/master.c       |  7 +++----
 fs/ubifs/orphan.c       |  1 -
 fs/ubifs/recovery.c     |  5 ++---
 fs/ubifs/sb.c           |  4 +++-
 fs/ubifs/scan.c         | 14 +++++++-------
 fs/ubifs/super.c        | 19 +++++++++----------
 fs/ubifs/tnc.c          |  1 -
 fs/ubifs/tnc_commit.c   |  1 -
 fs/ubifs/ubifs.h        |  4 ----
 17 files changed, 53 insertions(+), 55 deletions(-)

-- 
Best Regards,
Artem Bityutskiy


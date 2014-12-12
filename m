Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100AbaLLQYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:24:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:61906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbaLLQYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:24:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="636733554"
Message-ID: <1418401440.30433.20.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI/UBIFS updates 3.19-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Dec 2014 18:24:00 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.19-rc1

for you to fetch changes up to f38aed975c0c3645bbdfc5ebe35726e64caaf588:

  UBI: Fix invalid vfree() (2014-11-07 15:14:09 +0200)

----------------------------------------------------------------
This pull request includes the following UBI/UBIFS changes:
* UBI debug messages now include the UBI device number. This change
  is responsible for the big diffstat since it touched every debugging
  print statement.
* An Xattr bug-fix which fixes SELinux support
* Several error path fixes in UBI/UBIFS

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBIFS: fix budget leak in error path

Richard Weinberger (3):
      UBI: vtbl: Use ubi_eba_atomic_leb_change()
      UBI: Fix double free after do_sync_erase()
      UBI: Fix invalid vfree()

Subodh Nijsure (1):
      UBIFS: fix a couple bugs in UBIFS xattr length calculation

Tanya Brokhman (1):
      UBI: Extend UBI layer debug/messaging capabilities

 drivers/mtd/ubi/attach.c  | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
 drivers/mtd/ubi/block.c   |  41 ++++++++++++++++++++---------------------
 drivers/mtd/ubi/build.c   | 126 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------
 drivers/mtd/ubi/cdev.c    |  36 +++++++++++++++++++-----------------
 drivers/mtd/ubi/debug.c   |  10 +++++-----
 drivers/mtd/ubi/eba.c     |  53 +++++++++++++++++++++++++++--------------------------
 drivers/mtd/ubi/fastmap.c |  96 ++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 drivers/mtd/ubi/io.c      | 150 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
 drivers/mtd/ubi/kapi.c    |   6 +++---
 drivers/mtd/ubi/misc.c    |   4 ++--
 drivers/mtd/ubi/ubi.h     |  13 +++++++------
 drivers/mtd/ubi/upd.c     |  10 ++++++----
 drivers/mtd/ubi/vmt.c     |  69 ++++++++++++++++++++++++++++++++++++---------------------------------
 drivers/mtd/ubi/vtbl.c    |  71 ++++++++++++++++++++++++++++++++++-------------------------------------
 drivers/mtd/ubi/wl.c      |  80 ++++++++++++++++++++++++++++++++++++++++++--------------------------------------
 fs/ubifs/file.c           |   1 +
 fs/ubifs/journal.c        |   7 ++++++-
 17 files changed, 466 insertions(+), 433 deletions(-)

--
Artem


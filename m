Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaJMOBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:01:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:12131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaJMOBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:01:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="613645011"
Message-ID: <1413208834.7906.30.camel@sauron.fi.intel.com>
Subject: Re: [GIT PULL] UBI/UBIFS fixes for 3.18-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2014 17:00:34 +0300
In-Reply-To: <1413208012.7906.23.camel@sauron.fi.intel.com>
References: <1413208012.7906.23.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 16:46 +0300, Artem Bityutskiy wrote:
> Hi Linus,

Please, disregard this pull request in favor of the following request.
The issue is that I did not update my local 'linux-next' git branch with
the remote branch, which had more stuff comparing to what I had in the
local branch, so my pull request missed several patches.

Here is the v2 pull request. Thanks, and apologies for my mistake.


The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.18-rc1-v2

for you to fetch changes up to 91401a34038e614076dbfb5c4969a052e72fb296:

  UBI: Fastmap: Calc fastmap size correctly (2014-10-03 17:33:28 +0300)

----------------------------------------------------------------
* Fix for a theoretical race condition which could lead to a situation when
  UBIFS is unable to mount a file-system (Hujianyang)
* Few fixes for the ubiblock sybsystem, error path fixes
* The ubiblock subsystem has had the volume size change handling improved
* Few fixes and nicifications in the fastmap subsystem

----------------------------------------------------------------
Artem Bityutskiy (2):
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Colin Ian King (1):
      UBI: block: fix dereference on uninitialized dev

Dan Carpenter (1):
      UBI: return on error in rename_volumes()

Ezequiel Garcia (3):
      UBI: block: Fix block device size setting
      UBI: block: Add support for the UBI_VOLUME_UPDATED notification
      UBI: Dispatch update notification if the volume is updated

Richard Genoud (1):
      UBI: add missing kmem_cache_free() in process_pool_aeb error path

Richard Weinberger (8):
      UBIFS: Remove bogus assert
      UBI: Improve comment on work_sem
      UBI: Fix livelock in produce_free_peb()
      UBI: ubi_eba_read_leb: Remove in vain variable assignment
      UBI: wl: Rename cancel flag to shutdown
      UBI: Fix trivial typo in __schedule_ubi_work
      UBIFS: Fix trivial typo in power_cut_emulated()
      UBI: Fastmap: Calc fastmap size correctly

hujianyang (1):
      UBIFS: Align the dump messages of SB_NODE

 drivers/mtd/ubi/block.c   | 36 +++++++++++++++++++++++++-----------
 drivers/mtd/ubi/cdev.c    |  6 ++++--
 drivers/mtd/ubi/eba.c     |  5 ++---
 drivers/mtd/ubi/fastmap.c |  4 +++-
 drivers/mtd/ubi/ubi.h     | 12 +++++++-----
 drivers/mtd/ubi/wl.c      | 28 +++++++++++++++-------------
 fs/ubifs/commit.c         |  8 +++-----
 fs/ubifs/debug.c          |  6 +++---
 fs/ubifs/journal.c        |  7 +++----
 fs/ubifs/log.c            | 19 ++++++++++++++-----
 10 files changed, 79 insertions(+), 52 deletions(-)

--
Artem


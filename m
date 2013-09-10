Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3IJAzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:55:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:5604 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab3IJAz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,874,1371106800"; 
   d="scan'208";a="358151039"
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, "Koul, Vinod" <vinod.koul@intel.com>
Subject: [GIT PULL] dmaengine update for 3.12
Thread-Topic: [GIT PULL] dmaengine update for 3.12
Thread-Index: AQHOrcBwFEyX681Bm06dty0/LRu/1w==
Date: Tue, 10 Sep 2013 00:55:27 +0000
Message-ID: <1378774528.4094.14.camel@dwillia2-mobl1.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.7.189.72]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFBF575AD47C8940910DF62AD199144F@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8A0tZb8024076

Hi Linus,


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine tags/dmaengine-3.12

for you to fetch changes up to 4a43f394a08214eaf92cdd8ce3eae75e555323d8:

  dmaengine: dma_sync_wait and dma_find_channel undefined (2013-09-09 17:02:38 -0700)

----------------------------------------------------------------
dmaengine update for 3.12

Collection of random updates to the core and some end-driver fixups for
ioatdma and mv_xor:
* NUMA aware channel allocation
* Cleanup dmatest debugfs interface
* ioat: make raid-support Atom only
* mv_xor: big endian

----------------------------------------------------------------

Aside from the top three commits:
4a43f39 dmaengine: dma_sync_wait and dma_find_channel undefined
ab5f8c6 MAINTAINERS: update email for Dan Williams
a577659 dma: mv_xor: Fix incorrect error path

...these have all had some soak time in -next.  The top commit fixes a recent build breakage.

It has been a long while since my last pull request, hopefully it does
not show.  Thanks to Vinod for keeping an eye on drivers/dma/ this past
year.

--
Dan


Andy Shevchenko (3):
      dmatest: make module parameters writable
      dmatest: remove IS_ERR_OR_NULL checks of debugfs calls
      dmatest: print message on debug level in case of no error

Brice Goglin (2):
      ioatdma: disable RAID on non-Atom platforms and reenable unaligned copies
      dmaengine: make dma_channel_rebalance() NUMA aware

Dan Carpenter (1):
      dmaengine: make dma_submit_error() return an error code

Dan Williams (1):
      MAINTAINERS: update email for Dan Williams

Jon Mason (1):
      dmaengine: dma_sync_wait and dma_find_channel undefined

Paul Bolle (1):
      ioatdma: silence GCC warnings

Sachin Kamat (1):
      dma: mv_xor: Fix incorrect error path

Thomas Petazzoni (2):
      mv_xor: use {readl, writel}_relaxed instead of __raw_{readl, writel}
      mv_xor: support big endian systems using descriptor swap feature

 Documentation/dmatest.txt |  15 ++--
 MAINTAINERS               |  18 ++---
 drivers/dma/dmaengine.c   |  55 +++++++-------
 drivers/dma/dmatest.c     | 182 ++++++++--------------------------------------
 drivers/dma/ioat/dma_v3.c |  26 +------
 drivers/dma/mv_xor.c      |  53 ++++++++------
 drivers/dma/mv_xor.h      |  28 ++++++-
 include/linux/dmaengine.h |  17 ++++-
 8 files changed, 146 insertions(+), 248 deletions(-)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3CZWmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:42:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:14085 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab3CZWmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:42:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276349273"
Subject: [PATCH 00/10] Add Intel Atom S1200 seris ioatdma support
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:42:29 -0700
Message-ID: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds support for the Intel Atom S1200 product family
ioatdma. This ioatdma also implements a set of version v3.3 features such as 16
sources PQ, descriptor write back error status, and does not have many of the
silicon bugs that the 3.2 line of hardware has due to a brand new implemention.

The series is dependent on the haswell update patch sent prior.

---

Dave Jiang (10):
      ioatdma: Adding PCI IDs for Intel Atom S1200 product family ioatdma devices
      ioatdma: Add 64bit chansts register read for ioat v3.3.
      ioatdma: channel reset scheme fixup on Intel Atom S1200 platforms
      ioatdma: Removing hw bug workaround for CB3.x .2 and earlier
      ioatdma: skip legacy reset bits since v3.3 plattform doesn't need it
      ioatdma: Removing PQ val disable for cb3.3
      ioatdma: skip silicon bug workaround for pq_align for cb3.3
      ioatdma: Adding support for 16 src PQ ops and super extended descriptors
      ioatdma: Adding write back descriptor error status support for ioatdma 3.3
      ioatdma: S1200 platforms ioatdma channel 2 and 3 falsely advertise RAID cap


 drivers/dma/Kconfig          |    2 
 drivers/dma/ioat/dma.c       |   14 +
 drivers/dma/ioat/dma.h       |   59 +++
 drivers/dma/ioat/dma_v2.h    |    2 
 drivers/dma/ioat/dma_v3.c    |  930 ++++++++++++++++++++++++++++++++++++------
 drivers/dma/ioat/hw.h        |   66 +++
 drivers/dma/ioat/pci.c       |    9 
 drivers/dma/ioat/registers.h |    4 
 8 files changed, 941 insertions(+), 145 deletions(-)

-- 
Signature

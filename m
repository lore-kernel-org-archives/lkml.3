Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3CDJJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:09:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:56622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3CDJJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="298628348"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 00/10] dmatest: update the module to use debugfs
Date: Mon,  4 Mar 2013 11:09:24 +0200
Message-Id: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first approach to get dmatest module more flexible and easier to play with.
The amount of patches could be reduced, but I would like to get a comments
first on smaller pieces. The entire series creates dmatest.txt file in the
Documentation folder. Similar description is scattered through the commit
messages.

Module was tested on Intel Medfield and Lynxpoint systems with dw_dmac DMA
controller embedded.

Andy Shevchenko (10):
  dmatest: cancel thread immediately when asked for
  dmatest: allocate memory for pq_coefs from heap
  dmatest: create dmatest_info to keep test parameters
  dmatest: move dmatest_channels and nr_channels to dmatest_info
  dmatest: split test parameters to separate structure
  dmatest: run test via debugfs
  dmatest: return actual state in 'run' file
  dmatest: define MAX_ERROR_COUNT constant
  dmatest: gather test results in the linked list
  dmatest: append verify result to results

 Documentation/dmatest.txt |  81 +++++
 drivers/dma/dmatest.c     | 887 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 832 insertions(+), 136 deletions(-)
 create mode 100644 Documentation/dmatest.txt

-- 
1.8.2.rc0.22.gb3600c3


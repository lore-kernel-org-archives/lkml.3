Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3AXKgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:36:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:44680 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab3AXKeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:34:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="194648129"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/4] dw_dmac: return actual residue value
Date: Thu, 24 Jan 2013 12:34:16 +0200
Message-Id: <1359023660-29084-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series is targeted for getting proper residue value.

Since v2:
 - get rid of dwc_update_residue(): for soft LLP mode we assign residue in
   dwc_do_start() and decrease it at each interrupt. In the middle of transfer
   we will return that result substracted by amount of sent bytes
Since v1:
 - everything is rewritten to address Viresh's and Vinod's comments.

*** BLURB HERE ***

Andy Shevchenko (4):
  dw_dmac: remove unnecessary tx_list field in dw_dma_chan
  dw_dmac: introduce total_len field in struct dw_desc
  dw_dmac: fill individual length of descriptor
  dw_dmac: return proper residue value

 drivers/dma/dw_dmac.c      |   79 ++++++++++++++++++++++++++++++++++++--------
 drivers/dma/dw_dmac_regs.h |    3 +-
 2 files changed, 67 insertions(+), 15 deletions(-)

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3AYJsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:48:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:16096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab3AYJsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:48:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208";a="276498994"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 0/4] dw_dmac: return actual residue value
Date: Fri, 25 Jan 2013 11:47:59 +0200
Message-Id: <1359107283-5274-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series is targeted for getting proper residue value.

Since v3:
- split dwc_get_residue() from dwc_tx_status and improve locking there
- patch 1/4 "dw_dmac: remove unnecessary tx_list field in dw_dma_chan" was
  amended a bit to simplify patch 4/4

Since v2:
- get rid of dwc_update_residue(): for soft LLP mode we assign residue in
  dwc_do_start() and decrease it at each interrupt. In the middle of transfer
  we will return that result substracted by amount of sent bytes

Since v1:
- everything is rewritten to address Viresh's and Vinod's comments.

Andy Shevchenko (4):
  dw_dmac: remove unnecessary tx_list field in dw_dma_chan
  dw_dmac: introduce total_len field in struct dw_desc
  dw_dmac: fill individual length of descriptor
  dw_dmac: return proper residue value

 drivers/dma/dw_dmac.c      |   82 +++++++++++++++++++++++++++++++++++++-------
 drivers/dma/dw_dmac_regs.h |    3 +-
 2 files changed, 71 insertions(+), 14 deletions(-)

-- 
1.7.10.4


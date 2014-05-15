Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaEOOha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:37:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:39054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbaEOOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:37:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="512197448"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Yao Jin <yao.jin@intel.com>, Aubrey Li <aubrey.li@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] i2c: designware: No need to disable already disabled controller
Date: Thu, 15 May 2014 17:37:21 +0300
Message-Id: <1400164644-3222-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400164644-3222-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1400164644-3222-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the controller is already in desired state (enabled/disabled) there is
no point in setting its state again.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index b58ecf19e767..b0792675b970 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -258,6 +258,10 @@ static void __i2c_dw_enable(struct dw_i2c_dev *dev, bool enable)
 {
 	int timeout = 100;
 
+	/* In case the controller is already in desired state */
+	if ((dw_readl(dev, DW_IC_ENABLE_STATUS) & 1) == enable)
+		return;
+
 	do {
 		dw_writel(dev, enable, DW_IC_ENABLE);
 		if ((dw_readl(dev, DW_IC_ENABLE_STATUS) & 1) == enable)
-- 
2.0.0.rc2


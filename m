Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaKRM7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:59:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:34558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbaKRM7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:59:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="624205593"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: wsa@the-dreams.de, julia.lawall@lip6.fr, dan.carpenter@oracle.com,
        johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 3/4] mfd: dln2: add a limit check for invalid echo
Date: Tue, 18 Nov 2014 14:57:59 +0200
Message-Id: <1416315480-2053-4-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
References: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The echo field in dln2_transfer_complete comes directly from an USB
transfer and we should not trust it is valid.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/dln2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index cf22841..df2fda9 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -195,6 +195,9 @@ static bool dln2_transfer_complete(struct dln2_dev *dln2, struct urb *urb,
 	struct dln2_rx_context *rxc;
 	bool valid_slot = false;
 
+	if (rx_slot >= DLN2_MAX_RX_SLOTS)
+		goto out;
+
 	rxc = &rxs->slots[rx_slot];
 
 	/*
@@ -210,6 +213,7 @@ static bool dln2_transfer_complete(struct dln2_dev *dln2, struct urb *urb,
 	}
 	spin_unlock(&rxs->lock);
 
+out:
 	if (!valid_slot)
 		dev_warn(dev, "bad/late response %d/%d\n", handle, rx_slot);
 
-- 
1.9.1


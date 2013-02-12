Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab3BLK7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:59:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:25915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013Ab3BLK7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:59:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="290016858"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/6] dmaengine.h: remove redundant else keyword
Date: Tue, 12 Feb 2013 12:58:35 +0200
Message-Id: <1360666720-19006-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine_device_control returns -ENOSYS in case the dma driver doesn't have
such functionality.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/dmaengine.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index bfcdecb..b760b38 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -610,8 +610,7 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
 {
 	if (chan->device->device_control)
 		return chan->device->device_control(chan, cmd, arg);
-	else
-		return -ENOSYS;
+	return -ENOSYS;
 }
 
 static inline int dmaengine_slave_config(struct dma_chan *chan,
-- 
1.7.10.4


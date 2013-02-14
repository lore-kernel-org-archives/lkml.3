Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3BNJAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:00:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:46799 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab3BNJAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:00:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="256839648"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/6] dmaengine.h: remove redundant else keyword
Date: Thu, 14 Feb 2013 11:00:16 +0200
Message-Id: <1360832420-6349-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine_device_control returns -ENOSYS in case the dma driver doesn't have
such functionality.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/dmaengine.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index bfcdecb..f593999 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -610,8 +610,8 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
 {
 	if (chan->device->device_control)
 		return chan->device->device_control(chan, cmd, arg);
-	else
-		return -ENOSYS;
+
+	return -ENOSYS;
 }
 
 static inline int dmaengine_slave_config(struct dma_chan *chan,
-- 
1.7.10.4


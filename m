Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab3ENOt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:49:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:25274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab3ENOtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="337416037"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH v2 7/8] net/tipc: take msecs_to_jiffies_timeout into use
Date: Tue, 14 May 2013 17:48:37 +0300
Message-Id: <1368542918-8861-8-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_timeout instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 net/tipc/core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/core.h b/net/tipc/core.h
index 0207db0..b24e2fc 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -133,7 +133,7 @@ static inline void k_init_timer(struct timer_list *timer, Handler routine,
  */
 static inline void k_start_timer(struct timer_list *timer, unsigned long msec)
 {
-	mod_timer(timer, jiffies + msecs_to_jiffies(msec) + 1);
+	mod_timer(timer, jiffies + msecs_to_jiffies_timeout(msec));
 }
 
 /**
-- 
1.7.10.4


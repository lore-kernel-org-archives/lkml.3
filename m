Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbbAGMmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:42:14 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45087 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbbAGMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:42:11 -0500
Date: Wed, 7 Jan 2015 14:41:45 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: jeffrey.t.kirsher@intel.com
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, matthew.vick@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com,
        linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] e1000: fix time comparison
Message-ID: <20150107124145.GA15954@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_after_eq() instead of plain, error-prone math.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index b691eb4..4270ad2 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -24,6 +24,7 @@
 /* ethtool support for e1000 */
 
 #include "e1000.h"
+#include <linux/jiffies.h>
 #include <linux/uaccess.h>
 
 enum {NETDEV_STATS, E1000_STATS};
@@ -1460,7 +1461,7 @@ static int e1000_run_loopback_test(struct e1000_adapter *adapter)
 			ret_val = 13; /* ret_val is the same as mis-compare */
 			break;
 		}
-		if (jiffies >= (time + 2)) {
+		if (time_after_eq(jiffies, time + 2)) {
 			ret_val = 14; /* error code for time out error */
 			break;
 		}
-- 
1.7.0.4


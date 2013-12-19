Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3LSMDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:03:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3LSMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sunil K Pandey <sunil.k.pandey@intel.com>,
        Kevin B Smith <kevin.b.smith@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 202/208] igb: Fix for issue where values could be too high for udelay function.
Date: Thu, 19 Dec 2013 11:55:00 +0000
Message-Id: <1387454106-19326-203-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

commit df29df92adda751ac04ca5149d30014b5199db81 upstream.

This patch changes the igb_phy_has_link function to check the value of the
parameter before deciding to use udelay or mdelay in order to be sure that
the value is not too high for udelay function.

Signed-off-by: Sunil K Pandey <sunil.k.pandey@intel.com>
Signed-off-by: Kevin B Smith <kevin.b.smith@intel.com>
Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/igb/e1000_phy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 6046194..4703d45 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -1719,7 +1719,10 @@ s32 igb_phy_has_link(struct e1000_hw *hw, u32 iterations,
 			 * ownership of the resources, wait and try again to
 			 * see if they have relinquished the resources yet.
 			 */
-			udelay(usec_interval);
+			if (usec_interval >= 1000)
+				mdelay(usec_interval/1000);
+			else
+				udelay(usec_interval);
 		}
 		ret_val = hw->phy.ops.read_reg(hw, PHY_STATUS, &phy_status);
 		if (ret_val)
-- 
1.8.3.2


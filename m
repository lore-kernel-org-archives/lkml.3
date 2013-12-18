Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3LRWCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:02:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3LRVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sunil K Pandey <sunil.k.pandey@intel.com>,
        Kevin B Smith <kevin.b.smith@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 44/78] igb: Fix for issue where values could be too high for udelay function.
Date: Wed, 18 Dec 2013 13:11:12 -0800
Message-Id: <20131218211113.149155028@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igb/e1000_phy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -1595,7 +1595,10 @@ s32 igb_phy_has_link(struct e1000_hw *hw
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



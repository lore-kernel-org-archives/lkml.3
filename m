Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3HQABR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:01:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab3HPWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 062/133] ixgbe: Fix Tx Hang issue with lldpad on 82598EB
Date: Fri, 16 Aug 2013 15:33:24 -0700
Message-Id: <1376692475-28413-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit 1eb9ac14c34a948bf1538bfb9034e8ab29099a64 upstream.

This patch fixes an issue with the 82598EB device, where lldpad is causing Tx
Hangs on the card as soon as it attempts to configure DCB for the device. The
adapter will continually Tx hang and reset in a loop.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
index 87592b4..b3c05de 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
@@ -108,9 +108,8 @@ s32 ixgbe_dcb_config_tx_desc_arbiter_82598(struct ixgbe_hw *hw,
 
 	/* Enable arbiter */
 	reg &= ~IXGBE_DPMCS_ARBDIS;
-	/* Enable DFP and Recycle mode */
-	reg |= (IXGBE_DPMCS_TDPAC | IXGBE_DPMCS_TRM);
 	reg |= IXGBE_DPMCS_TSOEF;
+
 	/* Configure Max TSO packet size 34KB including payload and headers */
 	reg |= (0x4 << IXGBE_DPMCS_MTSOS_SHIFT);
 
-- 
1.8.1.2


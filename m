Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab3IHDUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163Ab3IHDSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jack Morgan" <jack.morgan@intel.com>,
        "Jacob Keller" <jacob.e.keller@intel.com>,
        "Phil Schmitt" <phillip.j.schmitt@intel.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.455040633@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [042/121] ixgbe: Fix Tx Hang issue with lldpad on 82598EB
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
@@ -108,9 +108,8 @@ s32 ixgbe_dcb_config_tx_desc_arbiter_825
 
 	/* Enable arbiter */
 	reg &= ~IXGBE_DPMCS_ARBDIS;
-	/* Enable DFP and Recycle mode */
-	reg |= (IXGBE_DPMCS_TDPAC | IXGBE_DPMCS_TRM);
 	reg |= IXGBE_DPMCS_TSOEF;
+
 	/* Configure Max TSO packet size 34KB including payload and headers */
 	reg |= (0x4 << IXGBE_DPMCS_MTSOS_SHIFT);
 


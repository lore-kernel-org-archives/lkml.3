Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3IKFcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:32:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3IKE5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:21 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=CnqiH7jaiT4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=7wGFPgOgLBAA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=SlR5ukZpdpTeE1r3aJkA:9 a=dGJ0OcVc7YAA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042915.594403904@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jack Morgan <jack.morgan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [140/251] ixgbe: Fix Tx Hang issue with lldpad on 82598EB
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0140-ixgbe-Fix-Tx-Hang-issue-with-lldpad-on-82598EB.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 1eb9ac14c34a948bf1538bfb9034e8ab29099a64 ]

This patch fixes an issue with the 82598EB device, where lldpad is causing Tx
Hangs on the card as soon as it attempts to configure DCB for the device. The
adapter will continually Tx hang and reset in a loop.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Stable <stable@vger.kernel.org>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |    3 +--
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
1.7.10.4



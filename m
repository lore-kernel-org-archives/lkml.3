Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbbAVWxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:53:42 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:65517 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbbAVWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:53:40 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: fm10k: Actually drop 4 bits
Date: Thu, 22 Jan 2015 23:53:18 +0100
Message-Id: <1421967198-16667-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment explains the intention, but vid has type u16. Before the
inner shift, it is promoted to int, which has plenty of space for all
vid's bits, so nothing is dropped. Use a simple mask instead.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index 275423d4f777..b1c57d0166a9 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -335,7 +335,7 @@ static s32 fm10k_update_xc_addr_pf(struct fm10k_hw *hw, u16 glort,
 		return FM10K_ERR_PARAM;
 
 	/* drop upper 4 bits of VLAN ID */
-	vid = (vid << 4) >> 4;
+	vid &= 0x0fff;
 
 	/* record fields */
 	mac_update.mac_lower = cpu_to_le32(((u32)mac[2] << 24) |
-- 
2.1.3


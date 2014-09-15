Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaIOQXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:23:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48584 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaIOQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:23:50 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Joe Perches <joe@perches.com>
Subject: [PATCH] netdev: octeon_mgmt: Fix ISO C90 forbids mixed declarations and code warning.
Date: Mon, 15 Sep 2014 09:23:43 -0700
Message-Id: <1410798223-21420-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We were getting:

  drivers/net/ethernet/octeon/octeon_mgmt.c:295:4: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

The idea of the fix from Joe Perches.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Joe Perches <joe@perches.com>
---

This patch should supersede previous patches from Heinrich Schuchardt,
and may be preferable as it touches fewer lines of code.

 drivers/net/ethernet/octeon/octeon_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
index 979c698..5e10c1d 100644
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@ -290,12 +290,12 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
 		/* Read the hardware TX timestamp if one was recorded */
 		if (unlikely(re.s.tstamp)) {
 			struct skb_shared_hwtstamps ts;
-			memset(&ts, 0, sizeof(ts));
 			/* Read the timestamp */
 			u64 ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
 			/* Remove the timestamp from the FIFO */
 			cvmx_write_csr(CVMX_MIXX_TSCTL(p->port), 0);
 			/* Tell the kernel about the timestamp */
+			memset(&ts, 0, sizeof(ts));
 			ts.hwtstamp = ns_to_ktime(ns);
 			skb_tstamp_tx(skb, &ts);
 		}
-- 
1.7.11.7


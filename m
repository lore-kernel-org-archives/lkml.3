Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaINFCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:02:55 -0400
Received: from mout.gmx.net ([212.227.15.19]:61345 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaINFCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:02:54 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: David Daney <david.daney@cavium.com>
Cc: "David S. Miller" <davem@davemloft.net>, Luka Perkov <luka@openwrt.org>,
        Willem de Bruijn <willemb@google.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 1/1 v2] netdev: octeon_mgmt: ISO C90 forbids mixed declarations and code
Date: Sun, 14 Sep 2014 07:02:14 +0200
Message-Id: <1410670935-904-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:8enetx2LAq1/sM9bilqvAGxe5Jae6UJSvdMjp225uQLeX449rac
 TQ9i7SysLu4wLzRNSxCQHB7IyQ5AOCHDtp4AiU50pcN5TH2kzDcYr75G/6h30kbG3tYiCYC
 qU9r1+t8xXUsgLFhOvUJruOKj2hDPfoejOBm+df6w4OjqzUcvyI3YBzutQFTp2Z/Iu+/jDL
 QYntRV0vgZxzQ4ZcDRIWw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revised patch takes into account comments by Joe and David.

Compiling with OCTEON_MGMT_ETHERNET gives a warning
drivers/net/ethernet/octeon/octeon_mgmt.c:295:4:
warning: ISO C90 forbids mixed declarations and code
[-Wdeclaration-after-statement]

The patch cleans up the code.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
CC: Joe Perches <joe@perches.com>
CC: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/octeon/octeon_mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
index 979c698..6cc68b1 100644
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@ -290,9 +290,10 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
 		/* Read the hardware TX timestamp if one was recorded */
 		if (unlikely(re.s.tstamp)) {
 			struct skb_shared_hwtstamps ts;
+			u64 ns;
 			memset(&ts, 0, sizeof(ts));
 			/* Read the timestamp */
-			u64 ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
+			ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
 			/* Remove the timestamp from the FIFO */
 			cvmx_write_csr(CVMX_MIXX_TSCTL(p->port), 0);
 			/* Tell the kernel about the timestamp */
-- 
2.1.0


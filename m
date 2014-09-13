Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaIMTGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:06:11 -0400
Received: from mout.gmx.net ([212.227.15.19]:59612 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaIMTGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:06:09 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: David Daney <david.daney@cavium.com>
Cc: "David S. Miller" <davem@davemloft.net>, Luka Perkov <luka@openwrt.org>,
        Willem de Bruijn <willemb@google.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH] netdev: octeon_mgmt: ISO C90 forbids mixed declarations and code
Date: Sat, 13 Sep 2014 21:05:08 +0200
Message-Id: <1410635108-3589-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:xZWoMTFvSt0qayh8GwRsoygr1TUknsExR/ypdXBFVlAI2iYev6x
 eR4y5XYbtcWhc+XQJO+rFzKGZ1FmWdoJEVZfpV8KX5gajCtfv9oPi2n8eN0ZWHrgRWMjut4
 RoZTO4LcqXQYPES/G4GcJVwyVnbjwomxzqEg2YYuSzq3PawLHUIDHbN0U4BT9HzhtRo50vZ
 ciGrRVoFKhFJiJFcaOYnQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling with OCTEON_MGMT_ETHERNET gives a warning
drivers/net/ethernet/octeon/octeon_mgmt.c:295:4:
warning: ISO C90 forbids mixed declarations and code
[-Wdeclaration-after-statement]

The patch cleans up the code.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/ethernet/octeon/octeon_mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
index 979c698..8af453a 100644
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@ -254,6 +254,7 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
 	struct sk_buff *skb;
 	int cleaned = 0;
 	unsigned long flags;
+	u64 ns;
 
 	mix_orcnt.u64 = cvmx_read_csr(p->mix + MIX_ORCNT);
 	while (mix_orcnt.s.orcnt) {
@@ -292,7 +293,7 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
 			struct skb_shared_hwtstamps ts;
 			memset(&ts, 0, sizeof(ts));
 			/* Read the timestamp */
-			u64 ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
+			ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
 			/* Remove the timestamp from the FIFO */
 			cvmx_write_csr(CVMX_MIXX_TSCTL(p->port), 0);
 			/* Tell the kernel about the timestamp */
-- 
2.1.0


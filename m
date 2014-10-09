Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaJIOyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:54:55 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:21879 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaJIOyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:54:46 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, davem@davemloft.net
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: fs_enet: error: 'SCCE_ENET_TXF' undeclared
Message-Id: <20141009145443.74AD61AB275@localhost.localdomain>
Date: Thu,  9 Oct 2014 16:54:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-devel:devel-hourly-2014100909 3763/3915] drivers/net/ethernet/freescale/fs_enet/mac-scc.c:119:32: error: 'SCCE_ENET_TXF' undeclared

Due to patch d43a396 net: fs_enet: Add NAPI TX, it appears that some target
compilations are broken.
This is due to the fact that unlike the FEC, the SCC and FCC don't have a TXF
event (complete Frame transmitted) but only TXB (buffer transmitted).

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c | 2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
index 2c578db..08f5b91 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -125,7 +125,7 @@ out:
 }
 
 #define FCC_NAPI_RX_EVENT_MSK	(FCC_ENET_RXF | FCC_ENET_RXB)
-#define FCC_NAPI_TX_EVENT_MSK	(FCC_ENET_TXF | FCC_ENET_TXB)
+#define FCC_NAPI_TX_EVENT_MSK	(FCC_ENET_TXB)
 #define FCC_RX_EVENT		(FCC_ENET_RXF)
 #define FCC_TX_EVENT		(FCC_ENET_TXB)
 #define FCC_ERR_EVENT_MSK	(FCC_ENET_TXE)
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
index 5b592a6..90c9652 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
@@ -117,7 +117,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 }
 
 #define SCC_NAPI_RX_EVENT_MSK	(SCCE_ENET_RXF | SCCE_ENET_RXB)
-#define SCC_NAPI_TX_EVENT_MSK	(SCCE_ENET_TXF | SCCE_ENET_TXB)
+#define SCC_NAPI_TX_EVENT_MSK	(SCCE_ENET_TXB)
 #define SCC_RX_EVENT		(SCCE_ENET_RXF)
 #define SCC_TX_EVENT		(SCCE_ENET_TXB)
 #define SCC_ERR_EVENT_MSK	(SCCE_ENET_TXE | SCCE_ENET_BSY)
-- 
2.1.0


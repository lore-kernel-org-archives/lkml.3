Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaFWIkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55598 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/111] sh_eth: fix SH7619/771x support
Date: Mon, 23 Jun 2014 10:32:16 +0200
Message-Id: <b4e3e36a7e566927dfdc62b36c9c75b8c4b0c30a.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit d8b0426af5b67973585712c9af36b86f6ea97815 ]

Commit 4a55530f38e4 (net: sh_eth: modify the definitions of register) managed
to leave out the E-DMAC register entries in sh_eth_offset_fast_sh3_sh2[], thus
totally breaking SH7619/771x support.  Add the missing entries using  the data
from before that commit.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/renesas/sh_eth.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 53c6b2d555db..36119b3303d7 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -247,6 +247,27 @@ static const u16 sh_eth_offset_fast_sh4[SH_ETH_MAX_REGISTER_OFFSET] = {
 };
 
 static const u16 sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
+	[EDMR]		= 0x0000,
+	[EDTRR]		= 0x0004,
+	[EDRRR]		= 0x0008,
+	[TDLAR]		= 0x000c,
+	[RDLAR]		= 0x0010,
+	[EESR]		= 0x0014,
+	[EESIPR]	= 0x0018,
+	[TRSCER]	= 0x001c,
+	[RMFCR]		= 0x0020,
+	[TFTR]		= 0x0024,
+	[FDR]		= 0x0028,
+	[RMCR]		= 0x002c,
+	[EDOCR]		= 0x0030,
+	[FCFTR]		= 0x0034,
+	[RPADIR]	= 0x0038,
+	[TRIMD]		= 0x003c,
+	[RBWAR]		= 0x0040,
+	[RDFAR]		= 0x0044,
+	[TBRAR]		= 0x004c,
+	[TDFAR]		= 0x0050,
+
 	[ECMR]		= 0x0160,
 	[ECSR]		= 0x0164,
 	[ECSIPR]	= 0x0168,
-- 
2.0.0


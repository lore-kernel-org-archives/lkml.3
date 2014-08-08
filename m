Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaHHUv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:51:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbaHHUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 216/259] sh_eth: fix SH7619/771x support
Date: Fri,  8 Aug 2014 13:40:39 -0700
Message-Id: <1407530482-4483-217-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit d8b0426af5b67973585712c9af36b86f6ea97815 ]

Commit 4a55530f38e4 (net: sh_eth: modify the definitions of register) managed
to leave out the E-DMAC register entries in sh_eth_offset_fast_sh3_sh2[], thus
totally breaking SH7619/771x support.  Add the missing entries using  the data
from before that commit.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index dc19d37..8d002f1 100644
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
1.9.1


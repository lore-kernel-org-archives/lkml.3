Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaFDJc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:32:59 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:26220
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751633AbaFDJc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:32:57 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <claudiu.manoil@freescale.com>, <davem@davemloft.net>,
        <jingchang.lu@freescale.com>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] gianfar: Fix the section mismatch warnings.
Date: Wed, 4 Jun 2014 16:49:16 +0800
Message-ID: <1401871756-29231-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(80022001)(84676001)(88136002)(97736001)(74662001)(77156001)(79102001)(81542001)(47776003)(83322001)(6806004)(93916002)(83072002)(85852003)(19580395003)(87936001)(19580405001)(92566001)(81342001)(2201001)(62966002)(77096999)(50986999)(31966008)(46102001)(76482001)(89996001)(20776003)(92726001)(74502001)(102836001)(104166001)(50466002)(26826002)(68736004)(50226001)(44976005)(36756003)(86362001)(48376002)(64706001)(4396001)(104016001)(77982001)(87286001)(21056001)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB503;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0232B30BBC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with CONFIG_DEBUG_SECTION_MISMATCH enabled, the following
WARNING is occured:

  LD      drivers/net/built-in.o
WARNING: drivers/net/built-in.o(.text+0xcd4c): Section mismatch in
reference from the function gfar_probe() to the function
.init.text:gfar_init_addr_hash_table()
The function gfar_probe() references
the function __init gfar_init_addr_hash_table().
This is often because gfar_probe lacks a __init
annotation or the annotation of gfar_init_addr_hash_table is wrong.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index a7fe6a7..1fde3e6 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1242,7 +1242,7 @@ static void gfar_hw_init(struct gfar_private *priv)
 		gfar_write_isrg(priv);
 }
 
-static void __init gfar_init_addr_hash_table(struct gfar_private *priv)
+static void gfar_init_addr_hash_table(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
 
-- 
1.8.5


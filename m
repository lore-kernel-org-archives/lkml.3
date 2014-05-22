Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaEVPLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:11:09 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:49629
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741AbaEVPLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:11:05 -0400
From: Horia Geanta <horia.geanta@freescale.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Lei Xu <Lei.Xu@freescale.com>, Sandeep Malik <Sandeep.Malik@freescale.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC ipsec-next] xfrm: make sha256 icv truncation length RFC-compliant
Date: Thu, 22 May 2014 18:10:37 +0300
Message-ID: <1400771437-14096-2-git-send-email-horia.geanta@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400771437-14096-1-git-send-email-horia.geanta@freescale.com>
References: <1400771437-14096-1-git-send-email-horia.geanta@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(87936001)(93916002)(92566001)(77982001)(102836001)(6806004)(50466002)(76482001)(88136002)(89996001)(92726001)(86362001)(36756003)(81342001)(46102001)(83072002)(87286001)(99396002)(85852003)(50986999)(81542001)(26826002)(80022001)(62966002)(33646001)(50226001)(64706001)(31966008)(47776003)(74662001)(48376002)(74502001)(83322001)(76176999)(20776003)(19580405001)(44976005)(4396001)(19580395003)(77156001)(77096999)(79102001)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB491;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 021975AE46
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lei Xu <Lei.Xu@freescale.com>

Currently the sha256 icv truncation length is set to 96bit
while the length is defined as 128bit in RFC4868.
This may result in somer errors when working with other IPsec devices
with the standard truncation length.
Thus, change the sha256 truncation length from 96bit to 128bit.

Signed-off-by: Lei Xu <Lei.Xu@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 net/xfrm/xfrm_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index debe733386f8..ca21ba7a0716 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -220,7 +220,7 @@ static struct xfrm_algo_desc aalg_list[] = {
 
 	.uinfo = {
 		.auth = {
-			.icv_truncbits = 96,
+			.icv_truncbits = 128,
 			.icv_fullbits = 256,
 		}
 	},
-- 
1.8.3.1


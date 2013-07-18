Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3GRQKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:10:54 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:54710
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab3GRQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:10:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.hengli.com.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <horia.geanta@freescale.com>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: remove double execution of the same test suite
Date: Thu, 18 Jul 2013 18:57:07 +0300
Message-ID: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes redundant execution of the same test suite in cases
where alg and driver variables are the same (e.g. when alg_test is
called from tcrypt_test)

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2f00607..e091ef6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3234,7 +3234,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (i >= 0)
 		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
 					     type, mask);
-	if (j >= 0)
+	if (j >= 0 && j != i)
 		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
 					     type, mask);
 
-- 
1.8.1.5



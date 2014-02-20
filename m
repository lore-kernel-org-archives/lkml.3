Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaBTB4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:56:05 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56372 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbaBTB4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:56:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-FB-SS: 0,
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <broonie@linaro.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH Resend] regmap: fix _regmap_update_bits()
Date: Thu, 20 Feb 2014 08:50:10 +0800
Message-ID: <1392857410-9068-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sometimes the 'config' parameter has no use, it should be NULL.
And make the code simplifier.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

This resend version just rewrites the commit comment.


 drivers/base/regmap/regmap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6a19515..099522b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1966,9 +1966,11 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 
 	if (tmp != orig) {
 		ret = _regmap_write(map, reg, tmp);
-		*change = true;
+		if (change)
+			*change = true;
 	} else {
-		*change = false;
+		if (change)
+			*change = false;
 	}
 
 	return ret;
@@ -1987,11 +1989,10 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
-	bool change;
 	int ret;
 
 	map->lock(map->lock_arg);
-	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	ret = _regmap_update_bits(map, reg, mask, val, NULL);
 	map->unlock(map->lock_arg);
 
 	return ret;
@@ -2016,14 +2017,13 @@ EXPORT_SYMBOL_GPL(regmap_update_bits);
 int regmap_update_bits_async(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val)
 {
-	bool change;
 	int ret;
 
 	map->lock(map->lock_arg);
 
 	map->async = true;
 
-	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	ret = _regmap_update_bits(map, reg, mask, val, NULL);
 
 	map->async = false;
 
-- 
1.8.4



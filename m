Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbaHHL2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:28:36 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:43980
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756008AbaHHL2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:28:34 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 1/3] crypto: testmgr.c: white space removal on __test_hash
Date: Fri, 8 Aug 2014 14:27:50 +0300
Message-ID: <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <53E496E4.9070207@freescale.com>
References: <53E496E4.9070207@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(33646002)(79102001)(80022001)(104166001)(97736001)(74502001)(4396001)(229853001)(107046002)(102836001)(74662001)(20776003)(47776003)(68736004)(84676001)(26826002)(93916002)(77156001)(81342001)(81542001)(46102001)(77982001)(50226001)(31966008)(6806004)(85852003)(87936001)(83322001)(44976005)(88136002)(89996001)(87286001)(85306004)(19580395003)(83072002)(19580405001)(76176999)(48376002)(62966002)(95666004)(105606002)(76482001)(106466001)(92566001)(36756003)(86362001)(64706001)(99396002)(21056001)(92726001)(104016003)(50986999)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0616;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inverts one if condition to remove code block indentation.
Several white space clean-ups follow.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 123 +++++++++++++++++++++++++++----------------------------
 1 file changed, 60 insertions(+), 63 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ca70ae8..51f47f2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -305,78 +305,75 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		if (align_offset != 0)
 			break;
 
-		if (template[i].np) {
-			j++;
-			memset(result, 0, MAX_DIGEST_SIZE);
+		if (!template[i].np)
+			continue;
 
-			temp = 0;
-			sg_init_table(sg, template[i].np);
-			ret = -EINVAL;
-			for (k = 0; k < template[i].np; k++) {
-				if (WARN_ON(offset_in_page(IDX[k]) +
-					    template[i].tap[k] > PAGE_SIZE))
-					goto out;
-				sg_set_buf(&sg[k],
-					   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
-						  offset_in_page(IDX[k]),
-						  template[i].plaintext + temp,
-						  template[i].tap[k]),
-					   template[i].tap[k]);
-				temp += template[i].tap[k];
-			}
+		j++;
+		memset(result, 0, MAX_DIGEST_SIZE);
 
-			if (template[i].ksize) {
-				if (template[i].ksize > MAX_KEYLEN) {
-					pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
-					       j, algo, template[i].ksize,
-					       MAX_KEYLEN);
-					ret = -EINVAL;
-					goto out;
-				}
-				crypto_ahash_clear_flags(tfm, ~0);
-				memcpy(key, template[i].key, template[i].ksize);
-				ret = crypto_ahash_setkey(tfm, key,
-							  template[i].ksize);
+		temp = 0;
+		sg_init_table(sg, template[i].np);
+		ret = -EINVAL;
+		for (k = 0; k < template[i].np; k++) {
+			if (WARN_ON(offset_in_page(IDX[k]) +
+				    template[i].tap[k] > PAGE_SIZE))
+				goto out;
+			sg_set_buf(&sg[k],
+				   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
+					  offset_in_page(IDX[k]),
+					  template[i].plaintext + temp,
+					  template[i].tap[k]),
+				   template[i].tap[k]);
+			temp += template[i].tap[k];
+		}
 
-				if (ret) {
-					printk(KERN_ERR "alg: hash: setkey "
-					       "failed on chunking test %d "
-					       "for %s: ret=%d\n", j, algo,
-					       -ret);
-					goto out;
-				}
+		if (template[i].ksize) {
+			if (template[i].ksize > MAX_KEYLEN) {
+				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
+				       j, algo, template[i].ksize, MAX_KEYLEN);
+				ret = -EINVAL;
+				goto out;
 			}
+			crypto_ahash_clear_flags(tfm, ~0);
+			memcpy(key, template[i].key, template[i].ksize);
+			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
 
-			ahash_request_set_crypt(req, sg, result,
-						template[i].psize);
-			ret = crypto_ahash_digest(req);
-			switch (ret) {
-			case 0:
-				break;
-			case -EINPROGRESS:
-			case -EBUSY:
-				ret = wait_for_completion_interruptible(
-					&tresult.completion);
-				if (!ret && !(ret = tresult.err)) {
-					reinit_completion(&tresult.completion);
-					break;
-				}
-				/* fall through */
-			default:
-				printk(KERN_ERR "alg: hash: digest failed "
-				       "on chunking test %d for %s: "
-				       "ret=%d\n", j, algo, -ret);
+			if (ret) {
+				printk(KERN_ERR "alg: hash: setkey "
+				       "failed on chunking test %d "
+				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
+		}
 
-			if (memcmp(result, template[i].digest,
-				   crypto_ahash_digestsize(tfm))) {
-				printk(KERN_ERR "alg: hash: Chunking test %d "
-				       "failed for %s\n", j, algo);
-				hexdump(result, crypto_ahash_digestsize(tfm));
-				ret = -EINVAL;
-				goto out;
+		ahash_request_set_crypt(req, sg, result, template[i].psize);
+		ret = crypto_ahash_digest(req);
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&tresult.completion);
+			if (!ret && !(ret = tresult.err)) {
+				reinit_completion(&tresult.completion);
+				break;
 			}
+			/* fall through */
+		default:
+			printk(KERN_ERR "alg: hash: digest failed "
+			       "on chunking test %d for %s: "
+			       "ret=%d\n", j, algo, -ret);
+			goto out;
+		}
+
+		if (memcmp(result, template[i].digest,
+			   crypto_ahash_digestsize(tfm))) {
+			printk(KERN_ERR "alg: hash: Chunking test %d "
+			       "failed for %s\n", j, algo);
+			hexdump(result, crypto_ahash_digestsize(tfm));
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
-- 
1.8.3.1


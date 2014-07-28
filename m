Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaG1KMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:12:42 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:18349
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751586AbaG1KMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:12:39 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Cristian Stoica" <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: testmgr.c: white space fix-ups on test_aead
Date: Mon, 28 Jul 2014 13:11:23 +0300
Message-ID: <1406542283-11995-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(74662001)(46102001)(102836001)(31966008)(33646002)(26826002)(21056001)(74502001)(104166001)(85852003)(83072002)(93916002)(81342001)(87936001)(50986999)(86362001)(19580405001)(19580395003)(99396002)(88136002)(83322001)(84676001)(50226001)(44976005)(68736004)(4396001)(81542001)(87286001)(92726001)(104016003)(36756003)(77982001)(95666004)(229853001)(107046002)(20776003)(47776003)(62966002)(77156001)(48376002)(85306003)(97736001)(79102001)(106466001)(89996001)(92566001)(50466002)(6806004)(105606002)(76482001)(64706001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0618;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inverts two if conditions and allows removal of one
tab-stop in their code-blocks. Only white-space clean-up follows.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 498 +++++++++++++++++++++++++++----------------------------
 1 file changed, 242 insertions(+), 256 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 81818b9..0f3883d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -492,121 +492,116 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				  tcrypt_complete, &result);
 
 	for (i = 0, j = 0; i < tcount; i++) {
-		if (!template[i].np) {
-			j++;
+		if (template[i].np)
+			continue;
 
-			/* some templates have no input data but they will
-			 * touch input
-			 */
-			input = xbuf[0];
-			input += align_offset;
-			assoc = axbuf[0];
+		j++;
 
-			ret = -EINVAL;
-			if (WARN_ON(align_offset + template[i].ilen >
-				    PAGE_SIZE || template[i].alen > PAGE_SIZE))
-				goto out;
+		/* some templates have no input data but they will
+		 * touch input
+		 */
+		input = xbuf[0];
+		input += align_offset;
+		assoc = axbuf[0];
 
-			memcpy(input, template[i].input, template[i].ilen);
-			memcpy(assoc, template[i].assoc, template[i].alen);
-			if (template[i].iv)
-				memcpy(iv, template[i].iv, MAX_IVLEN);
-			else
-				memset(iv, 0, MAX_IVLEN);
+		ret = -EINVAL;
+		if (WARN_ON(align_offset + template[i].ilen >
+			    PAGE_SIZE || template[i].alen > PAGE_SIZE))
+			goto out;
 
-			crypto_aead_clear_flags(tfm, ~0);
-			if (template[i].wk)
-				crypto_aead_set_flags(
-					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+		memcpy(input, template[i].input, template[i].ilen);
+		memcpy(assoc, template[i].assoc, template[i].alen);
+		if (template[i].iv)
+			memcpy(iv, template[i].iv, MAX_IVLEN);
+		else
+			memset(iv, 0, MAX_IVLEN);
 
-			if (template[i].klen > MAX_KEYLEN) {
-				pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
-				       d, j, algo, template[i].klen,
-				       MAX_KEYLEN);
-				ret = -EINVAL;
-				goto out;
-			}
-			memcpy(key, template[i].key, template[i].klen);
+		crypto_aead_clear_flags(tfm, ~0);
+		if (template[i].wk)
+			crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			ret = crypto_aead_setkey(tfm, key,
-						 template[i].klen);
-			if (!ret == template[i].fail) {
-				pr_err("alg: aead%s: setkey failed on test %d for %s: flags=%x\n",
-				       d, j, algo, crypto_aead_get_flags(tfm));
-				goto out;
-			} else if (ret)
-				continue;
+		if (template[i].klen > MAX_KEYLEN) {
+			pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
+			       d, j, algo, template[i].klen,
+			       MAX_KEYLEN);
+			ret = -EINVAL;
+			goto out;
+		}
+		memcpy(key, template[i].key, template[i].klen);
 
-			authsize = abs(template[i].rlen - template[i].ilen);
-			ret = crypto_aead_setauthsize(tfm, authsize);
-			if (ret) {
-				pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
-				       d, authsize, j, algo);
-				goto out;
-			}
+		ret = crypto_aead_setkey(tfm, key, template[i].klen);
+		if (!ret == template[i].fail) {
+			pr_err("alg: aead%s: setkey failed on test %d for %s: flags=%x\n",
+			       d, j, algo, crypto_aead_get_flags(tfm));
+			goto out;
+		} else if (ret)
+			continue;
 
-			if (diff_dst) {
-				output = xoutbuf[0];
-				output += align_offset;
-				sg_init_one(&sg[0], input, template[i].ilen);
-				sg_init_one(&sgout[0], output,
-					    template[i].rlen);
-			} else {
-				sg_init_one(&sg[0], input,
-					    template[i].ilen +
-						(enc ? authsize : 0));
-				output = input;
-			}
+		authsize = abs(template[i].rlen - template[i].ilen);
+		ret = crypto_aead_setauthsize(tfm, authsize);
+		if (ret) {
+			pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
+			       d, authsize, j, algo);
+			goto out;
+		}
 
-			sg_init_one(&asg[0], assoc, template[i].alen);
+		if (diff_dst) {
+			output = xoutbuf[0];
+			output += align_offset;
+			sg_init_one(&sg[0], input, template[i].ilen);
+			sg_init_one(&sgout[0], output, template[i].rlen);
+		} else {
+			sg_init_one(&sg[0], input,
+				    template[i].ilen + (enc ? authsize : 0));
+			output = input;
+		}
 
-			aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-					       template[i].ilen, iv);
+		sg_init_one(&asg[0], assoc, template[i].alen);
 
-			aead_request_set_assoc(req, asg, template[i].alen);
+		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
+				       template[i].ilen, iv);
 
-			ret = enc ?
-				crypto_aead_encrypt(req) :
-				crypto_aead_decrypt(req);
+		aead_request_set_assoc(req, asg, template[i].alen);
 
-			switch (ret) {
-			case 0:
-				if (template[i].novrfy) {
-					/* verification was supposed to fail */
-					pr_err("alg: aead%s: %s failed on test %d for %s: ret was 0, expected -EBADMSG\n",
-					       d, e, j, algo);
-					/* so really, we got a bad message */
-					ret = -EBADMSG;
-					goto out;
-				}
-				break;
-			case -EINPROGRESS:
-			case -EBUSY:
-				ret = wait_for_completion_interruptible(
-					&result.completion);
-				if (!ret && !(ret = result.err)) {
-					reinit_completion(&result.completion);
-					break;
-				}
-			case -EBADMSG:
-				if (template[i].novrfy)
-					/* verification failure was expected */
-					continue;
-				/* fall through */
-			default:
-				pr_err("alg: aead%s: %s failed on test %d for %s: ret=%d\n",
-				       d, e, j, algo, -ret);
-				goto out;
-			}
+		ret = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
 
-			q = output;
-			if (memcmp(q, template[i].result, template[i].rlen)) {
-				pr_err("alg: aead%s: Test %d failed on %s for %s\n",
-				       d, j, e, algo);
-				hexdump(q, template[i].rlen);
-				ret = -EINVAL;
+		switch (ret) {
+		case 0:
+			if (template[i].novrfy) {
+				/* verification was supposed to fail */
+				pr_err("alg: aead%s: %s failed on test %d for %s: ret was 0, expected -EBADMSG\n",
+				       d, e, j, algo);
+				/* so really, we got a bad message */
+				ret = -EBADMSG;
 				goto out;
 			}
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&result.completion);
+			if (!ret && !(ret = result.err)) {
+				reinit_completion(&result.completion);
+				break;
+			}
+		case -EBADMSG:
+			if (template[i].novrfy)
+				/* verification failure was expected */
+				continue;
+			/* fall through */
+		default:
+			pr_err("alg: aead%s: %s failed on test %d for %s: ret=%d\n",
+			       d, e, j, algo, -ret);
+			goto out;
+		}
+
+		q = output;
+		if (memcmp(q, template[i].result, template[i].rlen)) {
+			pr_err("alg: aead%s: Test %d failed on %s for %s\n",
+			       d, j, e, algo);
+			hexdump(q, template[i].rlen);
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -615,191 +610,182 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		if (align_offset != 0)
 			break;
 
-		if (template[i].np) {
-			j++;
+		if (!template[i].np)
+			continue;
 
-			if (template[i].iv)
-				memcpy(iv, template[i].iv, MAX_IVLEN);
-			else
-				memset(iv, 0, MAX_IVLEN);
+		j++;
 
-			crypto_aead_clear_flags(tfm, ~0);
-			if (template[i].wk)
-				crypto_aead_set_flags(
-					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-			if (template[i].klen > MAX_KEYLEN) {
-				pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
-				       d, j, algo, template[i].klen,
-				       MAX_KEYLEN);
-				ret = -EINVAL;
-				goto out;
-			}
-			memcpy(key, template[i].key, template[i].klen);
+		if (template[i].iv)
+			memcpy(iv, template[i].iv, MAX_IVLEN);
+		else
+			memset(iv, 0, MAX_IVLEN);
 
-			ret = crypto_aead_setkey(tfm, key, template[i].klen);
-			if (!ret == template[i].fail) {
-				pr_err("alg: aead%s: setkey failed on chunk test %d for %s: flags=%x\n",
-				       d, j, algo, crypto_aead_get_flags(tfm));
-				goto out;
-			} else if (ret)
-				continue;
+		crypto_aead_clear_flags(tfm, ~0);
+		if (template[i].wk)
+			crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+		if (template[i].klen > MAX_KEYLEN) {
+			pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
+			       d, j, algo, template[i].klen, MAX_KEYLEN);
+			ret = -EINVAL;
+			goto out;
+		}
+		memcpy(key, template[i].key, template[i].klen);
 
-			authsize = abs(template[i].rlen - template[i].ilen);
+		ret = crypto_aead_setkey(tfm, key, template[i].klen);
+		if (!ret == template[i].fail) {
+			pr_err("alg: aead%s: setkey failed on chunk test %d for %s: flags=%x\n",
+			       d, j, algo, crypto_aead_get_flags(tfm));
+			goto out;
+		} else if (ret)
+			continue;
 
-			ret = -EINVAL;
-			sg_init_table(sg, template[i].np);
-			if (diff_dst)
-				sg_init_table(sgout, template[i].np);
-			for (k = 0, temp = 0; k < template[i].np; k++) {
-				if (WARN_ON(offset_in_page(IDX[k]) +
-					    template[i].tap[k] > PAGE_SIZE))
-					goto out;
+		authsize = abs(template[i].rlen - template[i].ilen);
 
-				q = xbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
+		ret = -EINVAL;
+		sg_init_table(sg, template[i].np);
+		if (diff_dst)
+			sg_init_table(sgout, template[i].np);
+		for (k = 0, temp = 0; k < template[i].np; k++) {
+			if (WARN_ON(offset_in_page(IDX[k]) +
+				    template[i].tap[k] > PAGE_SIZE))
+				goto out;
 
-				memcpy(q, template[i].input + temp,
-				       template[i].tap[k]);
+			q = xbuf[IDX[k] >> PAGE_SHIFT] + offset_in_page(IDX[k]);
+			memcpy(q, template[i].input + temp, template[i].tap[k]);
+			sg_set_buf(&sg[k], q, template[i].tap[k]);
 
-				sg_set_buf(&sg[k], q, template[i].tap[k]);
+			if (diff_dst) {
+				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
 
-				if (diff_dst) {
-					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-					    offset_in_page(IDX[k]);
+				memset(q, 0, template[i].tap[k]);
 
-					memset(q, 0, template[i].tap[k]);
+				sg_set_buf(&sgout[k], q, template[i].tap[k]);
+			}
 
-					sg_set_buf(&sgout[k], q,
-						   template[i].tap[k]);
-				}
+			n = template[i].tap[k];
+			if (k == template[i].np - 1 && enc)
+				n += authsize;
+			if (offset_in_page(q) + n < PAGE_SIZE)
+				q[n] = 0;
 
-				n = template[i].tap[k];
-				if (k == template[i].np - 1 && enc)
-					n += authsize;
-				if (offset_in_page(q) + n < PAGE_SIZE)
-					q[n] = 0;
+			temp += template[i].tap[k];
+		}
 
-				temp += template[i].tap[k];
-			}
+		ret = crypto_aead_setauthsize(tfm, authsize);
+		if (ret) {
+			pr_err("alg: aead%s: Failed to set authsize to %u on chunk test %d for %s\n",
+			       d, authsize, j, algo);
+			goto out;
+		}
 
-			ret = crypto_aead_setauthsize(tfm, authsize);
-			if (ret) {
-				pr_err("alg: aead%s: Failed to set authsize to %u on chunk test %d for %s\n",
-				       d, authsize, j, algo);
+		if (enc) {
+			if (WARN_ON(sg[k - 1].offset +
+				    sg[k - 1].length + authsize >
+				    PAGE_SIZE)) {
+				ret = -EINVAL;
 				goto out;
 			}
 
-			if (enc) {
-				if (WARN_ON(sg[k - 1].offset +
-					    sg[k - 1].length + authsize >
-					    PAGE_SIZE)) {
-					ret = -EINVAL;
-					goto out;
-				}
+			if (diff_dst)
+				sgout[k - 1].length += authsize;
+			else
+				sg[k - 1].length += authsize;
+		}
 
-				if (diff_dst)
-					sgout[k - 1].length += authsize;
-				else
-					sg[k - 1].length += authsize;
+		sg_init_table(asg, template[i].anp);
+		ret = -EINVAL;
+		for (k = 0, temp = 0; k < template[i].anp; k++) {
+			if (WARN_ON(offset_in_page(IDX[k]) +
+				    template[i].atap[k] > PAGE_SIZE))
+				goto out;
+			sg_set_buf(&asg[k],
+				   memcpy(axbuf[IDX[k] >> PAGE_SHIFT] +
+					  offset_in_page(IDX[k]),
+					  template[i].assoc + temp,
+					  template[i].atap[k]),
+				   template[i].atap[k]);
+			temp += template[i].atap[k];
+		}
+
+		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
+				       template[i].ilen,
+				       iv);
+
+		aead_request_set_assoc(req, asg, template[i].alen);
+
+		ret = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+
+		switch (ret) {
+		case 0:
+			if (template[i].novrfy) {
+				/* verification was supposed to fail */
+				pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret was 0, expected -EBADMSG\n",
+				       d, e, j, algo);
+				/* so really, we got a bad message */
+				ret = -EBADMSG;
+				goto out;
 			}
-
-			sg_init_table(asg, template[i].anp);
-			ret = -EINVAL;
-			for (k = 0, temp = 0; k < template[i].anp; k++) {
-				if (WARN_ON(offset_in_page(IDX[k]) +
-					    template[i].atap[k] > PAGE_SIZE))
-					goto out;
-				sg_set_buf(&asg[k],
-					   memcpy(axbuf[IDX[k] >> PAGE_SHIFT] +
-						  offset_in_page(IDX[k]),
-						  template[i].assoc + temp,
-						  template[i].atap[k]),
-					   template[i].atap[k]);
-				temp += template[i].atap[k];
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&result.completion);
+			if (!ret && !(ret = result.err)) {
+				reinit_completion(&result.completion);
+				break;
 			}
+		case -EBADMSG:
+			if (template[i].novrfy)
+				/* verification failure was expected */
+				continue;
+			/* fall through */
+		default:
+			pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret=%d\n",
+			       d, e, j, algo, -ret);
+			goto out;
+		}
 
-			aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-					       template[i].ilen,
-					       iv);
-
-			aead_request_set_assoc(req, asg, template[i].alen);
+		ret = -EINVAL;
+		for (k = 0, temp = 0; k < template[i].np; k++) {
+			if (diff_dst)
+				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
+			else
+				q = xbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
 
-			ret = enc ?
-				crypto_aead_encrypt(req) :
-				crypto_aead_decrypt(req);
+			n = template[i].tap[k];
+			if (k == template[i].np - 1)
+				n += enc ? authsize : -authsize;
 
-			switch (ret) {
-			case 0:
-				if (template[i].novrfy) {
-					/* verification was supposed to fail */
-					pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret was 0, expected -EBADMSG\n",
-					       d, e, j, algo);
-					/* so really, we got a bad message */
-					ret = -EBADMSG;
-					goto out;
-				}
-				break;
-			case -EINPROGRESS:
-			case -EBUSY:
-				ret = wait_for_completion_interruptible(
-					&result.completion);
-				if (!ret && !(ret = result.err)) {
-					reinit_completion(&result.completion);
-					break;
-				}
-			case -EBADMSG:
-				if (template[i].novrfy)
-					/* verification failure was expected */
-					continue;
-				/* fall through */
-			default:
-				pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret=%d\n",
-				       d, e, j, algo, -ret);
+			if (memcmp(q, template[i].result + temp, n)) {
+				pr_err("alg: aead%s: Chunk test %d failed on %s at page %u for %s\n",
+				       d, j, e, k, algo);
+				hexdump(q, n);
 				goto out;
 			}
 
-			ret = -EINVAL;
-			for (k = 0, temp = 0; k < template[i].np; k++) {
-				if (diff_dst)
-					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-					    offset_in_page(IDX[k]);
+			q += n;
+			if (k == template[i].np - 1 && !enc) {
+				if (!diff_dst &&
+					memcmp(q, template[i].input +
+					      temp + n, authsize))
+					n = authsize;
 				else
-					q = xbuf[IDX[k] >> PAGE_SHIFT] +
-					    offset_in_page(IDX[k]);
-
-				n = template[i].tap[k];
-				if (k == template[i].np - 1)
-					n += enc ? authsize : -authsize;
-
-				if (memcmp(q, template[i].result + temp, n)) {
-					pr_err("alg: aead%s: Chunk test %d failed on %s at page %u for %s\n",
-					       d, j, e, k, algo);
-					hexdump(q, n);
-					goto out;
-				}
-
-				q += n;
-				if (k == template[i].np - 1 && !enc) {
-					if (!diff_dst &&
-						memcmp(q, template[i].input +
-						      temp + n, authsize))
-						n = authsize;
-					else
-						n = 0;
-				} else {
-					for (n = 0; offset_in_page(q + n) &&
-						    q[n]; n++)
-						;
-				}
-				if (n) {
-					pr_err("alg: aead%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
-					       d, j, e, k, algo, n);
-					hexdump(q, n);
-					goto out;
-				}
-
-				temp += template[i].tap[k];
+					n = 0;
+			} else {
+				for (n = 0; offset_in_page(q + n) && q[n]; n++)
+					;
 			}
+			if (n) {
+				pr_err("alg: aead%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
+				       d, j, e, k, algo, n);
+				hexdump(q, n);
+				goto out;
+			}
+
+			temp += template[i].tap[k];
 		}
 	}
 
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3LJQix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:38:53 -0500
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:50062
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962Ab3LJQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:45 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MXLNF3-07-EIB-02
X-M-MSG: 
Subject: [PATCH 1/3] crypto: ccp - Fix sparse warnings in ccp-crypto-sha.c
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 10:38:33 -0600
Message-ID: <20131210163833.24304.95555.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sha initialization data generated the following sparse warnings:

   sparse: incorrect type in initializer (different base types)
      expected unsigned int
      got restricted __be32 [usertype] <noident>

Change the initialization data type from u32 to __be32.


Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c |    8 ++++----
 drivers/crypto/ccp/ccp-crypto.h     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index a6ef183..b0881df 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -324,20 +324,20 @@ static void ccp_hmac_sha_cra_exit(struct crypto_tfm *tfm)
 	ccp_sha_cra_exit(tfm);
 }
 
-static const u32 sha1_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
+static const __be32 sha1_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
 	cpu_to_be32(SHA1_H2), cpu_to_be32(SHA1_H3),
 	cpu_to_be32(SHA1_H4), 0, 0, 0,
 };
 
-static const u32 sha224_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
+static const __be32 sha224_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA224_H0), cpu_to_be32(SHA224_H1),
 	cpu_to_be32(SHA224_H2), cpu_to_be32(SHA224_H3),
 	cpu_to_be32(SHA224_H4), cpu_to_be32(SHA224_H5),
 	cpu_to_be32(SHA224_H6), cpu_to_be32(SHA224_H7),
 };
 
-static const u32 sha256_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
+static const __be32 sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA256_H0), cpu_to_be32(SHA256_H1),
 	cpu_to_be32(SHA256_H2), cpu_to_be32(SHA256_H3),
 	cpu_to_be32(SHA256_H4), cpu_to_be32(SHA256_H5),
@@ -347,7 +347,7 @@ static const u32 sha256_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
 struct ccp_sha_def {
 	const char *name;
 	const char *drv_name;
-	const u32 *init;
+	const __be32 *init;
 	enum ccp_sha_type type;
 	u32 digest_size;
 	u32 block_size;
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 45f17c3..13ea6ea 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -39,7 +39,7 @@ struct ccp_crypto_ablkcipher_alg {
 struct ccp_crypto_ahash_alg {
 	struct list_head entry;
 
-	const u32 *init;
+	const __be32 *init;
 	u32 type;
 	u32 mode;
 



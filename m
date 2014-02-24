Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBXWAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:37 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:60188 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752952AbaBXWAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:4:41:69:355:379:541:800:960:966:968:973:982:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1801:2196:2199:2393:2559:2562:2894:2895:3138:3139:3140:3141:3142:3865:3866:3867:3868:3871:4321:4385:4605:5007:6119:6261:7903:8557:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12683:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: back52_215637a28ab4a
X-Filterd-Recvd-Size: 18847
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>, David Safford <safford@watson.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: [PATCH 4/8] security: keys: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:57 -0800
Message-Id: <cd4f0844670ac801057f10bc7801f4880e5a3c34.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt and remove embedded prefixes.
Add missing newline '\n' terminations.
Coalesce formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/keys/encrypted-keys/encrypted.c | 70 +++++++++++++++-----------------
 security/keys/encrypted-keys/encrypted.h |  2 +-
 security/keys/key.c                      |  2 +
 security/keys/trusted.c                  | 42 +++++++++----------
 security/keys/trusted.h                  | 20 ++++-----
 5 files changed, 66 insertions(+), 70 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 5fe443d..82d2dd7 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -14,6 +14,8 @@
  * See Documentation/security/keys-trusted-encrypted.txt
  */
 
+#define pr_fmt(fmt) "encrypted_key: " fmt
+
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -89,8 +91,7 @@ static int aes_get_sizes(void)
 
 	tfm = crypto_alloc_blkcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
-		pr_err("encrypted_key: failed to alloc_cipher (%ld)\n",
-		       PTR_ERR(tfm));
+		pr_err("failed to alloc_cipher (%ld)\n", PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
 	ivsize = crypto_blkcipher_ivsize(tfm);
@@ -111,15 +112,14 @@ static int valid_ecryptfs_desc(const char *ecryptfs_desc)
 	int i;
 
 	if (strlen(ecryptfs_desc) != KEY_ECRYPTFS_DESC_LEN) {
-		pr_err("encrypted_key: key description must be %d hexadecimal "
-		       "characters long\n", KEY_ECRYPTFS_DESC_LEN);
+		pr_err("key description must be %d hexadecimal characters long\n",
+		       KEY_ECRYPTFS_DESC_LEN);
 		return -EINVAL;
 	}
 
 	for (i = 0; i < KEY_ECRYPTFS_DESC_LEN; i++) {
 		if (!isxdigit(ecryptfs_desc[i])) {
-			pr_err("encrypted_key: key description must contain "
-			       "only hexadecimal characters\n");
+			pr_err("key description must contain only hexadecimal characters\n");
 			return -EINVAL;
 		}
 	}
@@ -186,7 +186,7 @@ static int datablob_parse(char *datablob, const char **format,
 
 	keyword = strsep(&datablob, " \t");
 	if (!keyword) {
-		pr_info("encrypted_key: insufficient parameters specified\n");
+		pr_info("insufficient parameters specified\n");
 		return ret;
 	}
 	key_cmd = match_token(keyword, key_tokens, args);
@@ -194,7 +194,7 @@ static int datablob_parse(char *datablob, const char **format,
 	/* Get optional format: default | ecryptfs */
 	p = strsep(&datablob, " \t");
 	if (!p) {
-		pr_err("encrypted_key: insufficient parameters specified\n");
+		pr_err("insufficient parameters specified\n");
 		return ret;
 	}
 
@@ -211,20 +211,20 @@ static int datablob_parse(char *datablob, const char **format,
 	}
 
 	if (!*master_desc) {
-		pr_info("encrypted_key: master key parameter is missing\n");
+		pr_info("master key parameter is missing\n");
 		goto out;
 	}
 
 	if (valid_master_desc(*master_desc, NULL) < 0) {
-		pr_info("encrypted_key: master key parameter \'%s\' "
-			"is invalid\n", *master_desc);
+		pr_info("master key parameter \'%s\' is invalid\n",
+			*master_desc);
 		goto out;
 	}
 
 	if (decrypted_datalen) {
 		*decrypted_datalen = strsep(&datablob, " \t");
 		if (!*decrypted_datalen) {
-			pr_info("encrypted_key: keylen parameter is missing\n");
+			pr_info("keylen parameter is missing\n");
 			goto out;
 		}
 	}
@@ -232,37 +232,35 @@ static int datablob_parse(char *datablob, const char **format,
 	switch (key_cmd) {
 	case Opt_new:
 		if (!decrypted_datalen) {
-			pr_info("encrypted_key: keyword \'%s\' not allowed "
-				"when called from .update method\n", keyword);
+			pr_info("keyword \'%s\' not allowed when called from .update method\n",
+				keyword);
 			break;
 		}
 		ret = 0;
 		break;
 	case Opt_load:
 		if (!decrypted_datalen) {
-			pr_info("encrypted_key: keyword \'%s\' not allowed "
-				"when called from .update method\n", keyword);
+			pr_info("keyword \'%s\' not allowed when called from .update method\n",
+				keyword);
 			break;
 		}
 		*hex_encoded_iv = strsep(&datablob, " \t");
 		if (!*hex_encoded_iv) {
-			pr_info("encrypted_key: hex blob is missing\n");
+			pr_info("hex blob is missing\n");
 			break;
 		}
 		ret = 0;
 		break;
 	case Opt_update:
 		if (decrypted_datalen) {
-			pr_info("encrypted_key: keyword \'%s\' not allowed "
-				"when called from .instantiate method\n",
+			pr_info("keyword \'%s\' not allowed when called from .instantiate method\n",
 				keyword);
 			break;
 		}
 		ret = 0;
 		break;
 	case Opt_err:
-		pr_info("encrypted_key: keyword \'%s\' not recognized\n",
-			keyword);
+		pr_info("keyword \'%s\' not recognized\n", keyword);
 		break;
 	}
 out:
@@ -343,7 +341,7 @@ static int calc_hmac(u8 *digest, const u8 *key, unsigned int keylen,
 
 	sdesc = alloc_sdesc(hmacalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("encrypted_key: can't alloc %s\n", hmac_alg);
+		pr_info("can't alloc %s\n", hmac_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -361,7 +359,7 @@ static int calc_hash(u8 *digest, const u8 *buf, unsigned int buflen)
 
 	sdesc = alloc_sdesc(hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("encrypted_key: can't alloc %s\n", hash_alg);
+		pr_info("can't alloc %s\n", hash_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -386,7 +384,7 @@ static int get_derived_key(u8 *derived_key, enum derived_key_type key_type,
 
 	derived_buf = kzalloc(derived_buf_len, GFP_KERNEL);
 	if (!derived_buf) {
-		pr_err("encrypted_key: out of memory\n");
+		pr_err("out of memory\n");
 		return -ENOMEM;
 	}
 	if (key_type)
@@ -409,7 +407,7 @@ static int init_blkcipher_desc(struct blkcipher_desc *desc, const u8 *key,
 
 	desc->tfm = crypto_alloc_blkcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(desc->tfm)) {
-		pr_err("encrypted_key: failed to load %s transform (%ld)\n",
+		pr_err("failed to load %s transform (%ld)\n",
 		       blkcipher_alg, PTR_ERR(desc->tfm));
 		return PTR_ERR(desc->tfm);
 	}
@@ -417,7 +415,7 @@ static int init_blkcipher_desc(struct blkcipher_desc *desc, const u8 *key,
 
 	ret = crypto_blkcipher_setkey(desc->tfm, key, key_len);
 	if (ret < 0) {
-		pr_err("encrypted_key: failed to setkey (%d)\n", ret);
+		pr_err("failed to setkey (%d)\n", ret);
 		crypto_free_blkcipher(desc->tfm);
 		return ret;
 	}
@@ -447,11 +445,10 @@ static struct key *request_master_key(struct encrypted_key_payload *epayload,
 		int ret = PTR_ERR(mkey);
 
 		if (ret == -ENOTSUPP)
-			pr_info("encrypted_key: key %s not supported",
+			pr_info("key %s not supported\n",
 				epayload->master_desc);
 		else
-			pr_info("encrypted_key: key %s not found",
-				epayload->master_desc);
+			pr_info("key %s not found\n", epayload->master_desc);
 		goto out;
 	}
 
@@ -494,7 +491,7 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 	ret = crypto_blkcipher_encrypt(&desc, sg_out, sg_in, encrypted_datalen);
 	crypto_free_blkcipher(desc.tfm);
 	if (ret < 0)
-		pr_err("encrypted_key: failed to encrypt (%d)\n", ret);
+		pr_err("failed to encrypt (%d)\n", ret);
 	else
 		dump_encrypted_data(epayload, encrypted_datalen);
 out:
@@ -618,8 +615,7 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 	payload_datalen = decrypted_datalen;
 	if (format && !strcmp(format, key_format_ecryptfs)) {
 		if (dlen != ECRYPTFS_MAX_KEY_BYTES) {
-			pr_err("encrypted_key: keylen for the ecryptfs format "
-			       "must be equal to %d bytes\n",
+			pr_err("keylen for the ecryptfs format must be equal to %d bytes\n",
 			       ECRYPTFS_MAX_KEY_BYTES);
 			return ERR_PTR(-EINVAL);
 		}
@@ -687,7 +683,7 @@ static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
 
 	ret = datablob_hmac_verify(epayload, format, master_key, master_keylen);
 	if (ret < 0) {
-		pr_err("encrypted_key: bad hmac (%d)\n", ret);
+		pr_err("bad hmac (%d)\n", ret);
 		goto out;
 	}
 
@@ -697,7 +693,7 @@ static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
 
 	ret = derived_key_decrypt(epayload, derived_key, sizeof derived_key);
 	if (ret < 0)
-		pr_err("encrypted_key: failed to decrypt key (%d)\n", ret);
+		pr_err("failed to decrypt key (%d)\n", ret);
 out:
 	up_read(&mkey->sem);
 	key_put(mkey);
@@ -991,15 +987,13 @@ static int __init encrypted_shash_alloc(void)
 
 	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hmacalg)) {
-		pr_info("encrypted_key: could not allocate crypto %s\n",
-			hmac_alg);
+		pr_info("could not allocate crypto %s\n", hmac_alg);
 		return PTR_ERR(hmacalg);
 	}
 
 	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hashalg)) {
-		pr_info("encrypted_key: could not allocate crypto %s\n",
-			hash_alg);
+		pr_info("could not allocate crypto %s\n", hash_alg);
 		ret = PTR_ERR(hashalg);
 		goto hashalg_fail;
 	}
diff --git a/security/keys/encrypted-keys/encrypted.h b/security/keys/encrypted-keys/encrypted.h
index 8136a2d..1244aaa 100644
--- a/security/keys/encrypted-keys/encrypted.h
+++ b/security/keys/encrypted-keys/encrypted.h
@@ -40,7 +40,7 @@ static inline void dump_hmac(const char *str, const u8 *digest,
 			     unsigned int hmac_size)
 {
 	if (str)
-		pr_info("encrypted_key: %s", str);
+		pr_info("%s", str);
 	print_hex_dump(KERN_ERR, "hmac: ", DUMP_PREFIX_NONE, 32, 1, digest,
 		       hmac_size, 0);
 }
diff --git a/security/keys/key.c b/security/keys/key.c
index 6e21c11..16e26c7 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -9,6 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/poison.h>
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 6b804aa..6d3dd37 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -11,6 +11,8 @@
  * See Documentation/security/keys-trusted-encrypted.txt
  */
 
+#define pr_fmt(fmt) "trusted_key: " fmt
+
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -64,7 +66,7 @@ static int TSS_sha1(const unsigned char *data, unsigned int datalen,
 
 	sdesc = init_sdesc(hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("can't alloc %s\n", hash_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -84,7 +86,7 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 
 	sdesc = init_sdesc(hmacalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hmac_alg);
+		pr_info("can't alloc %s\n", hmac_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -134,7 +136,7 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 
 	sdesc = init_sdesc(hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("can't alloc %s\n", hash_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -206,7 +208,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 
 	sdesc = init_sdesc(hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("can't alloc %s\n", hash_alg);
 		return PTR_ERR(sdesc);
 	}
 	ret = crypto_shash_init(&sdesc->shash);
@@ -298,7 +300,7 @@ static int TSS_checkhmac2(unsigned char *buffer,
 
 	sdesc = init_sdesc(hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("can't alloc %s\n", hash_alg);
 		return PTR_ERR(sdesc);
 	}
 	ret = crypto_shash_init(&sdesc->shash);
@@ -591,12 +593,12 @@ static int tpm_unseal(struct tpm_buf *tb,
 	/* sessions for unsealing key and data */
 	ret = oiap(tb, &authhandle1, enonce1);
 	if (ret < 0) {
-		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		pr_info("oiap failed (%d)\n", ret);
 		return ret;
 	}
 	ret = oiap(tb, &authhandle2, enonce2);
 	if (ret < 0) {
-		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		pr_info("oiap failed (%d)\n", ret);
 		return ret;
 	}
 
@@ -604,7 +606,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 	keyhndl = htonl(SRKHANDLE);
 	ret = tpm_get_random(TPM_ANY_NUM, nonceodd, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE) {
-		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
+		pr_info("tpm_get_random failed (%d)\n", ret);
 		return ret;
 	}
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
@@ -636,7 +638,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
 	if (ret < 0) {
-		pr_info("trusted_key: authhmac failed (%d)\n", ret);
+		pr_info("authhmac failed (%d)\n", ret);
 		return ret;
 	}
 
@@ -648,7 +650,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 			     *datalen, TPM_DATA_OFFSET + sizeof(uint32_t), 0,
 			     0);
 	if (ret < 0) {
-		pr_info("trusted_key: TSS_checkhmac2 failed (%d)\n", ret);
+		pr_info("TSS_checkhmac2 failed (%d)\n", ret);
 		return ret;
 	}
 	memcpy(data, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *datalen);
@@ -675,7 +677,7 @@ static int key_seal(struct trusted_key_payload *p,
 		       p->key, p->key_len + 1, p->blob, &p->blob_len,
 		       o->blobauth, o->pcrinfo, o->pcrinfo_len);
 	if (ret < 0)
-		pr_info("trusted_key: srkseal failed (%d)\n", ret);
+		pr_info("srkseal failed (%d)\n", ret);
 
 	kfree(tb);
 	return ret;
@@ -697,7 +699,7 @@ static int key_unseal(struct trusted_key_payload *p,
 	ret = tpm_unseal(tb, o->keyhandle, o->keyauth, p->blob, p->blob_len,
 			 o->blobauth, p->key, &p->key_len);
 	if (ret < 0)
-		pr_info("trusted_key: srkunseal failed (%d)\n", ret);
+		pr_info("srkunseal failed (%d)\n", ret);
 	else
 		/* pull migratable flag out of sealed key */
 		p->migratable = p->key[--p->key_len];
@@ -941,18 +943,18 @@ static int trusted_instantiate(struct key *key,
 		dump_payload(payload);
 		dump_options(options);
 		if (ret < 0)
-			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
+			pr_info("key_unseal failed (%d)\n", ret);
 		break;
 	case Opt_new:
 		key_len = payload->key_len;
 		ret = tpm_get_random(TPM_ANY_NUM, payload->key, key_len);
 		if (ret != key_len) {
-			pr_info("trusted_key: key_create failed (%d)\n", ret);
+			pr_info("key_create failed (%d)\n", ret);
 			goto out;
 		}
 		ret = key_seal(payload, options);
 		if (ret < 0)
-			pr_info("trusted_key: key_seal failed (%d)\n", ret);
+			pr_info("key_seal failed (%d)\n", ret);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1027,14 +1029,14 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 
 	ret = key_seal(new_p, new_o);
 	if (ret < 0) {
-		pr_info("trusted_key: key_seal failed (%d)\n", ret);
+		pr_info("key_seal failed (%d)\n", ret);
 		kfree(new_p);
 		goto out;
 	}
 	if (new_o->pcrlock) {
 		ret = pcrlock(new_o->pcrlock);
 		if (ret < 0) {
-			pr_info("trusted_key: pcrlock failed (%d)\n", ret);
+			pr_info("pcrlock failed (%d)\n", ret);
 			kfree(new_p);
 			goto out;
 		}
@@ -1118,15 +1120,13 @@ static int __init trusted_shash_alloc(void)
 
 	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hmacalg)) {
-		pr_info("trusted_key: could not allocate crypto %s\n",
-			hmac_alg);
+		pr_info("could not allocate crypto %s\n", hmac_alg);
 		return PTR_ERR(hmacalg);
 	}
 
 	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hashalg)) {
-		pr_info("trusted_key: could not allocate crypto %s\n",
-			hash_alg);
+		pr_info("could not allocate crypto %s\n", hash_alg);
 		ret = PTR_ERR(hashalg);
 		goto hashalg_fail;
 	}
diff --git a/security/keys/trusted.h b/security/keys/trusted.h
index 3249fbd..babe4fb 100644
--- a/security/keys/trusted.h
+++ b/security/keys/trusted.h
@@ -51,33 +51,33 @@ struct trusted_key_options {
 #if TPM_DEBUG
 static inline void dump_options(struct trusted_key_options *o)
 {
-	pr_info("trusted_key: sealing key type %d\n", o->keytype);
-	pr_info("trusted_key: sealing key handle %0X\n", o->keyhandle);
-	pr_info("trusted_key: pcrlock %d\n", o->pcrlock);
-	pr_info("trusted_key: pcrinfo %d\n", o->pcrinfo_len);
+	pr_info("sealing key type %d\n", o->keytype);
+	pr_info("sealing key handle %0X\n", o->keyhandle);
+	pr_info("pcrlock %d\n", o->pcrlock);
+	pr_info("pcrinfo %d\n", o->pcrinfo_len);
 	print_hex_dump(KERN_INFO, "pcrinfo ", DUMP_PREFIX_NONE,
 		       16, 1, o->pcrinfo, o->pcrinfo_len, 0);
 }
 
 static inline void dump_payload(struct trusted_key_payload *p)
 {
-	pr_info("trusted_key: key_len %d\n", p->key_len);
+	pr_info("key_len %d\n", p->key_len);
 	print_hex_dump(KERN_INFO, "key ", DUMP_PREFIX_NONE,
 		       16, 1, p->key, p->key_len, 0);
-	pr_info("trusted_key: bloblen %d\n", p->blob_len);
+	pr_info("bloblen %d\n", p->blob_len);
 	print_hex_dump(KERN_INFO, "blob ", DUMP_PREFIX_NONE,
 		       16, 1, p->blob, p->blob_len, 0);
-	pr_info("trusted_key: migratable %d\n", p->migratable);
+	pr_info("migratable %d\n", p->migratable);
 }
 
 static inline void dump_sess(struct osapsess *s)
 {
 	print_hex_dump(KERN_INFO, "trusted-key: handle ", DUMP_PREFIX_NONE,
 		       16, 1, &s->handle, 4, 0);
-	pr_info("trusted-key: secret:\n");
+	pr_info("secret:\n");
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
 		       16, 1, &s->secret, SHA1_DIGEST_SIZE, 0);
-	pr_info("trusted-key: enonce:\n");
+	pr_info("enonce:\n");
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
 		       16, 1, &s->enonce, SHA1_DIGEST_SIZE, 0);
 }
@@ -86,7 +86,7 @@ static inline void dump_tpm_buf(unsigned char *buf)
 {
 	int len;
 
-	pr_info("\ntrusted-key: tpm buffer\n");
+	pr_info("tpm buffer\n");
 	len = LOAD32(buf, TPM_SIZE_OFFSET);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
 }
-- 
1.8.1.2.459.gbcd45b4.dirty


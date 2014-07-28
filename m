Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaG1NzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaG1NzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:55:05 -0400
Subject: [PATCH 1/2] X.509: x509_request_asymmetric_keys() doesn't need
 string length arguments
From: David Howells <dhowells@redhat.com>
To: d.kasatkin@samsung.com, zohar@linux.vnet.ibm.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 14:54:49 +0100
Message-ID: <20140728135449.18307.38548.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x509_request_asymmetric_keys() doesn't need the lengths of the NUL-terminated
strings passing in as it can work that out for itself.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 crypto/asymmetric_keys/x509_public_key.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index a0f7cd196c9b..4ae982234d78 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -48,11 +48,10 @@ __setup("ca_keys=", ca_keys_setup);
  */
 static struct key *x509_request_asymmetric_key(struct key *keyring,
 					       const char *signer,
-					       size_t signer_len,
-					       const char *authority,
-					       size_t auth_len)
+					       const char *authority)
 {
 	key_ref_t key;
+	size_t signer_len = strlen(signer), auth_len = strlen(authority);
 	char *id;
 
 	/* Construct an identifier. */
@@ -193,9 +192,7 @@ static int x509_validate_trust(struct x509_certificate *cert,
 		return -EPERM;
 
 	key = x509_request_asymmetric_key(trust_keyring,
-					  cert->issuer, strlen(cert->issuer),
-					  cert->authority,
-					  strlen(cert->authority));
+					  cert->issuer, cert->authority);
 	if (!IS_ERR(key))  {
 		if (!use_builtin_keys
 		    || test_bit(KEY_FLAG_BUILTIN, &key->flags))


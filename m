Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaIHPhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbaIHPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:37:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 03/13] KEYS: Remove key_type::def_lookup_type
From: David Howells <dhowells@redhat.com>
To: rusty@rustcorp.com.au
Cc: keyrings@linux-nfs.org, jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        pjones@redhat.com, vgoyal@redhat.com
Date: Mon, 08 Sep 2014 16:37:36 +0100
Message-ID: <20140908153736.28301.44913.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
References: <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove key_type::def_lookup_type as it's no longer used.  The information now
defaults to KEYRING_SEARCH_LOOKUP_DIRECT but may be overridden by
type->match_preparse().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c |    1 -
 crypto/asymmetric_keys/pkcs7_key_type.c  |    1 -
 include/linux/key-type.h                 |    3 ---
 security/keys/big_key.c                  |    1 -
 security/keys/user_defined.c             |    2 --
 5 files changed, 8 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index f666b4e8d256..9d78ad7754d9 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -228,7 +228,6 @@ struct key_type key_type_asymmetric = {
 	.match_free	= asymmetric_key_match_free,
 	.destroy	= asymmetric_key_destroy,
 	.describe	= asymmetric_key_describe,
-	.def_lookup_type = KEYRING_SEARCH_LOOKUP_ITERATE,
 };
 EXPORT_SYMBOL_GPL(key_type_asymmetric);
 
diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index 3de5fb011de0..d1faa1df1dec 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -72,7 +72,6 @@ error:
  */
 static struct key_type key_type_pkcs7 = {
 	.name			= "pkcs7_test",
-	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	.preparse		= pkcs7_preparse,
 	.free_preparse		= user_free_preparse,
 	.instantiate		= generic_key_instantiate,
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 8aba688a451a..bf93ea609273 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -81,9 +81,6 @@ struct key_type {
 	 */
 	size_t def_datalen;
 
-	/* Default key search algorithm. */
-	unsigned def_lookup_type;
-
 	/* vet a description */
 	int (*vet_description)(const char *description);
 
diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index c2f91a0cf889..4045c13a761a 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -33,7 +33,6 @@ MODULE_LICENSE("GPL");
  */
 struct key_type key_type_big_key = {
 	.name			= "big_key",
-	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	.preparse		= big_key_preparse,
 	.free_preparse		= big_key_free_preparse,
 	.instantiate		= generic_key_instantiate,
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index ec8a56063b02..cd7e726e8646 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -26,7 +26,6 @@ static int logon_vet_description(const char *desc);
  */
 struct key_type key_type_user = {
 	.name			= "user",
-	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	.preparse		= user_preparse,
 	.free_preparse		= user_free_preparse,
 	.instantiate		= generic_key_instantiate,
@@ -48,7 +47,6 @@ EXPORT_SYMBOL_GPL(key_type_user);
  */
 struct key_type key_type_logon = {
 	.name			= "logon",
-	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	.preparse		= user_preparse,
 	.free_preparse		= user_free_preparse,
 	.instantiate		= generic_key_instantiate,


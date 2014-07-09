Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaGIPRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbaGIPRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:41 -0400
Subject: [PATCH17/17] pefile: Validate PKCS#7 trust chain
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:17:14 +0100
Message-ID: <20140709151714.23074.44982.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Validate the PKCS#7 trust chain against the contents of the system keyring.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/verify_pefile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 029a365..79175e6 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -449,7 +449,7 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	if (ret < 0)
 		goto error;
 
-	ret = -ENOANO; // Not yet complete
+	ret = pkcs7_validate_trust(pkcs7, trusted_keyring, _trusted);
 
 error:
 	pkcs7_free_message(ctx.pkcs7);


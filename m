Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaGaONI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaGaONG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:13:06 -0400
Subject: [PATCH] PKCS#7: issuer and subject are mandatory fields in the ASN.1
From: David Howells <dhowells@redhat.com>
To: dan.carpenter@oracle.com
Cc: keyrings@linux-nfs.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, vgoyal@redhat.com
Date: Thu, 31 Jul 2014 15:11:03 +0100
Message-ID: <20140731141103.16348.91901.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

issuer and subject are mandatory fields in the ASN.1 and so their existence
needn't be tested for.  They are guaranteed to end up with an empty string if
the name material has nothing we can use (see x509_fabricate_name()).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 51ff36f3a913..c62cf8006e1f 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -190,14 +190,12 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		if (ret < 0)
 			return ret;
 
-		if (x509->issuer)
-			pr_debug("- issuer %s\n", x509->issuer);
+		pr_debug("- issuer %s\n", x509->issuer);
 		if (x509->authority)
 			pr_debug("- authkeyid %s\n", x509->authority);
 
 		if (!x509->authority ||
-		    (x509->subject &&
-		     strcmp(x509->subject, x509->issuer) == 0)) {
+		    strcmp(x509->subject, x509->issuer) == 0) {
 			/* If there's no authority certificate specified, then
 			 * the certificate must be self-signed and is the root
 			 * of the chain.  Likewise if the cert is its own


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaGIPQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbaGIPQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:16:05 -0400
Subject: [PATCH02/17] X.509: Export certificate parse and free functions
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:15:38 +0100
Message-ID: <20140709151538.23074.74939.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export certificate parse and free functions for use by modules.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Josh Boyer <jwboyer@redhat.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 4a8df29..ac72348 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -11,6 +11,7 @@
 
 #define pr_fmt(fmt) "X.509: "fmt
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
@@ -52,6 +53,7 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert);
 	}
 }
+EXPORT_SYMBOL_GPL(x509_free_certificate);
 
 /*
  * Parse an X.509 certificate
@@ -97,6 +99,7 @@ error_no_ctx:
 error_no_cert:
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(x509_cert_parse);
 
 /*
  * Note an OID when we find one for later processing when we know how


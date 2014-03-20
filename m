Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaCTNFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:05:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbaCTNFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:05:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 12/12] KEYS: request_key_auth: Provide key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:06:17 +0000
Message-ID: <20140320120617.21635.96975.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide key preparsing for the request_key_auth key type so that we can make
preparsing mandatory.  This does nothing as this type can only be set up
internally to the kernel.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/request_key_auth.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 7495a93b4b90..842e6f410d50 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -20,6 +20,8 @@
 #include "internal.h"
 #include <keys/user-type.h>
 
+static int request_key_auth_preparse(struct key_preparsed_payload *);
+static void request_key_auth_free_preparse(struct key_preparsed_payload *);
 static int request_key_auth_instantiate(struct key *,
 					struct key_preparsed_payload *);
 static void request_key_auth_describe(const struct key *, struct seq_file *);
@@ -33,6 +35,8 @@ static long request_key_auth_read(const struct key *, char __user *, size_t);
 struct key_type key_type_request_key_auth = {
 	.name		= ".request_key_auth",
 	.def_datalen	= sizeof(struct request_key_auth),
+	.preparse	= request_key_auth_preparse,
+	.free_preparse	= request_key_auth_free_preparse,
 	.instantiate	= request_key_auth_instantiate,
 	.describe	= request_key_auth_describe,
 	.revoke		= request_key_auth_revoke,
@@ -40,6 +44,15 @@ struct key_type key_type_request_key_auth = {
 	.read		= request_key_auth_read,
 };
 
+int request_key_auth_preparse(struct key_preparsed_payload *prep)
+{
+	return 0;
+}
+
+void request_key_auth_free_preparse(struct key_preparsed_payload *prep)
+{
+}
+
 /*
  * Instantiate a request-key authorisation key.
  */


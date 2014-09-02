Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaIBMwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaIBMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:52:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/5] KEYS: Fix public_key asymmetric key subtype name
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2014 13:52:10 +0100
Message-ID: <20140902125210.9247.89132.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
References: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The length of the name of an asymmetric key subtype must be stored in struct
asymmetric_key_subtype::name_len so that it can be matched by a search for
"<subkey_name>:<partial_fingerprint>".  Fix the public_key subtype to have
name_len set.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 97eb001960b9..2f6e4fb1a1ea 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -121,6 +121,7 @@ static int public_key_verify_signature_2(const struct key *key,
 struct asymmetric_key_subtype public_key_subtype = {
 	.owner			= THIS_MODULE,
 	.name			= "public_key",
+	.name_len		= sizeof("public_key") - 1,
 	.describe		= public_key_describe,
 	.destroy		= public_key_destroy,
 	.verify_signature	= public_key_verify_signature_2,


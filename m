Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbaCTMFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbaCTMFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:05:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 07/12] KEYS: Ceph: Use user_match()
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, Sage Weil <sage@newdream.net>,
        linux-security-module@vger.kernel.org,
        Tommi Virtanen <tommi.virtanen@dreamhost.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:27 +0000
Message-ID: <20140320120527.21635.86722.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ceph can use user_match() instead of defining its own identical function.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tommi Virtanen <tommi.virtanen@dreamhost.com>
cc: Sage Weil <sage@newdream.net>
---

 net/ceph/crypto.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 2c8078d990ee..ffeba8f9dda9 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -8,6 +8,7 @@
 #include <linux/key-type.h>
 
 #include <keys/ceph-type.h>
+#include <keys/user-type.h>
 #include <linux/ceph/decode.h>
 #include "crypto.h"
 
@@ -462,11 +463,6 @@ static void ceph_key_free_preparse(struct key_preparsed_payload *prep)
 	kfree(ckey);
 }
 
-static int ceph_key_match(const struct key *key, const void *description)
-{
-	return strcmp(key->description, description) == 0;
-}
-
 static void ceph_key_destroy(struct key *key)
 {
 	struct ceph_crypto_key *ckey = key->payload.data;
@@ -480,7 +476,7 @@ struct key_type key_type_ceph = {
 	.preparse	= ceph_key_preparse,
 	.free_preparse	= ceph_key_free_preparse,
 	.instantiate	= generic_key_instantiate,
-	.match		= ceph_key_match,
+	.match		= user_match,
 	.destroy	= ceph_key_destroy,
 };
 


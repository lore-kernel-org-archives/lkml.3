Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaIBMwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaIBMwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:52:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/5] KEYS: Increase root_maxkeys and root_maxbytes sizes
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, Steve Dickson <steved@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2014 13:52:05 +0100
Message-ID: <20140902125204.9247.668.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
References: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Dickson <stevedredhatcom>

Now that NFS client uses the kernel key ring facility to store the NFSv4
id/gid mappings, the defaults for root_maxkeys and root_maxbytes need to be
substantially increased.

These values have been soak tested:

	https://bugzilla.redhat.com/show_bug.cgi?id=1033708#c73

Signed-off-by: Steve Dickson <steved@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/key.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/key.c b/security/keys/key.c
index b90a68c4e2c4..6d0cad16f002 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -27,8 +27,8 @@ DEFINE_SPINLOCK(key_serial_lock);
 struct rb_root	key_user_tree; /* tree of quota records indexed by UID */
 DEFINE_SPINLOCK(key_user_lock);
 
-unsigned int key_quota_root_maxkeys = 200;	/* root's key count quota */
-unsigned int key_quota_root_maxbytes = 20000;	/* root's key space quota */
+unsigned int key_quota_root_maxkeys = 1000000;	/* root's key count quota */
+unsigned int key_quota_root_maxbytes = 25000000; /* root's key space quota */
 unsigned int key_quota_maxkeys = 200;		/* general key count quota */
 unsigned int key_quota_maxbytes = 20000;	/* general key space quota */
 


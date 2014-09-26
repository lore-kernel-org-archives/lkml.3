Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaIZKhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:37:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbaIZJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/142] dcache.c: get rid of pointless macros
Date: Fri, 26 Sep 2014 11:43:38 +0200
Message-Id: <c9258b208f7e5ad213449a83468d3be2ad09d266.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 482db9066199813d6b999b65a3171afdbec040b6 upstream.

D_HASH{MASK,BITS} are used once each, both in the same function (d_hash()).
At this point they are actively misguiding - they imply that values are
compiler constants, which is no longer true.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dcache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 8ef74f3d8fe5..5859bc5c981d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -125,8 +125,6 @@ static inline void done_seqretry(seqlock_t *lock, int seq)
  * This hash-function tries to avoid losing too many bits of hash
  * information, yet avoid using a prime hash-size or similar.
  */
-#define D_HASHBITS     d_hash_shift
-#define D_HASHMASK     d_hash_mask
 
 static unsigned int d_hash_mask __read_mostly;
 static unsigned int d_hash_shift __read_mostly;
@@ -137,8 +135,8 @@ static inline struct hlist_bl_head *d_hash(const struct dentry *parent,
 					unsigned int hash)
 {
 	hash += (unsigned long) parent / L1_CACHE_BYTES;
-	hash = hash + (hash >> D_HASHBITS);
-	return dentry_hashtable + (hash & D_HASHMASK);
+	hash = hash + (hash >> d_hash_shift);
+	return dentry_hashtable + (hash & d_hash_mask);
 }
 
 /* Statistics gathering. */
-- 
2.1.0


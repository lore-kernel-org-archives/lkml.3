Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaIOTuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbaIOTr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.10 69/71] dcache.c: get rid of pointless macros
Date: Mon, 15 Sep 2014 12:27:07 -0700
Message-Id: <20140915192641.001890903@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 482db9066199813d6b999b65a3171afdbec040b6 upstream.

D_HASH{MASK,BITS} are used once each, both in the same function (d_hash()).
At this point they are actively misguiding - they imply that values are
compiler constants, which is no longer true.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -96,8 +96,6 @@ static struct kmem_cache *dentry_cache _
  * This hash-function tries to avoid losing too many bits of hash
  * information, yet avoid using a prime hash-size or similar.
  */
-#define D_HASHBITS     d_hash_shift
-#define D_HASHMASK     d_hash_mask
 
 static unsigned int d_hash_mask __read_mostly;
 static unsigned int d_hash_shift __read_mostly;
@@ -108,8 +106,8 @@ static inline struct hlist_bl_head *d_ha
 					unsigned int hash)
 {
 	hash += (unsigned long) parent / L1_CACHE_BYTES;
-	hash = hash + (hash >> D_HASHBITS);
-	return dentry_hashtable + (hash & D_HASHMASK);
+	hash = hash + (hash >> d_hash_shift);
+	return dentry_hashtable + (hash & d_hash_mask);
 }
 
 /* Statistics gathering. */



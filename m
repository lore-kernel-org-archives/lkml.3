Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaELSEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:04:49 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:21635 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbaELSEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:04:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KAIoKcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0mFVoh8hEcEjyWKIgGLBIgDgzg7
Date: Mon, 12 May 2014 20:04:45 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/2] FS/CACHEFILES: convert printk to pr_foo()
Message-Id: <20140512200445.edee2954e66a1d2ec4cf31ca@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cachefiles/bind.c      | 10 ++++------
 fs/cachefiles/interface.c |  3 +--
 fs/cachefiles/internal.h  | 22 +++++++++++-----------
 fs/cachefiles/main.c      |  7 +++----
 fs/cachefiles/namei.c     | 39 +++++++++++++++++----------------------
 fs/cachefiles/security.c  | 10 +++-------
 6 files changed, 39 insertions(+), 52 deletions(-)

diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index 5b99baf..c7f3dd2 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -228,9 +228,8 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 	set_bit(CACHEFILES_READY, &cache->flags);
 	dput(root);
 
-	printk(KERN_INFO "CacheFiles:"
-	       " File cache on %s registered\n",
-	       cache->cache.identifier);
+	pr_info("CacheFiles: File cache on %s registered\n",
+		cache->cache.identifier);
 
 	/* check how much space the cache has */
 	cachefiles_has_space(cache, 0, 0);
@@ -262,9 +261,8 @@ void cachefiles_daemon_unbind(struct cachefiles_cache *cache)
 	_enter("");
 
 	if (test_bit(CACHEFILES_READY, &cache->flags)) {
-		printk(KERN_INFO "CacheFiles:"
-		       " File cache on %s unregistering\n",
-		       cache->cache.identifier);
+		pr_info("CacheFiles: File cache on %s unregistering\n",
+			cache->cache.identifier);
 
 		fscache_withdraw_cache(&cache->cache);
 	}
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 57e17fe..e47a8d8 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -146,8 +146,7 @@ static int cachefiles_lookup_object(struct fscache_object *_object)
 
 	if (ret < 0 && ret != -ETIMEDOUT) {
 		if (ret != -ENOBUFS)
-			printk(KERN_WARNING
-			       "CacheFiles: Lookup failed error %d\n", ret);
+			pr_warn("CacheFiles: Lookup failed error %d\n", ret);
 		fscache_object_lookup_error(&object->fscache);
 	}
 
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 5349473..5c7ec64 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -245,7 +245,7 @@ extern int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 /*
  * error handling
  */
-#define kerror(FMT, ...) printk(KERN_ERR "CacheFiles: "FMT"\n", ##__VA_ARGS__)
+#define kerror(FMT, ...) pr_err("CacheFiles: "FMT"\n", ##__VA_ARGS__)
 
 #define cachefiles_io_error(___cache, FMT, ...)		\
 do {							\
@@ -310,8 +310,8 @@ do {							\
 #define ASSERT(X)							\
 do {									\
 	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
 		BUG();							\
 	}								\
 } while (0)
@@ -319,9 +319,9 @@ do {									\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("%lx " #OP " %lx is false\n",			\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
@@ -330,8 +330,8 @@ do {									\
 #define ASSERTIF(C, X)							\
 do {									\
 	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
 		BUG();							\
 	}								\
 } while (0)
@@ -339,9 +339,9 @@ do {									\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("%lx " #OP " %lx is false\n",			\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
diff --git a/fs/cachefiles/main.c b/fs/cachefiles/main.c
index 4bfa8cf..d45c59c 100644
--- a/fs/cachefiles/main.c
+++ b/fs/cachefiles/main.c
@@ -68,8 +68,7 @@ static int __init cachefiles_init(void)
 				  SLAB_HWCACHE_ALIGN,
 				  cachefiles_object_init_once);
 	if (!cachefiles_object_jar) {
-		printk(KERN_NOTICE
-		       "CacheFiles: Failed to allocate an object jar\n");
+		pr_notice("CacheFiles: Failed to allocate an object jar\n");
 		goto error_object_jar;
 	}
 
@@ -77,7 +76,7 @@ static int __init cachefiles_init(void)
 	if (ret < 0)
 		goto error_proc;
 
-	printk(KERN_INFO "CacheFiles: Loaded\n");
+	pr_info("CacheFiles: Loaded\n");
 	return 0;
 
 error_proc:
@@ -96,7 +95,7 @@ fs_initcall(cachefiles_init);
  */
 static void __exit cachefiles_exit(void)
 {
-	printk(KERN_INFO "CacheFiles: Unloading\n");
+	pr_info("CacheFiles: Unloading\n");
 
 	cachefiles_proc_cleanup();
 	kmem_cache_destroy(cachefiles_object_jar);
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index c0a6817..18e0d8e 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -35,22 +35,21 @@ void __cachefiles_printk_object(struct cachefiles_object *object,
 	struct fscache_cookie *cookie;
 	unsigned keylen, loop;
 
-	printk(KERN_ERR "%sobject: OBJ%x\n",
-	       prefix, object->fscache.debug_id);
-	printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
+	pr_err("%sobject: OBJ%x\n", prefix, object->fscache.debug_id);
+	pr_err("%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
 	       prefix, object->fscache.state->name,
 	       object->fscache.flags, work_busy(&object->fscache.work),
 	       object->fscache.events, object->fscache.event_mask);
-	printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
+	pr_err("%sops=%u inp=%u exc=%u\n",
 	       prefix, object->fscache.n_ops, object->fscache.n_in_progress,
 	       object->fscache.n_exclusive);
-	printk(KERN_ERR "%sparent=%p\n",
+	pr_err("%sparent=%p\n",
 	       prefix, object->fscache.parent);
 
 	spin_lock(&object->fscache.lock);
 	cookie = object->fscache.cookie;
 	if (cookie) {
-		printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
+		pr_err("%scookie=%p [pr=%p nd=%p fl=%lx]\n",
 		       prefix,
 		       object->fscache.cookie,
 		       object->fscache.cookie->parent,
@@ -62,16 +61,16 @@ void __cachefiles_printk_object(struct cachefiles_object *object,
 		else
 			keylen = 0;
 	} else {
-		printk(KERN_ERR "%scookie=NULL\n", prefix);
+		pr_err("%scookie=NULL\n", prefix);
 		keylen = 0;
 	}
 	spin_unlock(&object->fscache.lock);
 
 	if (keylen) {
-		printk(KERN_ERR "%skey=[%u] '", prefix, keylen);
+		pr_err("%skey=[%u] '", prefix, keylen);
 		for (loop = 0; loop < keylen; loop++)
-			printk("%02x", keybuf[loop]);
-		printk("'\n");
+			pr_cont("%02x", keybuf[loop]);
+		pr_cont("'\n");
 	}
 }
 
@@ -131,13 +130,11 @@ found_dentry:
 	       dentry);
 
 	if (fscache_object_is_live(&object->fscache)) {
-		printk(KERN_ERR "\n");
-		printk(KERN_ERR "CacheFiles: Error:"
-		       " Can't preemptively bury live object\n");
+		pr_err("\n");
+		pr_err("CacheFiles: Error: Can't preemptively bury live object\n");
 		cachefiles_printk_object(object, NULL);
 	} else if (test_and_set_bit(CACHEFILES_OBJECT_BURIED, &object->flags)) {
-		printk(KERN_ERR "CacheFiles: Error:"
-		       " Object already preemptively buried\n");
+		pr_err("CacheFiles: Error: Object already preemptively buried\n");
 	}
 
 	write_unlock(&cache->active_lock);
@@ -160,7 +157,7 @@ try_again:
 	write_lock(&cache->active_lock);
 
 	if (test_and_set_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags)) {
-		printk(KERN_ERR "CacheFiles: Error: Object already active\n");
+		pr_err("CacheFiles: Error: Object already active\n");
 		cachefiles_printk_object(object, NULL);
 		BUG();
 	}
@@ -193,9 +190,8 @@ try_again:
 	 * need to wait for it to be destroyed */
 wait_for_old_object:
 	if (fscache_object_is_live(&object->fscache)) {
-		printk(KERN_ERR "\n");
-		printk(KERN_ERR "CacheFiles: Error:"
-		       " Unexpected object collision\n");
+		pr_err("\n");
+		pr_err("CacheFiles: Error: Unexpected object collision\n");
 		cachefiles_printk_object(object, xobject);
 		BUG();
 	}
@@ -241,9 +237,8 @@ wait_for_old_object:
 		}
 
 		if (timeout <= 0) {
-			printk(KERN_ERR "\n");
-			printk(KERN_ERR "CacheFiles: Error: Overlong"
-			       " wait for old active object to go away\n");
+			pr_err("\n");
+			pr_err("CacheFiles: Error: Overlong wait for old active object to go away\n");
 			cachefiles_printk_object(object, xobject);
 			goto requeue;
 		}
diff --git a/fs/cachefiles/security.c b/fs/cachefiles/security.c
index 039b501..7a6b665 100644
--- a/fs/cachefiles/security.c
+++ b/fs/cachefiles/security.c
@@ -34,9 +34,7 @@ int cachefiles_get_security_ID(struct cachefiles_cache *cache)
 		ret = set_security_override_from_ctx(new, cache->secctx);
 		if (ret < 0) {
 			put_cred(new);
-			printk(KERN_ERR "CacheFiles:"
-			       " Security denies permission to nominate"
-			       " security context: error %d\n",
+			pr_err("CacheFiles: Security denies permission to nominate security context: error %d\n",
 			       ret);
 			goto error;
 		}
@@ -59,16 +57,14 @@ static int cachefiles_check_cache_dir(struct cachefiles_cache *cache,
 
 	ret = security_inode_mkdir(root->d_inode, root, 0);
 	if (ret < 0) {
-		printk(KERN_ERR "CacheFiles:"
-		       " Security denies permission to make dirs: error %d",
+		pr_err("CacheFiles: Security denies permission to make dirs: error %d",
 		       ret);
 		return ret;
 	}
 
 	ret = security_inode_create(root->d_inode, root, 0);
 	if (ret < 0)
-		printk(KERN_ERR "CacheFiles:"
-		       " Security denies permission to create files: error %d",
+		pr_err("CacheFiles: Security denies permission to create files: error %d",
 		       ret);
 
 	return ret;
-- 
1.9.1


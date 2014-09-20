Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaITIut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 04:50:49 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:21633 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbaITIur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 04:50:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8OAEM/HVRbsktL/2dsb2JhbABggw2BKrVMBQEBAQEBAQUBcgGbDH0XAXmEMS8jgRo3iEIBwwyGDYl5hFIFhiCLDYtmlU6DYjsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cachefiles: add missing \n to kerror conversions
Date: Sat, 20 Sep 2014 10:50:32 +0200
Message-Id: <1411203032-9509-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0227d6abb378
("fs/cachefiles: replace kerror by pr_err")

didn't include newline featuring in original kerror definition

Reported-by: David Howells <dhowells@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cachefiles/bind.c     |  8 ++++----
 fs/cachefiles/daemon.c   | 30 +++++++++++++++---------------
 fs/cachefiles/internal.h |  2 +-
 fs/cachefiles/main.c     |  2 +-
 fs/cachefiles/namei.c    | 14 +++++++-------
 fs/cachefiles/xattr.c    | 10 +++++-----
 6 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index d749731..fbb08e9 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -50,18 +50,18 @@ int cachefiles_daemon_bind(struct cachefiles_cache *cache, char *args)
 	       cache->brun_percent  < 100);
 
 	if (*args) {
-		pr_err("'bind' command doesn't take an argument");
+		pr_err("'bind' command doesn't take an argument\n");
 		return -EINVAL;
 	}
 
 	if (!cache->rootdirname) {
-		pr_err("No cache directory specified");
+		pr_err("No cache directory specified\n");
 		return -EINVAL;
 	}
 
 	/* don't permit already bound caches to be re-bound */
 	if (test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_err("Cache already bound");
+		pr_err("Cache already bound\n");
 		return -EBUSY;
 	}
 
@@ -248,7 +248,7 @@ error_open_root:
 	kmem_cache_free(cachefiles_object_jar, fsdef);
 error_root_object:
 	cachefiles_end_secure(cache, saved_cred);
-	pr_err("Failed to register: %d", ret);
+	pr_err("Failed to register: %d\n", ret);
 	return ret;
 }
 
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index b078d30..ce1b115 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -315,7 +315,7 @@ static unsigned int cachefiles_daemon_poll(struct file *file,
 static int cachefiles_daemon_range_error(struct cachefiles_cache *cache,
 					 char *args)
 {
-	pr_err("Free space limits must be in range 0%%<=stop<cull<run<100%%");
+	pr_err("Free space limits must be in range 0%%<=stop<cull<run<100%%\n");
 
 	return -EINVAL;
 }
@@ -475,12 +475,12 @@ static int cachefiles_daemon_dir(struct cachefiles_cache *cache, char *args)
 	_enter(",%s", args);
 
 	if (!*args) {
-		pr_err("Empty directory specified");
+		pr_err("Empty directory specified\n");
 		return -EINVAL;
 	}
 
 	if (cache->rootdirname) {
-		pr_err("Second cache directory specified");
+		pr_err("Second cache directory specified\n");
 		return -EEXIST;
 	}
 
@@ -503,12 +503,12 @@ static int cachefiles_daemon_secctx(struct cachefiles_cache *cache, char *args)
 	_enter(",%s", args);
 
 	if (!*args) {
-		pr_err("Empty security context specified");
+		pr_err("Empty security context specified\n");
 		return -EINVAL;
 	}
 
 	if (cache->secctx) {
-		pr_err("Second security context specified");
+		pr_err("Second security context specified\n");
 		return -EINVAL;
 	}
 
@@ -531,7 +531,7 @@ static int cachefiles_daemon_tag(struct cachefiles_cache *cache, char *args)
 	_enter(",%s", args);
 
 	if (!*args) {
-		pr_err("Empty tag specified");
+		pr_err("Empty tag specified\n");
 		return -EINVAL;
 	}
 
@@ -562,12 +562,12 @@ static int cachefiles_daemon_cull(struct cachefiles_cache *cache, char *args)
 		goto inval;
 
 	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_err("cull applied to unready cache");
+		pr_err("cull applied to unready cache\n");
 		return -EIO;
 	}
 
 	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-		pr_err("cull applied to dead cache");
+		pr_err("cull applied to dead cache\n");
 		return -EIO;
 	}
 
@@ -587,11 +587,11 @@ static int cachefiles_daemon_cull(struct cachefiles_cache *cache, char *args)
 
 notdir:
 	path_put(&path);
-	pr_err("cull command requires dirfd to be a directory");
+	pr_err("cull command requires dirfd to be a directory\n");
 	return -ENOTDIR;
 
 inval:
-	pr_err("cull command requires dirfd and filename");
+	pr_err("cull command requires dirfd and filename\n");
 	return -EINVAL;
 }
 
@@ -614,7 +614,7 @@ static int cachefiles_daemon_debug(struct cachefiles_cache *cache, char *args)
 	return 0;
 
 inval:
-	pr_err("debug command requires mask");
+	pr_err("debug command requires mask\n");
 	return -EINVAL;
 }
 
@@ -634,12 +634,12 @@ static int cachefiles_daemon_inuse(struct cachefiles_cache *cache, char *args)
 		goto inval;
 
 	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_err("inuse applied to unready cache");
+		pr_err("inuse applied to unready cache\n");
 		return -EIO;
 	}
 
 	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-		pr_err("inuse applied to dead cache");
+		pr_err("inuse applied to dead cache\n");
 		return -EIO;
 	}
 
@@ -659,11 +659,11 @@ static int cachefiles_daemon_inuse(struct cachefiles_cache *cache, char *args)
 
 notdir:
 	path_put(&path);
-	pr_err("inuse command requires dirfd to be a directory");
+	pr_err("inuse command requires dirfd to be a directory\n");
 	return -ENOTDIR;
 
 inval:
-	pr_err("inuse command requires dirfd and filename");
+	pr_err("inuse command requires dirfd and filename\n");
 	return -EINVAL;
 }
 
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 3d50998..8c52472 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -255,7 +255,7 @@ extern int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 
 #define cachefiles_io_error(___cache, FMT, ...)		\
 do {							\
-	pr_err("I/O Error: " FMT, ##__VA_ARGS__);	\
+	pr_err("I/O Error: " FMT"\n", ##__VA_ARGS__);	\
 	fscache_io_error(&(___cache)->cache);		\
 	set_bit(CACHEFILES_DEAD, &(___cache)->flags);	\
 } while (0)
diff --git a/fs/cachefiles/main.c b/fs/cachefiles/main.c
index 180edfb..711f13d 100644
--- a/fs/cachefiles/main.c
+++ b/fs/cachefiles/main.c
@@ -84,7 +84,7 @@ error_proc:
 error_object_jar:
 	misc_deregister(&cachefiles_dev);
 error_dev:
-	pr_err("failed to register: %d", ret);
+	pr_err("failed to register: %d\n", ret);
 	return ret;
 }
 
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 5bf2b41..55c0acb 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -543,7 +543,7 @@ lookup_again:
 			       next, next->d_inode, next->d_inode->i_ino);
 
 		} else if (!S_ISDIR(next->d_inode->i_mode)) {
-			pr_err("inode %lu is not a directory",
+			pr_err("inode %lu is not a directory\n",
 			       next->d_inode->i_ino);
 			ret = -ENOBUFS;
 			goto error;
@@ -574,7 +574,7 @@ lookup_again:
 		} else if (!S_ISDIR(next->d_inode->i_mode) &&
 			   !S_ISREG(next->d_inode->i_mode)
 			   ) {
-			pr_err("inode %lu is not a file or directory",
+			pr_err("inode %lu is not a file or directory\n",
 			       next->d_inode->i_ino);
 			ret = -ENOBUFS;
 			goto error;
@@ -768,7 +768,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	ASSERT(subdir->d_inode);
 
 	if (!S_ISDIR(subdir->d_inode->i_mode)) {
-		pr_err("%s is not a directory", dirname);
+		pr_err("%s is not a directory\n", dirname);
 		ret = -EIO;
 		goto check_error;
 	}
@@ -795,13 +795,13 @@ check_error:
 mkdir_error:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(subdir);
-	pr_err("mkdir %s failed with error %d", dirname, ret);
+	pr_err("mkdir %s failed with error %d\n", dirname, ret);
 	return ERR_PTR(ret);
 
 lookup_error:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	ret = PTR_ERR(subdir);
-	pr_err("Lookup %s failed with error %d", dirname, ret);
+	pr_err("Lookup %s failed with error %d\n", dirname, ret);
 	return ERR_PTR(ret);
 
 nomem_d_alloc:
@@ -891,7 +891,7 @@ lookup_error:
 	if (ret == -EIO) {
 		cachefiles_io_error(cache, "Lookup failed");
 	} else if (ret != -ENOMEM) {
-		pr_err("Internal error: %d", ret);
+		pr_err("Internal error: %d\n", ret);
 		ret = -EIO;
 	}
 
@@ -950,7 +950,7 @@ error:
 	}
 
 	if (ret != -ENOMEM) {
-		pr_err("Internal error: %d", ret);
+		pr_err("Internal error: %d\n", ret);
 		ret = -EIO;
 	}
 
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 1ad51ffb..acbc1f0 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -51,7 +51,7 @@ int cachefiles_check_object_type(struct cachefiles_object *object)
 	}
 
 	if (ret != -EEXIST) {
-		pr_err("Can't set xattr on %*.*s [%lu] (err %d)",
+		pr_err("Can't set xattr on %*.*s [%lu] (err %d)\n",
 		       dentry->d_name.len, dentry->d_name.len,
 		       dentry->d_name.name, dentry->d_inode->i_ino,
 		       -ret);
@@ -64,7 +64,7 @@ int cachefiles_check_object_type(struct cachefiles_object *object)
 		if (ret == -ERANGE)
 			goto bad_type_length;
 
-		pr_err("Can't read xattr on %*.*s [%lu] (err %d)",
+		pr_err("Can't read xattr on %*.*s [%lu] (err %d)\n",
 		       dentry->d_name.len, dentry->d_name.len,
 		       dentry->d_name.name, dentry->d_inode->i_ino,
 		       -ret);
@@ -85,14 +85,14 @@ error:
 	return ret;
 
 bad_type_length:
-	pr_err("Cache object %lu type xattr length incorrect",
+	pr_err("Cache object %lu type xattr length incorrect\n",
 	       dentry->d_inode->i_ino);
 	ret = -EIO;
 	goto error;
 
 bad_type:
 	xtype[2] = 0;
-	pr_err("Cache object %*.*s [%lu] type %s not %s",
+	pr_err("Cache object %*.*s [%lu] type %s not %s\n",
 	       dentry->d_name.len, dentry->d_name.len,
 	       dentry->d_name.name, dentry->d_inode->i_ino,
 	       xtype, type);
@@ -293,7 +293,7 @@ error:
 	return ret;
 
 bad_type_length:
-	pr_err("Cache object %lu xattr length incorrect",
+	pr_err("Cache object %lu xattr length incorrect\n",
 	       dentry->d_inode->i_ino);
 	ret = -EIO;
 	goto error;
-- 
2.1.0


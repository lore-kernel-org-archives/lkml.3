Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3BOTLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:11:45 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37989 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755Ab3BOTLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:11:43 -0500
Message-ID: <1360955501.2089.11.camel@joe-AO722>
Subject: Re: [PATCH] staging/zcache fixed some checkpatch issues
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Robert Berger <git.rber@gmail.com>, devel@driverdev.osuosl.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com,
        minchan@kernel.org, rber.git@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Date: Fri, 15 Feb 2013 11:11:41 -0800
In-Reply-To: <20130215182119.GA23225@kroah.com>
References: <1360925580-18633-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
	 <20130215182119.GA23225@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 10:21 -0800, Greg KH wrote:
> On Fri, Feb 15, 2013 at 12:53:00PM +0200, Robert Berger wrote:
> > Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
[]
> This patch fails to apply to my tree for some reason, can you redo it
> against the latest linux-next tree and resend?

Perhaps it'd be better to use KBUILD_MODNAME
all the time instead of adding the prefix.

Also, to me mixing "ramster: " and "zcache: "
for the prefixes is odd.  Just using zcache all
the time would be simpler, so remove namestr too.

Maybe:
---
 drivers/staging/zcache/zcache-main.c | 173 ++++++++++++++++-------------------
 1 file changed, 79 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 4456ab4..2b421f4 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -12,6 +12,8 @@
  * be "reclaimed" efficiently.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/highmem.h>
@@ -67,7 +69,6 @@ static int disable_cleancache __read_mostly;
 static int disable_frontswap __read_mostly;
 static int disable_frontswap_ignore_nonactive __read_mostly;
 static int disable_cleancache_ignore_nonactive __read_mostly;
-static char *namestr __read_mostly = "zcache";
 
 #define ZCACHE_GFP_MASK \
 	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
@@ -262,64 +263,56 @@ static int zcache_debugfs_init(void)
 /* developers can call this in case of ooms, e.g. to find memory leaks */
 void zcache_dump(void)
 {
-	pr_info("zcache: obj_count=%lu\n", zcache_obj_count);
-	pr_info("zcache: obj_count_max=%lu\n", zcache_obj_count_max);
-	pr_info("zcache: objnode_count=%lu\n", zcache_objnode_count);
-	pr_info("zcache: objnode_count_max=%lu\n", zcache_objnode_count_max);
-	pr_info("zcache: flush_total=%lu\n", zcache_flush_total);
-	pr_info("zcache: flush_found=%lu\n", zcache_flush_found);
-	pr_info("zcache: flobj_total=%lu\n", zcache_flobj_total);
-	pr_info("zcache: flobj_found=%lu\n", zcache_flobj_found);
-	pr_info("zcache: failed_eph_puts=%lu\n", zcache_failed_eph_puts);
-	pr_info("zcache: failed_pers_puts=%lu\n", zcache_failed_pers_puts);
-	pr_info("zcache: failed_get_free_pages=%lu\n",
-				zcache_failed_getfreepages);
-	pr_info("zcache: failed_alloc=%lu\n", zcache_failed_alloc);
-	pr_info("zcache: put_to_flush=%lu\n", zcache_put_to_flush);
-	pr_info("zcache: compress_poor=%lu\n", zcache_compress_poor);
-	pr_info("zcache: mean_compress_poor=%lu\n",
-				zcache_mean_compress_poor);
-	pr_info("zcache: eph_ate_tail=%lu\n", zcache_eph_ate_tail);
-	pr_info("zcache: eph_ate_tail_failed=%lu\n",
-				zcache_eph_ate_tail_failed);
-	pr_info("zcache: pers_ate_eph=%lu\n", zcache_pers_ate_eph);
-	pr_info("zcache: pers_ate_eph_failed=%lu\n",
-				zcache_pers_ate_eph_failed);
-	pr_info("zcache: evicted_eph_zpages=%lu\n", zcache_evicted_eph_zpages);
-	pr_info("zcache: evicted_eph_pageframes=%lu\n",
-				zcache_evicted_eph_pageframes);
-	pr_info("zcache: eph_pageframes=%lu\n", zcache_eph_pageframes);
-	pr_info("zcache: eph_pageframes_max=%lu\n", zcache_eph_pageframes_max);
-	pr_info("zcache: pers_pageframes=%lu\n", zcache_pers_pageframes);
-	pr_info("zcache: pers_pageframes_max=%lu\n",
-				zcache_pers_pageframes_max);
-	pr_info("zcache: eph_zpages=%lu\n", zcache_eph_zpages);
-	pr_info("zcache: eph_zpages_max=%lu\n", zcache_eph_zpages_max);
-	pr_info("zcache: pers_zpages=%lu\n", zcache_pers_zpages);
-	pr_info("zcache: pers_zpages_max=%lu\n", zcache_pers_zpages_max);
-	pr_info("zcache: last_active_file_pageframes=%lu\n",
-				zcache_last_active_file_pageframes);
-	pr_info("zcache: last_inactive_file_pageframes=%lu\n",
-				zcache_last_inactive_file_pageframes);
-	pr_info("zcache: last_active_anon_pageframes=%lu\n",
-				zcache_last_active_anon_pageframes);
-	pr_info("zcache: last_inactive_anon_pageframes=%lu\n",
-				zcache_last_inactive_anon_pageframes);
-	pr_info("zcache: eph_nonactive_puts_ignored=%lu\n",
-				zcache_eph_nonactive_puts_ignored);
-	pr_info("zcache: pers_nonactive_puts_ignored=%lu\n",
-				zcache_pers_nonactive_puts_ignored);
-	pr_info("zcache: eph_zbytes=%llu\n",
-				(unsigned long long)zcache_eph_zbytes);
-	pr_info("zcache: eph_zbytes_max=%llu\n",
-				(unsigned long long)zcache_eph_zbytes_max);
-	pr_info("zcache: pers_zbytes=%llu\n",
-				(unsigned long long)zcache_pers_zbytes);
-	pr_info("zcache: pers_zbytes_max=%llu\n",
-				(unsigned long long)zcache_pers_zbytes_max);
-	pr_info("zcache: outstanding_writeback_pages=%lu\n",
-				zcache_outstanding_writeback_pages);
-	pr_info("zcache: writtenback_pages=%lu\n", zcache_writtenback_pages);
+	pr_info("obj_count=%lu\n", zcache_obj_count);
+	pr_info("obj_count_max=%lu\n", zcache_obj_count_max);
+	pr_info("objnode_count=%lu\n", zcache_objnode_count);
+	pr_info("objnode_count_max=%lu\n", zcache_objnode_count_max);
+	pr_info("flush_total=%lu\n", zcache_flush_total);
+	pr_info("flush_found=%lu\n", zcache_flush_found);
+	pr_info("flobj_total=%lu\n", zcache_flobj_total);
+	pr_info("flobj_found=%lu\n", zcache_flobj_found);
+	pr_info("failed_eph_puts=%lu\n", zcache_failed_eph_puts);
+	pr_info("failed_pers_puts=%lu\n", zcache_failed_pers_puts);
+	pr_info("failed_get_free_pages=%lu\n", zcache_failed_getfreepages);
+	pr_info("failed_alloc=%lu\n", zcache_failed_alloc);
+	pr_info("put_to_flush=%lu\n", zcache_put_to_flush);
+	pr_info("compress_poor=%lu\n", zcache_compress_poor);
+	pr_info("mean_compress_poor=%lu\n", zcache_mean_compress_poor);
+	pr_info("eph_ate_tail=%lu\n", zcache_eph_ate_tail);
+	pr_info("eph_ate_tail_failed=%lu\n", zcache_eph_ate_tail_failed);
+	pr_info("pers_ate_eph=%lu\n", zcache_pers_ate_eph);
+	pr_info("pers_ate_eph_failed=%lu\n", zcache_pers_ate_eph_failed);
+	pr_info("evicted_eph_zpages=%lu\n", zcache_evicted_eph_zpages);
+	pr_info("evicted_eph_pageframes=%lu\n", zcache_evicted_eph_pageframes);
+	pr_info("eph_pageframes=%lu\n", zcache_eph_pageframes);
+	pr_info("eph_pageframes_max=%lu\n", zcache_eph_pageframes_max);
+	pr_info("pers_pageframes=%lu\n", zcache_pers_pageframes);
+	pr_info("pers_pageframes_max=%lu\n", zcache_pers_pageframes_max);
+	pr_info("eph_zpages=%lu\n", zcache_eph_zpages);
+	pr_info("eph_zpages_max=%lu\n", zcache_eph_zpages_max);
+	pr_info("pers_zpages=%lu\n", zcache_pers_zpages);
+	pr_info("pers_zpages_max=%lu\n", zcache_pers_zpages_max);
+	pr_info("last_active_file_pageframes=%lu\n",
+		zcache_last_active_file_pageframes);
+	pr_info("last_inactive_file_pageframes=%lu\n",
+		zcache_last_inactive_file_pageframes);
+	pr_info("last_active_anon_pageframes=%lu\n",
+		zcache_last_active_anon_pageframes);
+	pr_info("last_inactive_anon_pageframes=%lu\n",
+		zcache_last_inactive_anon_pageframes);
+	pr_info("eph_nonactive_puts_ignored=%lu\n",
+		zcache_eph_nonactive_puts_ignored);
+	pr_info("pers_nonactive_puts_ignored=%lu\n",
+		zcache_pers_nonactive_puts_ignored);
+	pr_info("eph_zbytes=%llu\n", (unsigned long long)zcache_eph_zbytes);
+	pr_info("eph_zbytes_max=%llu\n",
+		(unsigned long long)zcache_eph_zbytes_max);
+	pr_info("pers_zbytes=%llu\n", (unsigned long long)zcache_pers_zbytes);
+	pr_info("pers_zbytes_max=%llu\n",
+		(unsigned long long)zcache_pers_zbytes_max);
+	pr_info("outstanding_writeback_pages=%lu\n",
+		zcache_outstanding_writeback_pages);
+	pr_info("writtenback_pages=%lu\n", zcache_writtenback_pages);
 }
 #endif
 
@@ -923,8 +916,7 @@ static int zcache_cpu_notifier(struct notifier_block *nb,
 	case CPU_UP_PREPARE:
 		ret = zcache_comp_cpu_up(cpu);
 		if (ret != NOTIFY_OK) {
-			pr_err("%s: can't allocate compressor xform\n",
-				namestr);
+			pr_err("can't allocate compressor xform\n");
 			return ret;
 		}
 		per_cpu(zcache_dstmem, cpu) = (void *)__get_free_pages(
@@ -1401,8 +1393,7 @@ int zcache_get_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 		zcache_put_pool(pool);
 	}
 	WARN_ONCE((!is_ephemeral(pool) && (ret != 0)),
-			"zcache_get fails on persistent pool, "
-			"bad things are very likely to happen soon\n");
+		  "zcache_get fails on persistent pool, bad things are very likely to happen soon\n");
 #ifdef RAMSTER_TESTING
 	if (ret != 0 && ret != -1 && !(ret == -EINVAL && is_ephemeral(pool)))
 		pr_err("TESTING zcache_get tmem_get returns ret=%d\n", ret);
@@ -1484,10 +1475,9 @@ static int zcache_client_destroy_pool(int cli_id, int pool_id)
 	local_bh_enable();
 	kfree(pool);
 	if (cli_id == LOCAL_CLIENT)
-		pr_info("%s: destroyed local pool id=%d\n", namestr, pool_id);
+		pr_info("destroyed local pool id=%d\n", pool_id);
 	else
-		pr_info("%s: destroyed pool id=%d, client=%d\n",
-				namestr, pool_id, cli_id);
+		pr_info("destroyed pool id=%d, client=%d\n", pool_id, cli_id);
 out:
 	return ret;
 }
@@ -1513,7 +1503,7 @@ int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 		if (cli->tmem_pools[poolid] == NULL)
 			break;
 	if (poolid >= MAX_POOLS_PER_CLIENT) {
-		pr_info("%s: pool creation failed: max exceeded\n", namestr);
+		pr_info("pool creation failed: max exceeded\n");
 		kfree(pool);
 		poolid = -1;
 		goto out;
@@ -1524,11 +1514,11 @@ int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 	tmem_new_pool(pool, flags);
 	cli->tmem_pools[poolid] = pool;
 	if (cli_id == LOCAL_CLIENT)
-		pr_info("%s: created %s local tmem pool, id=%d\n", namestr,
+		pr_info("created %s local tmem pool, id=%d\n",
 			flags & TMEM_POOL_PERSIST ? "persistent" : "ephemeral",
 			poolid);
 	else
-		pr_info("%s: created %s tmem pool, id=%d, client=%d\n", namestr,
+		pr_info("created %s tmem pool, id=%d, client=%d\n",
 			flags & TMEM_POOL_PERSIST ? "persistent" : "ephemeral",
 			poolid, cli_id);
 out:
@@ -1559,12 +1549,12 @@ int zcache_autocreate_pool(unsigned int cli_id, unsigned int pool_id, bool eph)
 
 	cli = &zcache_clients[cli_id];
 	if ((eph && disable_cleancache) || (!eph && disable_frontswap)) {
-		pr_err("zcache_autocreate_pool: pool type disabled\n");
+		pr_err("%s: pool type disabled\n", __func__);
 		goto out;
 	}
 	if (!cli->allocated) {
 		if (zcache_new_client(cli_id)) {
-			pr_err("zcache_autocreate_pool: can't create client\n");
+			pr_err("%s: can't create client\n", __func__);
 			goto out;
 		}
 		cli = &zcache_clients[cli_id];
@@ -1573,7 +1563,7 @@ int zcache_autocreate_pool(unsigned int cli_id, unsigned int pool_id, bool eph)
 	pool = cli->tmem_pools[pool_id];
 	if (pool != NULL) {
 		if (pool->persistent && eph) {
-			pr_err("zcache_autocreate_pool: type mismatch\n");
+			pr_err("%s: type mismatch\n", __func__);
 			goto out;
 		}
 		ret = 0;
@@ -1588,8 +1578,8 @@ int zcache_autocreate_pool(unsigned int cli_id, unsigned int pool_id, bool eph)
 	pool->pool_id = pool_id;
 	tmem_new_pool(pool, flags);
 	cli->tmem_pools[pool_id] = pool;
-	pr_info("%s: AUTOcreated %s tmem poolid=%d, for remote client=%d\n",
-		namestr, flags & TMEM_POOL_PERSIST ? "persistent" : "ephemeral",
+	pr_info("AUTOcreated %s tmem poolid=%d, for remote client=%d\n",
+		flags & TMEM_POOL_PERSIST ? "persistent" : "ephemeral",
 		pool_id, cli_id);
 	ret = 0;
 out:
@@ -1914,8 +1904,7 @@ static int __init zcache_comp_init(void)
 	if (*zcache_comp_name != '\0') {
 		ret = crypto_has_comp(zcache_comp_name, 0, 0);
 		if (!ret)
-			pr_info("zcache: %s not supported\n",
-					zcache_comp_name);
+			pr_info("%s not supported\n", zcache_comp_name);
 	}
 	if (!ret)
 		strcpy(zcache_comp_name, "lzo");
@@ -1924,7 +1913,7 @@ static int __init zcache_comp_init(void)
 		ret = 1;
 		goto out;
 	}
-	pr_info("zcache: using %s compressor\n", zcache_comp_name);
+	pr_info("using %s compressor\n", zcache_comp_name);
 
 	/* alloc percpu transforms */
 	ret = 0;
@@ -1939,10 +1928,9 @@ static int __init zcache_init(void)
 {
 	int ret = 0;
 
-	if (ramster_enabled) {
-		namestr = "ramster";
+	if (ramster_enabled)
 		ramster_register_pamops(&zcache_pamops);
-	}
+
 #ifdef CONFIG_DEBUG_FS
 	zcache_debugfs_init();
 #endif
@@ -1953,13 +1941,12 @@ static int __init zcache_init(void)
 		tmem_register_pamops(&zcache_pamops);
 		ret = register_cpu_notifier(&zcache_cpu_notifier_block);
 		if (ret) {
-			pr_err("%s: can't register cpu notifier\n", namestr);
+			pr_err("can't register cpu notifier\n");
 			goto out;
 		}
 		ret = zcache_comp_init();
 		if (ret) {
-			pr_err("%s: compressor initialization failed\n",
-				namestr);
+			pr_err("compressor initialization failed\n");
 			goto out;
 		}
 		for_each_online_cpu(cpu) {
@@ -1974,7 +1961,7 @@ static int __init zcache_init(void)
 				sizeof(struct tmem_obj), 0, 0, NULL);
 	ret = zcache_new_client(LOCAL_CLIENT);
 	if (ret) {
-		pr_err("%s: can't create client\n", namestr);
+		pr_err("can't create client\n");
 		goto out;
 	}
 	zbud_init();
@@ -1983,14 +1970,13 @@ static int __init zcache_init(void)
 
 		register_shrinker(&zcache_shrinker);
 		old_ops = zcache_cleancache_register_ops();
-		pr_info("%s: cleancache enabled using kernel transcendent "
-			"memory and compression buddies\n", namestr);
+		pr_info("cleancache enabled using kernel transcendent memory and compression buddies\n");
 #ifdef ZCACHE_DEBUG
-		pr_info("%s: cleancache: ignorenonactive = %d\n",
-			namestr, !disable_cleancache_ignore_nonactive);
+		pr_info("cleancache: ignorenonactive = %d\n",
+			!disable_cleancache_ignore_nonactive);
 #endif
 		if (old_ops.init_fs != NULL)
-			pr_warn("%s: cleancache_ops overridden\n", namestr);
+			pr_warn("cleancache_ops overridden\n");
 	}
 	if (zcache_enabled && !disable_frontswap) {
 		struct frontswap_ops old_ops;
@@ -1998,15 +1984,14 @@ static int __init zcache_init(void)
 		old_ops = zcache_frontswap_register_ops();
 		if (frontswap_has_exclusive_gets)
 			frontswap_tmem_exclusive_gets(true);
-		pr_info("%s: frontswap enabled using kernel transcendent "
-			"memory and compression buddies\n", namestr);
+		pr_info("frontswap enabled using kernel transcendent memory and compression buddies\n");
 #ifdef ZCACHE_DEBUG
-		pr_info("%s: frontswap: excl gets = %d active only = %d\n",
-			namestr, frontswap_has_exclusive_gets,
+		pr_info("frontswap: excl gets = %d active only = %d\n",
+			frontswap_has_exclusive_gets,
 			!disable_frontswap_ignore_nonactive);
 #endif
 		if (old_ops.init != NULL)
-			pr_warn("%s: frontswap_ops overridden\n", namestr);
+			pr_warn("frontswap_ops overridden\n");
 	}
 	if (ramster_enabled)
 		ramster_init(!disable_cleancache, !disable_frontswap,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3L0KGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:06:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42406 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3L0KGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:06:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336941"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 8/8] perf tools: Enhancement for perf list with --raw-dump.
Date: Fri, 27 Dec 2013 18:03:34 -0500
Message-Id: <bb304df7c2d09b53e251a0d72c04c199e5198b39.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:56,
	Serialize complete at 2013/12/27 18:04:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we make --raw-dump work as a proper option, we need to
make the output of it more readable.

Example:
	# ./perf list kvmmmu --raw-dump
        kvmmmu:kvm_mmu_pagetable_walk kvmmmu:kvm_mmu_paging_element
         kvmmmu:kvm_mmu_set_accessed_bit kvmmmu:kvm_mmu_set_dirty_b
        it kvmmmu:kvm_mmu_walker_error kvmmmu:kv

Verification:
	# ./perf list kvmmmu --raw-dump
	kvmmmu:kvm_mmu_pagetable_walk
	kvmmmu:kvm_mmu_paging_element
	kvmmmu:kvm_mmu_set_accessed_bit
	kvmmmu:kvm_mmu_set_dirty_bit
	kvmmmu:kvm_mmu_walker_error
	kvmmmu:kvm_mmu_get_page
	kvmmmu:kvm_mmu_sync_page
	kvmmmu:kvm_mmu_unsync_page
	kvmmmu:kvm_mmu_prepare_zap_page
	kvmmmu:mark_mmio_spte
	kvmmmu:handle_mmio_page_fault
	kvmmmu:fast_page_fault

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9d7580b..ab2d146 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1035,7 +1035,7 @@ unsigned int print_tracepoint_events(const char *subsys_glob, const char *event_
 				continue;
 
 			if (name_only) {
-				printf("%s:%s ", sys_dirent.d_name, evt_dirent.d_name);
+				printf("%s:%s\n", sys_dirent.d_name, evt_dirent.d_name);
 				count++;
 				continue;
 			}
@@ -1177,7 +1177,7 @@ unsigned int print_hwcache_events(const char *event_glob, bool name_only)
 					continue;
 
 				if (name_only)
-					printf("%s ", name);
+					printf("%s\n", name);
 				else
 					printf("  %-50s [%s]\n", name,
 					       event_type_descriptors[PERF_TYPE_HW_CACHE]);
@@ -1210,7 +1210,7 @@ static unsigned print_symbol_events(const char *event_glob, unsigned type,
 			continue;
 
 		if (name_only) {
-			printf("%s ", syms->symbol);
+			printf("%s\n", syms->symbol);
 			count++;
 			continue;
 		}
-- 
1.8.2.1


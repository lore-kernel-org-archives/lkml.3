Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3L0KFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:05:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8856 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab3L0KFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:05:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336933"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/8] perf tools: Fix bug in 'perf list event_glob'.
Date: Fri, 27 Dec 2013 18:03:27 -0500
Message-Id: <5d72ccb261f7f30da7d2e0e05bf5c6352672c9a4.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:52,
	Serialize complete at 2013/12/27 18:04:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As what the usage showing, we can input a event_glob as an argument to list
all symbols. But it does not work well right now.

Example:
	# perf list kvmmmu

	List of pre-defined events (to be used in -e):

This patch make it work well as follows.

Verification:
	# perf list kvmmmu

	List of pre-defined events (to be used in -e):
	  kvmmmu:kvm_mmu_pagetable_walk                      [Tracepoint event]
	  kvmmmu:kvm_mmu_paging_element                      [Tracepoint event]
	  kvmmmu:kvm_mmu_set_accessed_bit                    [Tracepoint event]
	  kvmmmu:kvm_mmu_set_dirty_bit                       [Tracepoint event]
	  kvmmmu:kvm_mmu_walker_error                        [Tracepoint event]
	  kvmmmu:kvm_mmu_get_page                            [Tracepoint event]
	  kvmmmu:kvm_mmu_sync_page                           [Tracepoint event]
	  kvmmmu:kvm_mmu_unsync_page                         [Tracepoint event]
	  kvmmmu:kvm_mmu_prepare_zap_page                    [Tracepoint event]
	  kvmmmu:mark_mmio_spte                              [Tracepoint event]
	  kvmmmu:handle_mmio_page_fault                      [Tracepoint event]
	  kvmmmu:fast_page_fault                             [Tracepoint event]

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 094c28b..d887ea4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1236,6 +1236,8 @@ void print_events(const char *event_glob, bool name_only)
 
 	print_pmu_events(event_glob, name_only);
 
+	print_tracepoint_events(event_glob, NULL, name_only);
+
 	if (event_glob != NULL)
 		return;
 
@@ -1254,8 +1256,6 @@ void print_events(const char *event_glob, bool name_only)
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 		printf("\n");
 	}
-
-	print_tracepoint_events(NULL, NULL, name_only);
 }
 
 int parse_events__is_hardcoded_term(struct parse_events_term *term)
-- 
1.8.2.1


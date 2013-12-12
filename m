Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LLHlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:41:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3LLHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:41:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,469,1384272000"; 
   d="scan'208";a="9242846"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/6] perf tools: Fix bug in 'perf list event_glob'.
Date: Thu, 12 Dec 2013 15:39:28 -0500
Message-Id: <c4731f48122d4c5bcc618056670e3c31207884fa.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
References: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:07,
	Serialize complete at 2013/12/12 15:41:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example:
	# perf list kvmmmu

	List of pre-defined events (to be used in -e):

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
index 969cb8f..8acfa71 100644
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


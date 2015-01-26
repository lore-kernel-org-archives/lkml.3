Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbbAZRr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:47:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:52727 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbbAZRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:47:54 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/26] perf hists: Rename hist_entry__free to __delete
Date: Mon, 26 Jan 2015 14:47:07 -0300
Message-Id: <1422294449-12735-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No logic changes, just to be consistent.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-f7n5y0mvk6gew5185h6fg316@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c         | 2 +-
 tools/perf/tests/hists_cumulate.c | 2 +-
 tools/perf/tests/hists_output.c   | 2 +-
 tools/perf/util/hist.c            | 8 ++++----
 tools/perf/util/hist.h            | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1fd96c13f199..318ab9c3f0ba 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -430,7 +430,7 @@ static void hists__baseline_only(struct hists *hists)
 		next = rb_next(&he->rb_node_in);
 		if (!hist_entry__next_pair(he)) {
 			rb_erase(&he->rb_node_in, root);
-			hist_entry__free(he);
+			hist_entry__delete(he);
 		}
 	}
 }
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 8d110dec393e..18619966454c 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -140,7 +140,7 @@ static void del_hist_entries(struct hists *hists)
 		he = rb_entry(node, struct hist_entry, rb_node);
 		rb_erase(node, root_out);
 		rb_erase(&he->rb_node_in, root_in);
-		hist_entry__free(he);
+		hist_entry__delete(he);
 	}
 }
 
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index f5547610da02..b52c9faea224 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -106,7 +106,7 @@ static void del_hist_entries(struct hists *hists)
 		he = rb_entry(node, struct hist_entry, rb_node);
 		rb_erase(node, root_out);
 		rb_erase(&he->rb_node_in, root_in);
-		hist_entry__free(he);
+		hist_entry__delete(he);
 	}
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 182395546ddc..b4492de326ef 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -267,7 +267,7 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 			if (!n->filtered)
 				--hists->nr_non_filtered_entries;
 
-			hist_entry__free(n);
+			hist_entry__delete(n);
 		}
 	}
 }
@@ -290,7 +290,7 @@ void hists__delete_entries(struct hists *hists)
 		if (!n->filtered)
 			--hists->nr_non_filtered_entries;
 
-		hist_entry__free(n);
+		hist_entry__delete(n);
 	}
 }
 
@@ -941,7 +941,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	return cmp;
 }
 
-void hist_entry__free(struct hist_entry *he)
+void hist_entry__delete(struct hist_entry *he)
 {
 	zfree(&he->branch_info);
 	zfree(&he->mem_info);
@@ -981,7 +981,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 						iter->callchain,
 						he->callchain);
 			}
-			hist_entry__free(he);
+			hist_entry__delete(he);
 			return false;
 		}
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 46bd50344f85..9305580cd53e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,7 +119,7 @@ int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
 int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
-void hist_entry__free(struct hist_entry *);
+void hist_entry__delete(struct hist_entry *he);
 
 void hists__output_resort(struct hists *hists, struct ui_progress *prog);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
-- 
1.9.3


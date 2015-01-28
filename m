Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbbA1UwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:52:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbA1Uuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:40 -0500
Date: Wed, 28 Jan 2015 07:04:04 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-f7n5y0mvk6gew5185h6fg316@git.kernel.org>
Cc: jolsa@redhat.com, bp@suse.de, acme@redhat.com, fweisbec@gmail.com,
        efault@gmx.de, dzickus@redhat.com, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org, eranian@google.com,
        adrian.hunter@intel.com, hpa@zytor.com
Reply-To: eranian@google.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, adrian.hunter@intel.com,
        tglx@linutronix.de, mingo@kernel.org, dsahern@gmail.com,
        namhyung@kernel.org, fweisbec@gmail.com, acme@redhat.com, bp@suse.de,
        jolsa@redhat.com, efault@gmx.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Rename hist_entry__free to __delete
Git-Commit-ID: 6733d1bf7f77967747a5f85b832eaf4dba5999df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6733d1bf7f77967747a5f85b832eaf4dba5999df
Gitweb:     http://git.kernel.org/tip/6733d1bf7f77967747a5f85b832eaf4dba5999df
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 19 Dec 2014 12:31:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:31 -0300

perf hists: Rename hist_entry__free to __delete

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
index 1fd96c1..318ab9c 100644
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
index 8d110de..1861996 100644
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
index f554761..b52c9fa 100644
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
index 1823955..b4492de 100644
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
index 46bd503..9305580 100644
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

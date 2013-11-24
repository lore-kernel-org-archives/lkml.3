Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3KXGaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:30:13 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55102 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3KXG3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:29:42 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v2 4/5] perf diff: color the Ratio column
Date: Sun, 24 Nov 2013 11:50:24 +0530
Message-Id: <1385274025-30282-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  $ perf diff -c ratio

color the Ratio column using percent_color_snprintf().

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a54736c..be2550c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -786,6 +786,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		case COMPUTE_DELTA:
 			delta = pair->diff.period_ratio_delta;
 			break;
+		case COMPUTE_RATIO:
+			delta = pair->diff.period_ratio;
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -794,6 +797,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		case COMPUTE_DELTA:
 			delta = compute_delta(he, pair);
 			break;
+		case COMPUTE_RATIO:
+			delta = compute_ratio(he, pair);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -808,6 +814,11 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 					delta > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
 					pfmt, delta);
 			break;
+		case COMPUTE_RATIO:
+			scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
+			return percent_color_snprintf(hpp->buf, hpp->size,
+						pfmt, delta);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -823,6 +834,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
 	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
 }
 
+static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -1004,6 +1021,9 @@ static void data__hpp_register(struct data__file *d, int idx)
 	case PERF_HPP_DIFF__DELTA:
 		fmt->color = hpp__color_delta;
 		break;
+	case PERF_HPP_DIFF__RATIO:
+		fmt->color = hpp__color_ratio;
+		break;
 	default:
 		break;
 	}
-- 
1.8.5.rc0.5.g70ebc73.dirty


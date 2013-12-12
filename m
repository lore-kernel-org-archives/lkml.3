Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3LLHlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:41:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3LLHl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:41:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,469,1384272000"; 
   d="scan'208";a="9242844"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/6] perf tools: Introduce an OPT_BOOLEAN_HIDEN in to parse-options.h.
Date: Thu, 12 Dec 2013 15:39:26 -0500
Message-Id: <c326bf9735ac435a91773f9c1752c41566a2e2fc.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
References: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:06,
	Serialize complete at 2013/12/12 15:41:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/parse-options.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index cbf0149..f395a21a 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -84,7 +84,7 @@ typedef int parse_opt_cb(const struct option *, const char *arg, int unset);
  *   CALLBACKS can use it like they want.
  *
  * `set`::
- *   whether an option was set by the user
+ *   whether an option was set by the user.
  */
 struct option {
 	enum parse_opt_type type;
@@ -111,6 +111,8 @@ struct option {
 	{ .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), \
 	.value = check_vtype(v, bool *), .help = (h), \
 	.set = check_vtype(os, bool *)}
+#define OPT_BOOLEAN_HIDEN(s, l, v, h) \
+	{ .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = check_vtype(v, bool *), .flags = PARSE_OPT_HIDDEN, .help = (h)}
 #define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
 #define OPT_SET_UINT(s, l, v, h, i)  { .type = OPTION_SET_UINT, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h), .defval = (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
-- 
1.8.2.1


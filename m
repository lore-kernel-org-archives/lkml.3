Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaEAGbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:31:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaEAGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:31:44 -0400
Date: Wed, 30 Apr 2014 23:31:22 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-88080ce7f6af1ad99ad4b2825938411975910116@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <tip-9os1chjyz12upubfsjc71d99@git.kernel.org>
References: <tip-9os1chjyz12upubfsjc71d99@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move u64_swap union
Git-Commit-ID: 88080ce7f6af1ad99ad4b2825938411975910116
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

Commit-ID:  88080ce7f6af1ad99ad4b2825938411975910116
Gitweb:     http://git.kernel.org/tip/88080ce7f6af1ad99ad4b2825938411975910116
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 14 Apr 2014 17:38:39 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 29 Apr 2014 15:30:21 +0200

perf tools: Move u64_swap union

... to its single user's header, evsel.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/tip-9os1chjyz12upubfsjc71d99@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.h | 5 +++++
 tools/perf/util/types.h | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0c9926c..0c581d0 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -91,6 +91,11 @@ struct perf_evsel {
 	char			*group_name;
 };
 
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 #define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
 
 struct cpu_map;
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index c51fa6b..5f3689a 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -16,9 +16,4 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
-union u64_swap {
-	u64 val64;
-	u32 val32[2];
-};
-
 #endif /* __PERF_TYPES_H */

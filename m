Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3F1NQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:16:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:10827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3F1NQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:16:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="361090130"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/5] perf: fix broken union in perf_event_mmap_page
Date: Fri, 28 Jun 2013 16:22:17 +0300
Message-Id: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The capabilities bits must not be "union'ed" together.
Put them in a separate struct.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 include/uapi/linux/perf_event.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..19f6ee5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -375,9 +375,11 @@ struct perf_event_mmap_page {
 	__u64	time_running;		/* time event on cpu */
 	union {
 		__u64	capabilities;
-		__u64	cap_usr_time  : 1,
-			cap_usr_rdpmc : 1,
-			cap_____res   : 62;
+		struct {
+			__u64	cap_usr_time		: 1,
+				cap_usr_rdpmc		: 1,
+				cap_____res		: 62;
+		};
 	};
 
 	/*
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3GXD57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:57:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3GXD4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:56:17 -0400
Date: Tue, 23 Jul 2013 20:56:04 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix broken union in '
 struct perf_event_mmap_page'
Git-Commit-ID: 860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:56:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
Gitweb:     http://git.kernel.org/tip/860f085b74e9f0075de8140ed3a1e5b5e3e39aa8
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 28 Jun 2013 16:22:17 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 12:17:10 +0200

perf: Fix broken union in 'struct perf_event_mmap_page'

The capabilities bits must not be "union'ed" together.
Put them in a separate struct.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1372425741-1676-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 00d8274..0041aed 100644
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

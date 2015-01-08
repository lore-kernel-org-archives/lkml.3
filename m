Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbbAHRDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:03:48 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37391 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbbAHRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:03:45 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 8 Jan 2015 12:04:30 -0500 (EST)
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
cc: xmtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [patch] perf_event_open.2 clarify the PERF_FLAG_FD_* flags
Message-ID: <alpine.DEB.2.11.1501081201020.25399@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change clarifies the behavior of the PERF_FLAG_FD_OUTPUT and
PERF_FLAG_FD_NO_GROUP flags to perf_event_open(), and removes
the related FIXME comments.

While writing tests to validate the behavior of these flags I
discovered that PERF_FLAG_FD_OUTPUT has been broken since the
2.6.35 kernel release.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/man2/perf_event_open.2 b/man2/perf_event_open.2
index 8bde791..7181c29 100644
--- a/man2/perf_event_open.2
+++ b/man2/perf_event_open.2
@@ -149,14 +149,17 @@ then
 .BR execve (2).
 .TP
 .BR PERF_FLAG_FD_NO_GROUP
-.\" FIXME . The following sentence is unclear
-This flag allows creating an event as part of an event group but
-having no group leader.
-It is unclear why this is useful.
-.\" FIXME . So, why is it useful?
-.TP
-.BR PERF_FLAG_FD_OUTPUT
-This flag reroutes the output from an event to the group leader.
+This flag tells the event to ignore the
+.IR group_fd
+parameter except for the purpose of setting up output redirection
+using the
+.B PERF_FLAG_FD_OUTPUT
+flag.
+.TP
+.BR PERF_FLAG_FD_OUTPUT " (broken since Linux 2.6.35)."
+This flag re-routes the event's sampled output to instead
+be included in the mmap buffer of the event specified by
+.IR group_fd .
 .TP
 .BR PERF_FLAG_PID_CGROUP " (since Linux 2.6.39)."
 This flag activates per-container system-wide monitoring.

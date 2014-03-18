Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbaCRV0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44412 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaCRV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/13] perf tools: Update some code references in design.txt
Date: Tue, 18 Mar 2014 18:26:04 -0300
Message-Id: <1395177965-8879-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Update the names of some functions and enums in design.txt. The document
still has some stale information, but the motivation behind this patch
is to allow a developer to quickly grep and learn about the associated
structures.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395169804-1293-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/design.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 63a0e6f04a01..a28dca2582aa 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -18,7 +18,7 @@ underlying hardware counters.
 Performance counters are accessed via special file descriptors.
 There's one file descriptor per virtual counter used.
 
-The special file descriptor is opened via the perf_event_open()
+The special file descriptor is opened via the sys_perf_event_open()
 system call:
 
    int sys_perf_event_open(struct perf_event_attr *hw_event_uptr,
@@ -82,7 +82,7 @@ machine-specific.
 If 'raw_type' is 0, then the 'type' field says what kind of counter
 this is, with the following encoding:
 
-enum perf_event_types {
+enum perf_type_id {
 	PERF_TYPE_HARDWARE		= 0,
 	PERF_TYPE_SOFTWARE		= 1,
 	PERF_TYPE_TRACEPOINT		= 2,
@@ -95,7 +95,7 @@ specified by 'event_id':
  * Generalized performance counter event types, used by the hw_event.event_id
  * parameter of the sys_perf_event_open() syscall:
  */
-enum hw_event_ids {
+enum perf_hw_id {
 	/*
 	 * Common hardware events, generalized by the kernel:
 	 */
@@ -129,7 +129,7 @@ software events, selected by 'event_id':
  * physical and sw events of the kernel (and allow the profiling of them as
  * well):
  */
-enum sw_event_ids {
+enum perf_sw_ids {
 	PERF_COUNT_SW_CPU_CLOCK		= 0,
 	PERF_COUNT_SW_TASK_CLOCK	= 1,
 	PERF_COUNT_SW_PAGE_FAULTS	= 2,
@@ -230,7 +230,7 @@ these events are recorded in the ring-buffer (see below).
 The 'comm' bit allows tracking of process comm data on process creation.
 This too is recorded in the ring-buffer (see below).
 
-The 'pid' parameter to the perf_event_open() system call allows the
+The 'pid' parameter to the sys_perf_event_open() system call allows the
 counter to be specific to a task:
 
  pid == 0: if the pid parameter is zero, the counter is attached to the
@@ -260,7 +260,7 @@ The 'flags' parameter is currently unused and must be zero.
 
 The 'group_fd' parameter allows counter "groups" to be set up.  A
 counter group has one counter which is the group "leader".  The leader
-is created first, with group_fd = -1 in the perf_event_open call
+is created first, with group_fd = -1 in the sys_perf_event_open call
 that creates it.  The rest of the group members are created
 subsequently, with group_fd giving the fd of the group leader.
 (A single counter on its own is created with group_fd = -1 and is
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbaCSNJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:09:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933939AbaCSNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:08:58 -0400
Date: Wed, 19 Mar 2014 06:08:31 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-b68eebd1c2a539256e373123cdefabfd1986bfe2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1395169804-1293-1-git-send-email-artagnon@gmail.com>
References: <1395169804-1293-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Update some code references in design.txt
Git-Commit-ID: b68eebd1c2a539256e373123cdefabfd1986bfe2
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

Commit-ID:  b68eebd1c2a539256e373123cdefabfd1986bfe2
Gitweb:     http://git.kernel.org/tip/b68eebd1c2a539256e373123cdefabfd1986bfe2
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Tue, 18 Mar 2014 15:10:04 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:06 -0300

perf tools: Update some code references in design.txt

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
index 63a0e6f..a28dca2 100644
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

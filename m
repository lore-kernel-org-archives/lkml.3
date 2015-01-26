Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbbAZMMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:12:20 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43051 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbbAZMMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:12:17 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Javi Merino <javi.merino@arm.com>
Subject: [PATCH v4 0/3] Add array printing helpers to ftrace
Date: Mon, 26 Jan 2015 12:11:48 +0000
Message-Id: <1422274311-19738-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add a helper to the tracing framework to trace arrays.
Patch 1 adds them and patches 2 and 3 update the traceevent library to
parse them.  They've been tested with trace-cmd.

Changes since v3[0]:
  - use %zu to print size_t

Changes since v2:
  - Changed BUG() into a trace_seq_printf()
  - Add BUILD_BUG_ON() to chase mistakes in element sizes on build
  - Add patch 2 to avoid repeating code in patch 3.
  - print a warning in traeevent if the size of the array is not valid

[0] http://thread.gmane.org/gmane.linux.kernel/1869110

Dave Martin (1):
  tracing: Add array printing helpers

Javi Merino (2):
  tools lib traceevent: factor out allocating and processing args
  tools lib traceevent: Add support for __print_array()

 include/linux/ftrace_event.h       |   4 +
 include/trace/ftrace.h             |   9 +++
 kernel/trace/trace_output.c        |  44 ++++++++++
 tools/lib/traceevent/event-parse.c | 159 +++++++++++++++++++++++++++++--------
 tools/lib/traceevent/event-parse.h |   8 ++
 5 files changed, 193 insertions(+), 31 deletions(-)

-- 
1.9.1


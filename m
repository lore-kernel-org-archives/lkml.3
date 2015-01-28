Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbbA2C2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:28:02 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45671 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbbA2BsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:48:03 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Javi Merino <javi.merino@arm.com>
Subject: [PATCH v5 0/3] Add array printing helper to ftrace
Date: Wed, 28 Jan 2015 12:48:52 +0000
Message-Id: <1422449335-8289-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add a helper to the tracing framework to trace arrays.
Patch 1 add the helper and patches 2 and 3 update the traceevent
library to parse them.  They've been tested with trace-cmd.

Changes since v4[0]:
  - Specify the element size in __print_array() as bytes instead of
    bits

Changes since v3:
  - use %zu to print size_t

Changes since v2:
  - Changed BUG() into a trace_seq_printf()
  - Add BUILD_BUG_ON() to chase mistakes in element sizes on build
  - Add patch 2 to avoid repeating code in patch 3.
  - print a warning in traeevent if the size of the array is not valid

[0] http://thread.gmane.org/gmane.linux.kernel/1874250

Dave Martin (1):
  tracing: Add array printing helper

Javi Merino (2):
  tools lib traceevent: factor out allocating and processing args
  tools lib traceevent: Add support for __print_array()

 include/linux/ftrace_event.h       |   4 +
 include/trace/ftrace.h             |   9 +++
 kernel/trace/trace_output.c        |  44 +++++++++++
 tools/lib/traceevent/event-parse.c | 158 +++++++++++++++++++++++++++++--------
 tools/lib/traceevent/event-parse.h |   8 ++
 5 files changed, 192 insertions(+), 31 deletions(-)

-- 
1.9.1


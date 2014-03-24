Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaCXSOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:14:07 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:58934 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCXSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:14:05 -0400
From: Bharath Ravi <rbharath@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Bharath Ravi <rbharath@google.com>,
        Laurent Chavey <chavey@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Allow instances to independently set trace options.
Date: Mon, 24 Mar 2014 11:13:43 -0700
Message-Id: <1395684826-22931-1-git-send-email-rbharath@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the trace options are global, and shared among all
instances. This patchset allows instances to set certain trace options
independently, without affecting the global instance or other instances.
With this change, trace_overwrite will become an instance specific
option, while others remain global options.

This is achieved in three steps
1. Replace references to the global trace_flags mask with get/set
   accessors. This allows global trace_flags to be replaced by instance
   specific flags in step 2.
2. Replace the global trace_flags mask with instance specific
   trace_flags from the trace_array. Divide the set of trace options
   into global options, and instance options (that may be set independently
   by instances).
3. Make trace_overwrite an instance specific option.

Bharath Ravi (3):
  tracing: Replace usage of trace_flags with new accessors.
  tracing: Allow instances to have independent trace flags/trace
    options.
  tracing: Allow instances to independently set trace_overwrite.

 kernel/trace/blktrace.c              |   3 +-
 kernel/trace/ftrace.c                |   4 +-
 kernel/trace/trace.c                 | 127 +++++++++++++++++++++++++----------
 kernel/trace/trace.h                 |  48 ++++++-------
 kernel/trace/trace_events.c          |   2 +-
 kernel/trace/trace_functions_graph.c |  10 +--
 kernel/trace/trace_irqsoff.c         |   4 +-
 kernel/trace/trace_kdb.c             |   6 +-
 kernel/trace/trace_output.c          |   8 +--
 kernel/trace/trace_printk.c          |   8 +--
 kernel/trace/trace_sched_wakeup.c    |   3 +-
 kernel/trace/trace_syscalls.c        |   2 +-
 12 files changed, 143 insertions(+), 82 deletions(-)

-- 
1.9.1.423.g4596e3a


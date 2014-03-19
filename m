Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaCSWbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:31:41 -0400
Received: from mail.efficios.com ([78.47.125.74]:57738 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbaCSWbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:31:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v6 0/3] Tracepoint API simplification/cleanup
Date: Wed, 19 Mar 2014 18:30:59 -0400
Message-Id: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v6 of the tracepoint register/unregister API simplification.

Changes since v1:
- Adapt ftrace/perf callers,
- Update tracepoint.h macro,
- Build tested.

Changes since v2:
- Introduce for_each_tracepoint() iterator to allow listing the
  currently loaded tracepoints, for modules using coming/going
  notifiers to track tracepoints.

Changes since v3:
- Introduce module coming and going notifiers each with their own
  priority to ensure that other coming notifiers are called after, and
  coming notifiers are called before the tracepoint notifiers.
- Fix: move for_each_tracepoint() outside of the CONFIG_MODULE ifdef.

Changes since v4:
- Split tracepoints_mutex into two locks: tp_modlist_mutex, which
  protects the tracepoint list of modules, and a tracepoint_mutex, which
  protects the tracepoints per se. tracepoint_mutex nests inside
  tp_modlist_mutex.
- Introduce a tracepoint module notifier, to ensure consistency between
  iteration on tracepoints with for_each_tracepoint() and module coming
  and going notifications. This consistency is ensured by holding
  tp_modlist_mutex when calling the notifier and when iterating on the
  tracepoint module list.

Changes since v5:
- Remove tracepoint_add_old_probes within "Tracepoint cleanup: remove
  unused API functions" rather than in later patch.
- Remove struct tp_probes "old probes" list within "Tracepoint cleanup:
  remove unused API functions", as it is not needed anymore.
- Within "Tracepoint cleanup: remove unused API functions", simply add 
  the new module to tail of list, since there is no need to keep it 
  ordered anymore.

Still need testing.

Feedback is welcome,

Thanks!

Mathieu

Mathieu Desnoyers (3):
  Tracepoint cleanup: remove unused API functions
  Tracepoint API doc update: data argument
  Tracepoint: register/unregister struct tracepoint

 include/linux/ftrace_event.h |    1 +
 include/linux/tracepoint.h   |   62 ++--
 include/trace/ftrace.h       |    2 +
 kernel/trace/trace_events.c  |    8 +-
 kernel/tracepoint.c          |  707 ++++++++++++++----------------------------
 5 files changed, 268 insertions(+), 512 deletions(-)

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaKHUpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 15:45:09 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35793 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaKHUpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 15:45:08 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 0/3] trace: Use simpler seq_file functions
Date: Sat,  8 Nov 2014 21:42:09 +0100
Message-Id: <1415479332-25944-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using printf to print a simple string or puts to print a single
character is more expensive than it needs to be. Also, consecutive
puts calls can be replaced by a single call. These patches do this to
kernel/trace/, saving ~256 bytes of .text.

v2: Keep the original splitting of strings across lines.

Rasmus Villemoes (3):
  trace: Replace seq_printf by simpler equivalents
  trace: Merge consecutive seq_puts calls
  trace: Replace single-character seq_puts with seq_putc

 kernel/trace/ftrace.c                | 30 +++++++-------
 kernel/trace/trace.c                 | 78 ++++++++++++++++++------------------
 kernel/trace/trace_branch.c          | 32 +++++++--------
 kernel/trace/trace_events.c          |  4 +-
 kernel/trace/trace_events_trigger.c  |  6 +--
 kernel/trace/trace_functions.c       |  2 +-
 kernel/trace/trace_functions_graph.c | 28 ++++++-------
 kernel/trace/trace_kprobe.c          | 12 +++---
 kernel/trace/trace_printk.c          |  2 +-
 kernel/trace/trace_uprobe.c          |  4 +-
 10 files changed, 99 insertions(+), 99 deletions(-)

-- 
2.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3G3Lbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:31:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3G3Lby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:54 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=zeJKfhYyRjAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-1BqoTeSDHMA:10 a=VwQbUJbxAAAA:8 a=Ye5qyIouRdA9wprJUcgA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730112718.273490378@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 0/8] ftrace/tracing: Event file fixes and ftrace function hash fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg has been continuing his work on fixing a race between opening an
event file and deleting that same event. Using the i_private and event_mutex
to verify that the event still exists to solve the race.

A long standing bug on the ftrace hash accounting has finally been figured
out. When tracing a module that is removed and then reloaded, the function
filter hash gets out of sync with the function record's ref count which
causes a nasty warning and disabling of the function tracer.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 6fd52fce057b55cc1bba463e6f05536a76c058b4


Oleg Nesterov (6):
      tracing: Turn event/id->i_private into call->event.type
      tracing: Change event_enable/disable_read() to verify i_private != NULL
      tracing: Change event_filter_read/write to verify i_private != NULL
      tracing: Change f_start() to take event_mutex and verify i_private != NULL
      tracing: Introduce remove_event_file_dir()
      tracing: Change remove_event_file_dir() to clear "d_subdirs"->i_private

Steven Rostedt (Red Hat) (2):
      ftrace: Consolidate some duplicate code for updating ftrace ops
      ftrace: Clear module traced functions on unload module

----
 kernel/trace/ftrace.c              |   76 +++++++++++++++--
 kernel/trace/trace_events.c        |  159 ++++++++++++++++++++----------------
 kernel/trace/trace_events_filter.c |   17 ++--
 3 files changed, 164 insertions(+), 88 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3HBCz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:55:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3HBCzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:55:54 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=mmPURaGXKCMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=a2-eqYxt7PIA:10 a=R_v1DyYM07heA25ncR0A:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130802024924.999067099@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 01 Aug 2013 22:49:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 0/5] tracing: Final fixes for the race between open event file and deleting event
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

Is all the races that we are aware of between accessing event files and
deleting events covered by these patches?  I think I have them all.
Was there any patches that I missed, as there were a lot of threads
and lots of patches sent out, but not all were considered final.

I think I got the main ones that we decided on, but I'm not 100% sure as
my INBOX is overrun by too many activities. It may be a few months before
I go through them all.

I haven't pushed this to my for-next branch as I'm waiting for some feedback
from others in my queue. But I did push it to my ftrace/urgent branch
if you want to look at what will be going there. That branch may rebase
but I wanted to get these patches tested by Fengguang before sending
them to next. And I try not to rebase my for-next branch.

Thanks,

-- Steve


Oleg Nesterov (2):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)
      tracing: trace_remove_event_call() should fail if call/file is in use

Steven Rostedt (Red Hat) (3):
      tracing: Add comment to describe special break case in probe_remove_event_call()
      tracing/kprobes: Fail to unregister if probe event files are in use
      tracing/uprobes: Fail to unregister if probe event files are in use

----
 fs/debugfs/inode.c           |   69 ++++++++++++++----------------------------
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/trace_events.c  |   41 +++++++++++++++++++++++--
 kernel/trace/trace_kprobe.c  |   21 +++++++++----
 kernel/trace/trace_uprobe.c  |   51 +++++++++++++++++++++++--------
 5 files changed, 115 insertions(+), 69 deletions(-)

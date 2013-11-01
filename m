Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3KAV4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:56:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56337 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754553Ab3KAVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:03 -0400
Message-Id: <20131101215352.875376844@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 0/8] tools lib traceevent: Add changes from trace-cmd repo
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnaldo,

I was looking at the differences between the event-parse.c file in
trace-cmd compared to what's in tools/lib/traceevent, and discovered
that they have diverged a little. I pulled in several patches from
upstream and realized I had some clean ups that I would like to be
added too.

Maybe someday we can get a nice package that puts libtraceevent into
its own .so that can be used by all.

Anyway you can pull this or you can take the patches straight in.
I based off of Linus's 3.12-rc7.

-- Steve


Please pull the latest traceevent/updates tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
traceevent/updates

Head SHA1: 29ad23b00474c34e3b5040dda508c78d33a1a3eb
9ab76c2620680c767771f307e2dc5b152a153350


Howard Cochran (1):
      tools lib traceevent: Handle __print_hex(__get_dynamic_array(fieldname), len)

Steven Rostedt (2):
      tools lib traceevent: Add flags NOHANDLE and PRINTRAW to individual events
      tools lib traceevent: Add pevent_print_func_field() helper function

Steven Rostedt (Red Hat) (4):
      tools lib traceevent: Update printk formats when entered
      tools lib traceevent: If %s is a pointer, check printk formats
      tools lib traceevent: Have bprintk output the same as the kernel does
      tools lib traceevent: Check for spaces in character array

Yoshihiro YUNOMAE (1):
      tools lib traceevent: Add support for extracting trace_clock in report

----
 tools/lib/traceevent/event-parse.c | 165 ++++++++++++++++++++++++++++---------
 tools/lib/traceevent/event-parse.h |  14 +++-
 2 files changed, 136 insertions(+), 43 deletions(-)

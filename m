Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3IMORU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:17:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab3IMORT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:17:19 -0400
Date: Fri, 13 Sep 2013 10:16:38 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130913141638.GA6799@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@kernel.org>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913105637.GM31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913105637.GM31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:56:37PM +0200, Peter Zijlstra wrote:
 > On Thu, Sep 12, 2013 at 02:19:13PM -0400, Steven Rostedt wrote:
 > 
 > > > The good news is I can reproduce that very quickly.
 > > > (Apply http://paste.fedoraproject.org/38721/37890755 on top of trinity.git,
 > > >  and run ./trinity -l off -q -C32 -c inotify_init1 -c perf_event_open -c newlstat)
 > 
 > " The paste you are looking for does not exist "
 
bah. that sucks. appended below.

 > And that line on its own doesn't seem to do much.. its been running for
 > minutes now.
 > 
 > Or does 'quickly' mean something else?

without the diff, it'll use all kinds of fds. this diff hardwires it to just use
fd's from perf_event_open.  I'll hack up a command line switch to do this in a better
way at some point.

	Dave


diff --git a/fds.c b/fds.c
index cc1ca6d..f48c95e 100644
--- a/fds.c
+++ b/fds.c
@@ -119,6 +119,8 @@ static int get_new_random_fd(void)
 retry:
 	i = rand() % 6;
 
+	i = 3;
+
 	if (do_specific_proto == TRUE)
 		i = 1;
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3LJVma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:42:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3LJVm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:42:28 -0500
Date: Tue, 10 Dec 2013 16:41:43 -0500
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210214143.GG27373@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Darren Hart <dvhart@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210213431.GA6342@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:34:31PM +0100, Oleg Nesterov wrote:
 > On 12/10, Dave Jones wrote:
 > >
 > > On Tue, Dec 10, 2013 at 09:35:59PM +0100, Oleg Nesterov wrote:
 > >  >
 > >  > I am looking at the first message and I can't understand who stuck
 > >  > "at exit".
 > >  >
 > >  > The trace shows that the task with pid=10818 called sys_futex() ?
 > >  >
 > >  > Perhaps "exit" means the userspace paths?
 > >
 > > pid 1131 is wait()'ing for 10818 to exit
 > >
 > > pid 1130 is periodically sending SIGKILL to 10818 because it's gotten
 > > tired of waiting. 10818 is ignoring these because it's stuck in a loop
 > > somewhere in the kernel.
 > 
 > OK, thanks. So it doesn't return to user-space.
 > 
 > could you do
 > 
 > 	cd /sys/kernel/debug/tracing/
 > 	echo 10818 >> set_ftrace_pid
 > 	echo function_graph >> current_tracer
 > 	echo 1 >> tracing_on
 > 
 > and look into "trace" file to find out how exactly it loops?

http://codemonkey.org.uk/junk/trace

	Dave


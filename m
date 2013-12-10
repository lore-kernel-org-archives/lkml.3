Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3LJWVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:21:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31206 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860Ab3LJWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:21:52 -0500
Date: Tue, 10 Dec 2013 17:21:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210222150.GB6962@home.goodmis.org>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <20131210220946.GA6962@home.goodmis.org>
 <20131210221621.GD5050@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210221621.GD5050@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:16:21PM -0500, Dave Jones wrote:
> 46.GA6962@home.goodmis.org>
> User-Agent: Mutt/1.5.21 (2010-09-15)
> X-Scanned-By: MIMEDefang 2.68 on 10.5.11.23
> Sender:	linux-kernel-owner@vger.kernel.org
> Precedence: bulk
> List-ID: <linux-kernel.vger.kernel.org>
> X-Mailing-List:	linux-kernel@vger.kernel.org
> X-UID: 421684                                        
> Content-Length: 1147
> Status: O
> 
> On Tue, Dec 10, 2013 at 05:09:46PM -0500, Steven Rostedt wrote:
>  
>  > So you can do either:
>  > 
>  > trace-cmd record -p function -l get_user_pages_fast --func-stack sleep 5
>  > 
>  > Which will trace the get_user_pages_fast and spit out a full call trace.
> This gives me a 100M trace.dat, but trace show shows..
> 
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 0/0   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
> 
> and that's it.

Oh, if you use trace-cmd record. You need to do trace-cmd report.

The trace-cmd show, shows you what's in the trace file, which was for the
"manual" version.

Sorry for the confusion.

-- Steve

>  
>  > Or if you don't want to use trace-cmd, you can 

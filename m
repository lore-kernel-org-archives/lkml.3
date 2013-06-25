Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3FYN5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:57:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FYN5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:57:31 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qFnDjzJN3NQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RYGbRiS1lS8A:10 a=w11jlZJPSUzqkvazwxgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372168648.18733.200.camel@gandalf.local.home>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 25 Jun 2013 09:57:28 -0400
In-Reply-To: <20130625030721.GA8211@linux.intel.com>
References: <20130620201713.GV8211@linux.intel.com>
	 <20130623100920.GA19021@gmail.com>
	 <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
	 <20130624071718.GS9422@kernel.dk> <20130625001102.GA6623@home.goodmis.org>
	 <20130625030721.GA8211@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 23:07 -0400, Matthew Wilcox wrote:
> On Mon, Jun 24, 2013 at 08:11:02PM -0400, Steven Rostedt wrote:
> > What about hooking into the idle_balance code? That happens if we are
> > about to go to idle but before the full schedule switch to the idle
> > task.
> > 
> > 
> > In __schedule(void):
> > 
> > 	if (unlikely(!rq->nr_running))
> > 		idle_balance(cpu, rq);
> 
> That may be a great place to try it from the PoV of the scheduler, but are
> you OK with me threading a struct backing_dev_info * all the way through
> the scheduler to idle_balance()?  :-)

Well, there's other ways to pass data down besides parameters. You could
attach something to the task itself.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3FYALJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:11:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3FYALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:11:07 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=qFnDjzJN3NQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RYGbRiS1lS8A:10 a=0A6ZV8M8LoOsEL9mwdYA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Mon, 24 Jun 2013 20:11:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Matthew Wilcox <willy@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Message-ID: <20130625001102.GA6623@home.goodmis.org>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
 <20130624071718.GS9422@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624071718.GS9422@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:17:18AM +0200, Jens Axboe wrote:
> On Sun, Jun 23 2013, Linus Torvalds wrote:
> > 
> > You could try to do that either *in* the idle thread (which would take
> > the context switch overhead - maybe negating some of the advantages),
> > or alternatively hook into the scheduler idle logic before actually
> > doing the switch.
> 
> It can't happen in the idle thread. If you need to take the context
> switch, then you've negated pretty much all of the gain of the polled
> approach.

What about hooking into the idle_balance code? That happens if we are
about to go to idle but before the full schedule switch to the idle
task.


In __schedule(void):

	if (unlikely(!rq->nr_running))
		idle_balance(cpu, rq);

-- Steve


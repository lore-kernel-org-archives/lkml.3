Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab3JOOrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:47:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38340 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab3JOOrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:47:47 -0400
Date: Tue, 15 Oct 2013 07:47:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutorture.c: use scnprintf() instead of sprintf()
Message-ID: <20131015144732.GG9150@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5253C335.5050609@asianux.com>
 <20131013110518.GC5790@linux.vnet.ibm.com>
 <525BAD9F.6060406@asianux.com>
 <20131014112839.GO5790@linux.vnet.ibm.com>
 <525C9256.5010002@asianux.com>
 <525C9FAE.4090209@asianux.com>
 <20131015082613.GG5790@linux.vnet.ibm.com>
 <525D35E9.3000604@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D35E9.3000604@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101514-7182-0000-0000-000008BEA68A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 08:32:41PM +0800, Chen Gang wrote:
> On 10/15/2013 04:26 PM, Paul E. McKenney wrote:
> > On Tue, Oct 15, 2013 at 09:51:42AM +0800, Chen Gang wrote:
> >>> One simple way: using snprintf() instead of scnprintf() in the related
> >>> printing functions. Then call them with "buffer == NULL" to get buffer
> >>> size, next allocate it and call it again ...
> >>
> >> Oh, this simple way assumes the printing contents will not be changed
> >> during the 2 calls.
> > 
> > Indeed.  But can you make use of nr_cpu_ids, which is set at boot time
> > to the the maximum number of CPUs that the particular booting system
> > will ever be able to contain?  Keep in mind that you know the maximum
> > number of digits that an unsigned long will print in 32-bit and 64-bit
> > systems.
> 
> Yeah, that is a way for it. It seems you (related maintainer) like
> additional fix for it.
> 
> Hmm... I will try within this week (although I don't think it is quite
> necessary to me).
> 
> :-)

If you always ensure that the buffer is big enough, do you really need
the checking?

> >>> Hmm... it is only a test module, is it worth enough to try to make it
> >>> avoid truncation? If some members (quite few members) find truncation,
> >>> they can simply extend maximize buffer to avoid it when testing.
> >>>
> >>> But if we do not fix this bug, when memory overflow, the OS may not stop
> >>> immediately, then it will/may lead the testers to face various amazing
> >>> things (which is not quite easy to find root cause).
> > 
> > It might cause strange symptoms, but it is not bad practice to try
> > it anyway, especially when the code is unfamiliar.  After all, if the
> > strange systems appear on memory overflow, but do not appear if there
> > is no memory overflow, you have a pretty good idea what the cause .
> > Besides, there might be some other mechanism to prevent the problem.
> > Of course, there is no such mechanism in this particular case, but in
> > general it is more efficient to find that out quickly then to spend time
> > designing a solution that is not needed.
> 
> Excuse me, my English is not quite well, I am not quite understand your
> meaning.
> 
> I guess your meaning is: "after find a simple/acceptable solution, we
> can think of more, it may be more efficient".
> 
> If what I guess is correct, It is OK to me -- since at least, it is not
> an 'urgent' thing (for 'important' thing, your idea is more efficient,
> although for 'urgent' thing, it is not).

That is important as well -- the first solution you think of might not
be the right one.

My point is related.  If you believe you found a bug by inspection,
it is often worth testing to be sure.  Especially if the code in
question is at all complex.

							Thanx, Paul


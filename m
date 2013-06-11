Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3FKPWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:22:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3FKPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:22:49 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=BB1Q4bXugQK4TWUhWnEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370964165.9844.172.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Date: Tue, 11 Jun 2013 11:22:45 -0400
In-Reply-To: <20130611101401.GC5146@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <1370911480.9844.160.camel@gandalf.local.home>
	 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	 <51B6D76D.9090207@cn.fujitsu.com>
	 <20130611101401.GC5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 03:14 -0700, Paul E. McKenney wrote:
>  
> > Off-topic, although I am in this community for several years,
> > I am not exactly clear with this problem.
> > 
> > 1) In general case, which lock is the most competitive in the kernel? what it protects for?
> > 2) In which special case, which lock is the most competitive in the kernel? what it protects for?
> > 3) In general case, which list is the most hot list?
> > 4) In which special case, which list is the most hot list?
> 
> Others would know better than I, but mmap_sem has been called out as a

If the contention is with mmap_sem, then I doubt this is going to help
much, as that's a sleeping rw semaphore. Now, rw semaphores are
implemented with raw spinlocks, but I doubt that would be the main point
of contention, compared to the sleeping part.

-- Steve

> prime offender for some workloads.  There is of course some debate as
> to whether the fault lies mmap_sem or with the workloads.  There have
> been some efforts to solve this one on LKML, plus some in academia have
> worked on this as well:
> 



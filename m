Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab3IMOEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:04:30 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41421 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3IMOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:04:28 -0400
Date: Fri, 13 Sep 2013 16:04:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130913140422.GE4844@somewhere>
References: <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
 <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
 <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
 <20130912183023.GA25386@somewhere>
 <00000141179222e5-8a10141c-7b95-4204-853c-ab266fd08532-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141179222e5-8a10141c-7b95-4204-853c-ab266fd08532-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:45:55PM +0000, Christoph Lameter wrote:
> On Thu, 12 Sep 2013, Frederic Weisbecker wrote:
> 
> > So yeah it's a problem in theory. Now in practice, I have yet to be convinced because
> > this should be solved after a few iterations in /proc in most cases.
> 
> I have seen some drivers regularly spawning threads all over the machnine.
> This is a practical issue that I am addresing.
> >
> > Now the issue doesn't only concern kthreads but all tasks in the system.
> > If we really want to solve that race, then may be we can think of a kernel_parameter
> > that sets the initial affinity of init and then lets get it naturally inherited
> > through the whole tree.
> 
> This patch that we are discussing does exactly that.
> 

Indeed, I just looked that again and your cpu_kthread_mask actually also applies to init.
cpu_init_mask would be a better name I think.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3IMOmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:42:11 -0400
Received: from a14-78.smtp-out.amazonses.com ([54.240.14.78]:34663 "EHLO
	a14-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756208Ab3IMOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:42:10 -0400
X-Greylist: delayed 2834 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2013 10:42:10 EDT
Date: Fri, 13 Sep 2013 13:54:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <20130913092553.GL31370@twins.programming.kicks-ass.net>
Message-ID: <00000141179a5b1f-b94a8394-9e98-400c-ae7f-59cdcfce60a6-000000@email.amazonses.com>
References: <20130911220228.GB15367@somewhere> <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com> <20130912141625.GA23357@somewhere> <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere> <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com> <20130912151102.GB23839@somewhere> <alpine.DEB.2.02.1309121030390.21473@gentwo.org> <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
 <20130912183023.GA25386@somewhere> <20130913092553.GL31370@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.13-54.240.14.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > If we really want to solve that race, then may be we can think of a kernel_parameter
>
> No bloody kernel params. I'd much rather create a pointless kthread to
> act as usermodehelper parent that people can set context on (move it
> into cgroups, set affinity, whatever) so it automagically propagates to
> all userspace helper thingies.
>
> Is there anything other than usermodehelper we need to be concerned
> with? One that comes to mind would be unbound workqueue threads. Do we
> want to share the parent with usermodehelpers or have these two classes
> have different parents?

So you want to keep those silly racy move-all-threads-to-some-cpus scripts
around? A kernel parameter would allow a clean bootup with threads
starting out on the specific processors we want them to.

Also there is even more work ahead to deal with things like kswapd,
writeback threads, compaction and various other scanners that should also
be restricted. Mostly one thread per node is sufficient. This is not
simple to do from user space.




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab3CEQkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:40:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab3CEQkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:40:17 -0500
Date: Tue, 5 Mar 2013 17:35:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lai Jiangshan <eag0628@gmail.com>, linux-doc@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@sisk.pl,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lglock: add read-preference local-global rwlock
Message-ID: <20130305163522.GA4179@redhat.com>
References: <512CC509.1050000@linux.vnet.ibm.com> <CACvQF50UgiqPpDk3HCmV86zKSf6tPjqr0bZowfPEOJs0g0r0MQ@mail.gmail.com> <512D0D67.9010609@linux.vnet.ibm.com> <CACvQF53ph2ixdM-otzetjM5cR+2kcZj6sckOp3TnzzA_x-EZ8w@mail.gmail.com> <512E7879.20109@linux.vnet.ibm.com> <5130E8E2.50206@cn.fujitsu.com> <20130301182854.GA3631@redhat.com> <CANN689HEW=b5S93J27p+rBX-5m7jkW4FER=eHDCp7OgMaTWLPw@mail.gmail.com> <20130302170656.GB29769@redhat.com> <51361540.3060603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51361540.3060603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Lai Jiangshan wrote:
>
> On 03/03/13 01:06, Oleg Nesterov wrote:
> > On 03/02, Michel Lespinasse wrote:
> >>
> >> My version would be slower if it needs to take the
> >> slow path in a reentrant way, but I'm not sure it matters either :)
> >
> > I'd say, this doesn't matter at all, simply because this can only happen
> > if we race with the active writer.
>
> It can also happen when interrupted. (still very rarely)
>
> arch_spin_trylock()
> 	------->interrupted,
> 		__this_cpu_read() returns 0.
> 		arch_spin_trylock() fails
> 		slowpath, any nested will be slowpath too.
> 		...
> 		..._read_unlock()
> 	<-------interrupt
> __this_cpu_inc()
> ....

Yes sure. Or it can take the local lock after we already take the global
fallback_lock.

But the same can happen with FALLBACK_BASE, just because we need to take
a lock (local or global) first, then increment the counter.

> (I worries to much. I tend to remove FALLBACK_BASE now, we should
> add it only after we proved we needed it, this part is not proved)

Agreed, great ;)

Oleg.


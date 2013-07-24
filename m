Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3GXQqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:46:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58672 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3GXQqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:46:10 -0400
Date: Wed, 24 Jul 2013 17:46:07 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130724164607.GF12572@e103034-lin>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <20130713102350.GA8067@MacBook-Pro.local>
 <20130715203922.GD23818@dyad.programming.kicks-ass.net>
 <20130716124248.GB10036@arm.com>
 <51E5655C.7050304@linux.intel.com>
 <20130717141426.GG27948@arm.com>
 <20130724135011.GE12572@e103034-lin>
 <51EFEFD4.4020808@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51EFEFD4.4020808@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Jul 2013 16:46:07.0293 (UTC) FILETIME=[4B26E6D0:01CE888D]
X-MC-Unique: 113072417460801901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:16:36PM +0100, Arjan van de Ven wrote:
> 
> > Given that the power topology is taken into account, a sort
> > left/right-like mechanism would only help performance insensitive tasks
> > on big.LITTLE. Performance sensitive tasks that each can use more than
> > a little cpu should move in the opposite direction. Well, directly to a
> > big cpu, even if some little cpus are idle.
> >
> > It can be discussed whether smaller performance sensitive tasks that
> > would fit on a little cpu should be put on a little or big cpu. That
> > would depend on the nature of the task and if other tasks depend on it.
> 
> yeah that makes it fun
> 
> just a question for my education; is there overlap between big and little?
> meaning, is the "highest speed of little" as fast, or faster than "lowest speed of big"
> or are those strictly disjoint?
> 
> (if there's overlap that gives some room for the scheduler to experiment)
> 

It is implementation dependent. And it depends on how you define
performance :-)

That is hardly an answer to your question.

The big and little uarchs are quite different and typically support
different frequencies. For memory bound tasks there is more likely to be
an overlap than for cpu intensive tasks.

I would expect performance to be disjoint for most tasks. If there was
an overlap, the big would probably be less power efficient (as in
energy/instruction) than the little so you would prefer to run on the
little anyway.

In what way would you use the overlap?


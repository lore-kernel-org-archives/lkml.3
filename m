Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaJVQhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:37:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaJVQht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:37:49 -0400
Date: Wed, 22 Oct 2014 18:37:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>, cl@linux.com
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141022163743.GI21513@worktop.programming.kicks-ass.net>
References: <1413800145.19914.23.camel@tkhai>
 <20141020144757.GA10939@redhat.com>
 <20141020165614.GA16373@redhat.com>
 <20141020182748.GA20424@redhat.com>
 <54456E26.2000103@yandex.ru>
 <20141020205006.GA2500@redhat.com>
 <20141021094558.GQ23531@worktop.programming.kicks-ass.net>
 <20141021190335.GA12851@redhat.com>
 <20141022090954.GF12706@worktop.programming.kicks-ass.net>
 <20141022161450.GA27607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022161450.GA27607@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 06:14:50PM +0200, Oleg Nesterov wrote:
> Hmm. so perhaps I misunderstood your concern...
> 
> Do you mean that on !x86 a plain LOAD can "corrupt" the memory as it seen
> from another vaddr?

I'm not sure. Stores for sure, loads I'm not sure about.

I suspect loads are OK, the aliasing cacheline will be !modified and
therefore later eviction should discard (not write back). But like said,
I'm not at all sure.

I would hesitate to put such assumptions into generic code -- although
it appears we already have.

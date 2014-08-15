Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaHOJhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:37:39 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:57098 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaHOJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:37:38 -0400
Message-ID: <1408095453.5567.6.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Date: Fri, 15 Aug 2014 11:37:33 +0200
In-Reply-To: <20140815062819.GY19379@twins.programming.kicks-ass.net>
References: <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com>
	 <20140813133526.1eb5526f@cuia.bos.redhat.com>
	 <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com>
	 <20140813184511.GA9663@redhat.com>
	 <20140813170324.544aaf2d@cuia.bos.redhat.com>
	 <20140814132239.GA24465@redhat.com> <20140814174849.GA5091@redhat.com>
	 <1408079971.5536.37.camel@marge.simpson.net>
	 <20140815062819.GY19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-15 at 08:28 +0200, Peter Zijlstra wrote: 
> On Fri, Aug 15, 2014 at 07:19:31AM +0200, Mike Galbraith wrote:
> > For the N threads doing this on N cores case, seems rq->lock hammering
> > will still be a source of major box wide pain.  Is there any correctness
> > reason to add up unaccounted ->on_cpu beans, or is that just value
> > added?  
> 
> That delta can be arbitrarily large with nohz_full. And without
> nohz_full the error is nr_cpus*TICK_NSEC, which I bet is larger than the
> reported clock resolution.
> 
> Having a non-constant error bound is annoying for you never quite know
> what to expect.

Ah, yeah, that could get rather large.

> Also; why do we care about PROCESS_CPUTIME? People should really not use
> it. What are the 'valid' usecases you guys care about?

I don't care much, said "don't do that" before I saw a similar big box
problem had popped up with times().

-Mike


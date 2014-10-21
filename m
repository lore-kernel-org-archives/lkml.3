Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaJURZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:25:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbaJURZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:25:35 -0400
Date: Tue, 21 Oct 2014 19:25:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
Message-ID: <20141021172527.GH3219@twins.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141021162340.GA5508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021162340.GA5508@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:23:40PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > My Ivy Bridge EP (2*10*2) has a ~58% improvement in pagefault throughput:
> > 
> > PRE:
> >        149,441,555      page-faults                  ( +-  1.25% )
> >
> > POST:
> >        236,442,626      page-faults                  ( +-  0.08% )
> 
> > My Ivy Bridge EX (4*15*2) has a ~78% improvement in pagefault throughput:
> > 
> > PRE:
> >        105,789,078      page-faults                 ( +-  2.24% )
> >
> > POST:
> >        187,751,767      page-faults                 ( +-  2.24% )
> 
> I guess the 'PRE' and 'POST' numbers should be flipped around?

Nope, its the number of page-faults serviced in a fixed amount of time
(60 seconds), therefore higher is better.

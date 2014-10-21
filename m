Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbaJURPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:15:19 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:43489 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbaJURPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:15:17 -0400
Date: Tue, 21 Oct 2014 20:09:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
Message-ID: <20141021170948.GA25964@node.dhcp.inet.fi>
References: <20141020215633.717315139@infradead.org>
 <20141021162340.GA5508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021162340.GA5508@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
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

I think it's faults per second.

It would be interesting to see if the patchset affects non-condended case.
Like a one-threaded workload.

-- 
 Kirill A. Shutemov

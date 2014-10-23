Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaJWLEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:04:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaJWLEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:04:49 -0400
Date: Thu, 23 Oct 2014 13:04:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        dave@stgolabs.net, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
Message-ID: <20141023110438.GQ21513@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141021162340.GA5508@gmail.com>
 <20141021170948.GA25964@node.dhcp.inet.fi>
 <20141021175603.GI3219@twins.programming.kicks-ass.net>
 <5448DB05.5050803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5448DB05.5050803@cn.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 06:40:05PM +0800, Lai Jiangshan wrote:
> On 10/22/2014 01:56 AM, Peter Zijlstra wrote:
> > On Tue, Oct 21, 2014 at 08:09:48PM +0300, Kirill A. Shutemov wrote:
> >> It would be interesting to see if the patchset affects non-condended case.
> >> Like a one-threaded workload.
> > 
> > It does, and not in a good way, I'll have to look at that... :/
> 
> Maybe it is blamed to find_vma_srcu() that it doesn't take the advantage of
> the vmacache_find() and cause more cache-misses.

Its what I thought initially, I tried doing perf record with and
without, but then I ran into perf diff not quite working for me and I've
yet to find time to kick that thing into shape.

> Is it hard to use the vmacache in the find_vma_srcu()?

I've not had time to look at it.

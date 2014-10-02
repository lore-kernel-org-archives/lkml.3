Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaJBM4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:56:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:56360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaJBM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:56:41 -0400
Date: Thu, 2 Oct 2014 14:56:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: RFC: get_user_pages_locked|unlocked to leverage VM_FAULT_RETRY
Message-ID: <20141002125638.GE6324@worktop.programming.kicks-ass.net>
References: <20140926172535.GC4590@redhat.com>
 <20141001153611.GC2843@worktop.programming.kicks-ass.net>
 <20141002123117.GB2342@redhat.com>
 <20141002125052.GF2849@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002125052.GF2849@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:50:52PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 02, 2014 at 02:31:17PM +0200, Andrea Arcangeli wrote:
> > On Wed, Oct 01, 2014 at 05:36:11PM +0200, Peter Zijlstra wrote:
> > > For all these and the other _fast() users, is there an actual limit to
> > > the nr_pages passed in? Because we used to have the 64 pages limit from
> > > DIO, but without that we get rather long IRQ-off latencies.
> > 
> > Ok, I would tend to think this is an issue to solve in gup_fast
> > implementation, I wouldn't blame or modify the callers for it.
> > 
> > I don't think there's anything that prevents gup_fast to enable irqs
> > after certain number of pages have been taken, nop; and disable the
> > irqs again.
> > 
> 
> Agreed, I once upon a time had a patch set converting the 2 (x86 and
> powerpc) gup_fast implementations at the time, but somehow that never
> got anywhere.
> 
> Just saying we should probably do that before we add callers with
> unlimited nr_pages.

https://lkml.org/lkml/2009/6/24/457

Clearly there's more work these days. Many more archs grew a gup.c

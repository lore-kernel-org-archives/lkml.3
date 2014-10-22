Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaJVTzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:55:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:60361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbaJVTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:55:37 -0400
Date: Wed, 22 Oct 2014 21:55:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        jmario@redhat.com, rfowles@redhat.com
Subject: Re: perf:  Translating mmap2 ids into socket info?
Message-ID: <20141022195535.GL21513@worktop.programming.kicks-ass.net>
References: <20141022162026.GG135937@redhat.com>
 <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
 <20141022174226.GF4160@kernel.org>
 <20141022181553.GA14687@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022181553.GA14687@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 03:15:53PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 22, 2014 at 02:42:26PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Wed, Oct 22, 2014 at 06:45:10PM +0200, Peter Zijlstra escreveu:
> > > On Wed, Oct 22, 2014 at 12:20:26PM -0400, Don Zickus wrote:
> > > > Our cache-to-cache tool noticed the slowdown but we couldn't understand
> > > > why because we had falsely assumed the memory was allocated on the local
> > > > node but instead it was on the remote node.
>   
> > > But in general, you can never say for user memory, since that has the
> > > process page table mapping in between, the user virtual address is
> > > unrelated to backing (and can change frequently and without
> > > notification).
>   
> > > Therefore the mmap(2) information is useless for this, it only concerns
> > > user memory.
>  
> > So what you are saying is that it is difficult to have some sort of
> > mechanism that an mmap moved from one node to another, when that
> > happens, i.e. a new tracepoint for that?
> 
> Humm, so, after reading a bit more, I see that we can figure out which
> ranges are in which NUMA nodes (like shown in dmesg), and we have the
> phys addr, so is this just a matter of perf tooling complement the
> information the kernel provides on mmap2 (and the hardware provides on
> those events)?

We explicitly do not expose the phys address of user space pages. So
nope.

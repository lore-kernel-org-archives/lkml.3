Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3I0OfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:35:11 -0400
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:54830 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753987Ab3I0OfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:35:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:
X-HE-Tag: judge64_484c3fbe2d720
X-Filterd-Recvd-Size: 2946
Message-ID: <1380292495.17366.106.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Make the memory barrier test noisier
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Jason Low <jason.low2@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Date: Fri, 27 Sep 2013 07:34:55 -0700
In-Reply-To: <20130927142605.GC15690@laptop.programming.kicks-ass.net>
References: <1380228059.2170.10.camel@buesod1.americas.hpqcorp.net>
	 <1380229794.2602.36.camel@j-VirtualBox>
	 <1380231702.3467.85.camel@schen9-DESK>
	 <1380235333.3229.39.camel@j-VirtualBox>
	 <1380236265.3467.103.camel@schen9-DESK> <20130927060213.GA6673@gmail.com>
	 <20130927112323.GJ3657@laptop.programming.kicks-ass.net>
	 <1380289495.17366.91.camel@joe-AO722>
	 <20130927134802.GA15690@laptop.programming.kicks-ass.net>
	 <1380291257.17366.103.camel@joe-AO722>
	 <20130927142605.GC15690@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 16:26 +0200, Peter Zijlstra wrote:
> On Fri, Sep 27, 2013 at 07:14:17AM -0700, Joe Perches wrote:
> > Peter Zijlstra prefers that comments be required near uses
> > of memory barriers.
> > 
> > Change the message level for memory barrier uses from a
> > --strict test only to a normal WARN so it's always emitted.
> > 
> > This might produce false positives around insertions of
> > memory barriers when a comment is outside the patch context
> > block.
> 
> One would argue that in that case they're too far away in any case :-)
> 
> > And checkpatch is still stupid, it only looks for existence
> > of any comment, not at the comment content.
> 
> Could we try and alleviate this by giving a slightly more verbose
> warning?

> Maybe something like:
> 
>  memory barrier without comment; please refer to the pairing barrier and
>  describe the ordering requirements.

That would make it seem as if all barriers are SMP no?

Maybe just refer to Documentation/memory-barriers.txt
and/or say something like "please document appropriately"



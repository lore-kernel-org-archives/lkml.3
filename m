Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaE2XkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:40:19 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55356 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaE2XkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:40:18 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 30 May 2014 08:40:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Message-ID: <20140529234051.GK10092@bbox>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
 <1401260039-18189-2-git-send-email-minchan@kernel.org>
 <CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
 <20140528223142.GO8554@dastard>
 <CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
 <20140529013007.GF6677@dastard>
 <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
 <20140529072633.GH6677@dastard>
 <CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Thu, May 29, 2014 at 08:24:49AM -0700, Linus Torvalds wrote:
> On Thu, May 29, 2014 at 12:26 AM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > What concerns me about both __alloc_pages_nodemask() and
> > kernel_map_pages is that when I look at the code I see functions
> > that have no obvious stack usage problem. However, the compiler is
> > producing functions with huge stack footprints and it's not at all
> > obvious when I read the code. So in this case I'm more concerned
> > that we have a major disconnect between the source code structure
> > and the code that the compiler produces...
> 
> I agree. In fact, this is the main reason that Minchan's call trace
> and this thread has actually convinced me that yes, we really do need
> to make x86-64 have a 16kB stack (well, 16kB allocation - there's
> still the thread info etc too).
> 
> Usually when we see the stack-smashing traces, they are because
> somebody did something stupid. In this case, there are certainly
> stupid details, and things I think we should fix, but there is *not*
> the usual red flag of "Christ, somebody did something _really_ wrong".
> 
> So I'm not in fact arguing against Minchan's patch of upping
> THREAD_SIZE_ORDER to 2 on x86-64, but at the same time stack size does
> remain one of my "we really need to be careful" issues, so while I am
> basically planning on applying that patch, I _also_ want to make sure
> that we fix the problems we do see and not just paper them over.

So, should I resend a patch w/o RFC in subject but with Acked-by from Dave?
Or, you will do it by yourself?

> 
> The 8kB stack has been somewhat restrictive and painful for a while,
> and I'm ok with admitting that it is just getting _too_ damn painful,
> but I don't want to just give up entirely when we have a known deep
> stack case.
> 
>                       Linus
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim

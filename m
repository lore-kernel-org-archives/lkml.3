Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3GWIRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:17:33 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:57551 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3GWIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:17:31 -0400
Date: Tue, 23 Jul 2013 10:17:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH] mm: vmstats: tlb flush counters
Message-ID: <20130723081727.GB16088@gmail.com>
References: <20130716234438.C792C316@viggo.jf.intel.com>
 <CAC4Lta1mHixqfRSJKpydH3X9M_nQPCY3QSD86Tm=cnQ+KxpGYw@mail.gmail.com>
 <51E95932.5030902@sr71.net>
 <20130722100605.GA1148@gmail.com>
 <51ED64FC.8090104@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED64FC.8090104@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> On 07/22/2013 03:06 AM, Ingo Molnar wrote:
> > Btw., would be nice to also integrate these VM counters into perf as well, 
> > as an instrumentation variant/option.
> > 
> > It could be done in an almost zero overhead fashion using jump-labels I 
> > think.
> > 
> > [ Just in case someone is bored to death and is looking for an interesting 
> >   side project ;-) ]
> 
> I'd actually been thinking about making them in to tracepoints, but the 
> tracepoint macros seem to create #include messes if you try to use them 
> in very common headers.
> 
> Agree it would be an interesting side project, though. :)

Yes, tracepoints was what I was thinking about, it would allow easy 
integration into perf [and it's useful even without any userspace side] - 
as long as:

 - the tracepoints trace the counts/sums, not just the events themselves
 - when the tracepoints are not active the VM counts are still maintained 
   separately

I.e. the existing VM counts and its extraction facilities are not impacted 
in any way, just a new channel of instrumentation is provided - 
jump-label/static-key optimized by virtue of being tracepoints.

Thanks,

	Ingo

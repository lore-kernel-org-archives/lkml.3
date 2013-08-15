Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab3HOPB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:01:59 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:50657 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab3HOPB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:01:58 -0400
Date: Thu, 15 Aug 2013 12:01:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130815150150.GB1940@ghostprotocols.net>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
 <20130815132637.GE1861@ghostprotocols.net>
 <20130815142925.GG19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815142925.GG19750@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 15, 2013 at 04:29:25PM +0200, Andi Kleen escreveu:
> > >   * Update various tracking values we maintain to print
> > >   * more semantic information such as miss/hit ratios,
> > > @@ -283,8 +340,12 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
> > >  		update_stats(&runtime_nsecs_stats[0], count[0]);
> > >  	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
> > >  		update_stats(&runtime_cycles_stats[0], count[0]);
> > > -	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
> > > -		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
> > 
> > Why remove the test for HW_STALLED_CYCLES_FRONTEND?
> 
> Hmm that was probably a merge error.
> 
> I'll fix & resend.

Ok
 
> > Got it why it doesn't need to account for the '{' in the array ;-)
> > 
> > While this works and isn't in any fast path, I find it ugly with all
> > this looping in nth_evsel.
> > 
> > Why not:
> > 
> > 	} else if (evsel->idx == T_CYCLES_IN_TX)) &&
> > 
> > ? I guess this works as you expect, no?
> 
> I had some problems with people using -T, but also setting custom
> events, that is why I added the extra comparison

But it'd fail the same, as if you go from the first entry in the
evlist->entries linked list, looping while incrementing a number, that
number should match the nth entry ->idx member.

I'll try to experiment with this when you resend with the parts you
agreed should be changed.
 
> The event lists are small enough that it's not really noticeable.
> I suppose could set up an array once.

Its not about performance hits, they are negligible, but about using
something that should provide equivalent results.

- Arnaldo

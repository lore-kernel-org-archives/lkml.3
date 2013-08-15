Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3HOO32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:29:28 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43020 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3HOO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:29:27 -0400
Date: Thu, 15 Aug 2013 16:29:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130815142925.GG19750@two.firstfloor.org>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
 <20130815132637.GE1861@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815132637.GE1861@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   * Update various tracking values we maintain to print
> >   * more semantic information such as miss/hit ratios,
> > @@ -283,8 +340,12 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
> >  		update_stats(&runtime_nsecs_stats[0], count[0]);
> >  	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
> >  		update_stats(&runtime_cycles_stats[0], count[0]);
> > -	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
> > -		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
> 
> Why remove the test for HW_STALLED_CYCLES_FRONTEND?

Hmm that was probably a merge error.

I'll fix & resend.

> Got it why it doesn't need to account for the '{' in the array ;-)
> 
> While this works and isn't in any fast path, I find it ugly with all
> this looping in nth_evsel.
> 
> Why not:
> 
> 	} else if (evsel->idx == T_CYCLES_IN_TX)) &&
> 
> ? I guess this works as you expect, no?

I had some problems with people using -T, but also setting custom
events, that is why I added the extra comparison

The event lists are small enough that it's not really noticeable.
I suppose could set up an array once.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

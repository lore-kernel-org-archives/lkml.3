Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaENRCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:02:45 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:48178 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaENRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:02:43 -0400
Date: Wed, 14 May 2014 13:02:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140514170238.GB15690@htj.dyndns.org>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514140034.GM30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:00:34PM +0200, Peter Zijlstra wrote:
> Does something like the below help any? I noticed those things (cpudl
> and cpupri) had [NR_CPUS] arrays, which is always 'fun'.
> 
> The below is a mostly no thought involved conversion of cpudl which
> boots, I'll also do cpupri and then actually stare at the algorithms to
> see if I didn't make any obvious fails.

Yeah, should avoid large allocation on reasonably sized machines and I
don't think 2k CPU machines suspend regularly.  Prolly good / safe
enough for -stable port?  It'd be still nice to avoid allocations if
possible during online tho given that the operation happens while mm
is mostly crippled.

Thanks.

-- 
tejun

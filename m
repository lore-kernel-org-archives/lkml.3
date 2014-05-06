Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbaEFUjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:39:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:34652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaEFUjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:39:20 -0400
Date: Tue, 6 May 2014 22:39:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140506203916.GQ17778@laptop.programming.kicks-ass.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
 <1399011219.5233.55.camel@marge.simpson.net>
 <53633B81.1080403@redhat.com>
 <1399016273.5233.94.camel@marge.simpson.net>
 <536379D0.8070306@redhat.com>
 <1399030032.5233.142.camel@marge.simpson.net>
 <5363B793.9010208@redhat.com>
 <20140506115448.GH11096@twins.programming.kicks-ass.net>
 <536943C9.4030502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <536943C9.4030502@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:19:21PM -0400, Rik van Riel wrote:
> On 05/06/2014 07:54 AM, Peter Zijlstra wrote:
> > On Fri, May 02, 2014 at 11:19:47AM -0400, Rik van Riel wrote:
> >> As an aside, it also looks like SD_BALANCE_WAKE is set on all domains
                                     ^^^^^^^^^^^^^^^

> >> of a NUMA system by default, so even the non-affine wakeup will end
> >> up looking for the lowest load NUMA node to start up on.
> > 
> > I can't find it being set on anything by default.
> 
>                 .flags                  = 1*SD_LOAD_BALANCE
>                                         | 1*SD_BALANCE_NEWIDLE
>                                         | 0*SD_BALANCE_EXEC
>                                         | 0*SD_BALANCE_FORK
>                                         | 0*SD_BALANCE_WAKE

                                            ^

last time I checked 0*x was still 0.

>                                         | 0*SD_WAKE_AFFINE
>                                         | 0*SD_SHARE_CPUPOWER
>                                         | 0*SD_SHARE_PKG_RESOURCES
>                                         | 1*SD_SERIALIZE
>                                         | 0*SD_PREFER_SIBLING
>                                         | 1*SD_NUMA
>                                         | sd_local_flags(level)
> 
> 
> static inline int sd_local_flags(int level)
> {
>         if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
>                 return 0;
> 
>         return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
> }

No BALANCE_WAKE there

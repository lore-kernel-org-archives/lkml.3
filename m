Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaAFODj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:03:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaAFODi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:03:38 -0500
Message-ID: <1389016976.5536.10.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/auto_group: fix consume memory even if add
 'noautogroup' in the cmdline
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 15:02:56 +0100
In-Reply-To: <20140106121719.GH31570@twins.programming.kicks-ass.net>
References: <1388139751-19632-1-git-send-email-liwanp@linux.vnet.ibm.com>
	 <20140106121719.GH31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:vd0z/8Z1TsJps7mepPNryOdJgdwheyvhwzaP45N52JK
 sdmLPp5dHTLNGXijmj+qXAd18I1uxt4GqrbAdGjDsevcxchRmb
 h8BJQrD3dmeZa3IMGoLN+FcL/wu9xeLVOvyj28YlB6ltdKa9EY
 sxrcfV4H6vG2CG+A2uvqCNd2SbYH/OpQBFC+H4mNZD/dEp+nbQ
 nMERDkWUtGZUbJEHQPR07euZUBE7SHBmFKWZhYdG983f1s2Owm
 gIR/ZWnnqwsvj/eQJXVqkVyDbxrVT/PeU5v16jfSsEHAZbYaBp
 dUuvKySDJlqPXwqcVXxvbmOMu+vyolk8AYQyXzouEBSnw9G4Mt
 CGQy1RjXAbOY0NjQxpmlJzF3HGt8zVTsGRp4kod/LpPD773bQZ
 +m51CiMJk0+1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 13:17 +0100, Peter Zijlstra wrote: 
> On Fri, Dec 27, 2013 at 06:22:31PM +0800, Wanpeng Li wrote:
> > We have a server which have 200 CPUs and 8G memory, there is auto_group creation 
> 
> I'm hoping that is 8T, otherwise that's a severely under provisioned
> system, that's a mere 40M per cpu, does that even work?
> 
> > which will almost consume 12MB memory even if add 'noautogroup' in the kernel 
> > boot parameter. In addtion, SLUB per cpu partial caches freeing that is local to 
> > a processor which requires the taking of locks at the price of more indeterminism 
> > in the latency of the free. This patch fix it by check noautogroup earlier to avoid 
> > free after unnecessary memory consumption.
> 
> That's just a bad changelog. It fails to explain the actual problem and
> it babbles about unrelated things like SLUB details.
> 
> Also, I'm not entirely sure what the intention was of this code, I've so
> far tried to ignore the entire autogroup fest... 
> 
> It looks like it creates and maintains the entire autogroup hierarchy,
> such that if you at runtime enable the sysclt and move tasks 'back' to
> the root cgroup you get the autogroup behaviour.
> 
> Was this intended? Mike?

Yeah, it was intended that autogroups always exist if you config it in.
We could make is such that noautogroup makes it irreversibly off/dead.  

People with 200 ram starved CPUs can turn it off in their .config too :)

-Mike


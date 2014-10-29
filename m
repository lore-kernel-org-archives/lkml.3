Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaJ2SQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:16:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:45569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaJ2SQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:16:58 -0400
Date: Wed, 29 Oct 2014 19:16:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vikas Shivappa <vikas.shivappa@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        vikas <vikas.shivappa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "matt.fleming" <matt.fleming@intel.com>,
        "will.auld" <will.auld@intel.com>, tj@kernel.org
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141029181654.GR12706@worktop.programming.kicks-ass.net>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291020020.26215@vshiva-Udesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410291020020.26215@vshiva-Udesk>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:26:16AM -0700, Vikas Shivappa wrote:
> >It appears to me this 'mode' thing is entirely superfluous and can be
> >constructed by voluntary operation of this and cpusets or manual
> >affinity calls.
> 
> Do you mean user would would just user the cpusets for cpu affinity and CAT
> cgroup for cache allocation as shown in example below ?
> 
> In other words say affinitize the PID1 and PID2 to CPUs 1 and 2
>  and then set the desired cache allocation as well like below - then we have
> the desired cpu affinity and cache allocation for these PIDs..
> 
> cd /sys/fs/cgroup/cpuset
> 
> mkdir group1_specialuse
> /bin/echo 1-2 > cpuset.cpus
> /bin/echo PID1 > tasks
> /bin/echo PID2 > tasks
> 
> Now come to CAT and do the cache allocation for the same tasks PID1 and
> PID2.
> 
> cd /sys/fs/cgroup/cat (CAT cgroup)
> 
> mkdir group1_specialuse (keeping same name just for understanding)
> /bin/echo 0xf > cat.cbm (set the cache bit mask)
> /bin/echo PID1 > tasks
> /bin/echo PID2 > tasks
> 

Yah, except I have a strong urge to mount cpusets under /dog when you
put it like that ;-)

Or co-mount cpusets and pets and do it that way.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab3FCPn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:43:27 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53464 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:43:25 -0400
Date: Mon, 3 Jun 2013 17:43:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, alex.shi@intel.com,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, efault@gmx.de, pjt@google.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        len.brown@intel.com, corbet@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
Subject: Re: power-efficient scheduling design
Message-ID: <20130603154320.GA22214@gmail.com>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <51ACAF4D.3010600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ACAF4D.3010600@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> >
> >  - enumeration of idle states
> >
> >  - how long it takes to enter+exit a particular idle state
> >
> >  - [ perhaps information about how destructive to CPU caches that
> >      particular idle state is. ]
> >
> >  - new driver entry point that allows the scheduler to enter any of the
> >    enumerated idle states. Platform code will not change this state, all
> >    policy decisions and the idle state is decided at the power saving
> >    policy level.
> >
> >All of this combines into a 'cost to enter and exit an idle state'
> >estimation plus a way to enter idle states. It should be presented to the
> >scheduler in a platform independent fashion, but without policy embedded:
> >a low level platform driver interface in essence.
> 
> you're missing an aspect.
>
> Deeper idle states on one core, allow (on Intel and AMD at least) the 
> other cores to go faster. So it's not so simple as "if I want more 
> performance, go less deep". By going less deep you also reduce overall 
> performance of the system... as well as increase the power usage.
> 
> This aspect really really cannot be ignored, it's quite significant 
> today, and going forward is only going to get more and more significant.

I'm not missing turbo mode, just wanted to keep the above discussion 
simple. For turbo mode the "go for performance" constraints are simply 
different, more global. We have similar concerns in the scheduler already 
- for example system-global scheduling decisions for NUMA balancing.

Turbo mode in fact shows _why_ it's important to decide this on a higher, 
unified level to achieve best results: as the contraints and 
interdependencies become more complex it's not a simple CPU-local 
CPU-resource utilization decision anymore, but a system-wide one, where 
broad kinds of scheduling information is needed to make a good guess.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaGWG54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:57:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaGWG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:57:54 -0400
Date: Wed, 23 Jul 2014 08:57:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Message-ID: <20140723065736.GM3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <1406091303.5076.33.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406091303.5076.33.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 06:55:03AM +0200, Mike Galbraith wrote:
> On Mon, 2014-07-21 at 09:42 -0700, Andi Kleen wrote:
> 
> > FWIW the main problem is currently that switch-through-idle is so 
> > slow. I think improving that would give a boost to far more
> > situations.
> 
> Two high frequency idle enter/exit suckage spots:
> 
> 1) nohz (tick) - it's expensive to start/stop tick on every micro-idle,
> throttle it or something.

Yeah, so the idea was to use the cpuidle idle guestimator to control
this, and now that we've moved it somewhat closer to the scheduler that
might become possible.

> 2) ondemand governor - tweak silly default settings to reflect the
> reality that we routinely schedule communicating threads cross core.

Yeah, so the plan is to shoot cpufreq in the head and base the
replacement on smp aware metrics ;-) Its on a todo list somewhere..

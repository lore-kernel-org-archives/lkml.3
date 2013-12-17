Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3LQPOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:14:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46533 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3LQPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:14:10 -0500
Date: Tue, 17 Dec 2013 16:13:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH 00/15] cleanups and optimizations
Message-ID: <20131217151337.GN21999@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
 <52AAE61D.4060406@linux.intel.com>
 <20131213135626.GL21999@twins.programming.kicks-ass.net>
 <52AF3CF0.3090502@linux.intel.com>
 <20131217133204.GK21999@twins.programming.kicks-ass.net>
 <52B059CE.9090709@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B059CE.9090709@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:03:58PM +0200, Eliezer Tamir wrote:
> n 17/12/2013 15:32, Peter Zijlstra wrote:
> > 
> > Awesomeness.. you'll work on subtracting the spin time from the sleep
> > time?
> 
> Me or someone on our team will work on it.
> 
> I'm not sure that subtracting the spin time is the optimal thing to do.
> 
> The busy poll time is supposed to be limited to something less than 1ms.
> (I'm using 50us in most of my tests)
> This is typically orders of magnitude smaller than the poll timeout.
> Would it make more sense to just enforce a limit on poll time?
> 
> What do you think?

I've no idea what people normally expect of select/poll wakeup
granularity but typically we already have 50us of timer slack, although
RT tasks go without this.

It shouldn't be too hard to simply subtract the busy wait from the
expire ktime and avoid the entire issue though, so why not DTRT if its
fairly straight fwd to do so?

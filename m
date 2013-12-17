Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3LQWM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:12:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:41213 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3LQWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:12:25 -0500
Date: Tue, 17 Dec 2013 23:11:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH 00/15] cleanups and optimizations
In-Reply-To: <52B095C9.7040105@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1312172302560.31521@ionos.tec.linutronix.de>
References: <20131212140835.729222186@infradead.org> <52AAE61D.4060406@linux.intel.com> <20131213135626.GL21999@twins.programming.kicks-ass.net> <52AF3CF0.3090502@linux.intel.com> <20131217133204.GK21999@twins.programming.kicks-ass.net> <52B059CE.9090709@linux.intel.com>
 <20131217151337.GN21999@twins.programming.kicks-ass.net> <52B095C9.7040105@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Eliezer Tamir wrote:
> On 17/12/2013 17:13, Peter Zijlstra wrote:
> > On Tue, Dec 17, 2013 at 04:03:58PM +0200, Eliezer Tamir wrote:
> >>
> >> I'm not sure that subtracting the spin time is the optimal thing to do.
> >>
> >> The busy poll time is supposed to be limited to something less than 1ms.
> >> (I'm using 50us in most of my tests)
> >> This is typically orders of magnitude smaller than the poll timeout.
> >> Would it make more sense to just enforce a limit on poll time?
> >>
> >> What do you think?
> > 
> > I've no idea what people normally expect of select/poll wakeup
> > granularity but typically we already have 50us of timer slack, although
> > RT tasks go without this.
> 
> If RT tasks can't accept 50us of fuzziness, then the
> path of least astonishment would be to have fully accurate
> timekeeping, as you suggested. OK, so that's the plan.

No, the plan is to avoid busy loops in the first place.

Thanks,

	tglx

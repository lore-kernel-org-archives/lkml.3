Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaDNI7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:59:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50327 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaDNI7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:59:24 -0400
Date: Mon, 14 Apr 2014 10:59:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        daniel.lezcano@linaro.org, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 8/8] sched,idle: Reflow cpuidle_idle_call()
Message-ID: <20140414085911.GB11096@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.617896630@infradead.org>
 <alpine.LFD.2.11.1404131734120.980@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1404131734120.980@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 05:36:46PM -0400, Nicolas Pitre wrote:
> > @@ -102,90 +102,64 @@ static int cpuidle_idle_call(void)
> >  	 * Check if the cpuidle framework is ready, otherwise fallback
> >  	 * to the default arch specific idle method
> >  	 */
> > -	ret = cpuidle_enabled(drv, dev);
> > +	if (cpuidle_enabled(drv, dev))
> > +		goto use_default;
> 
> Why not using braces here and moving the use_default code block inside 
> it instead?

I didn't because there's two goto use_default sites, but sure, I can do
that.

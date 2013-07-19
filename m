Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766Ab3GSQcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:32:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48273 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760870Ab3GSQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:41 -0400
Date: Fri, 19 Jul 2013 09:29:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 04/17] sched_clock: Add support for >32 bit
 sched_clock
Message-ID: <20130719162939.GG27430@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <1374189690-10810-5-git-send-email-sboyd@codeaurora.org>
 <20130719092319.GA4681@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719092319.GA4681@tarshish>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Baruch Siach wrote:
> On Thu, Jul 18, 2013 at 04:21:17PM -0700, Stephen Boyd wrote:
> > @@ -110,14 +123,13 @@ void __init setup_sched_clock(u32 (*read)(void), int
> >   bits, unsigned long rate)
> >  	if (cd.rate > rate)
> >  		return;
> >  
> > -	BUG_ON(bits > 32);
> >  	WARN_ON(!irqs_disabled());
> >  	read_sched_clock = read;
> > -	sched_clock_mask = (1 << bits) - 1;
> > +	sched_clock_mask = CLOCKSOURCE_MASK(bits);
> 
> Note that this conflicts with my integer overflow fix 
> (http://article.gmane.org/gmane.linux.ports.arm.kernel/252498) that I hope 
> will get merged before 3.11 is out.
> 

Thanks for the heads up. The conflict looks minor and I'll rebase
if necessary.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

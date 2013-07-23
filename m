Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab3GWRBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:01:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45056 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3GWRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:01:54 -0400
Date: Tue, 23 Jul 2013 10:01:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if
 UP system
Message-ID: <20130723170153.GA27761@codeaurora.org>
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
 <B5906170F1614E41A8A28DE3B8D121433EEB180B@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EEB180B@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20, Bedia, Vaibhav wrote:
> Hi,
> 
> On Sat, Jul 06, 2013 at 05:09:33, Stephen Boyd wrote:
> > In a uniprocessor implementation the interrupt processor targets
> > registers are read-as-zero/write-ignored (RAZ/WI). Unfortunately
> > gic_get_cpumask() will print a critical message saying
> > 
> >  GIC CPU mask not found - kernel will fail to boot.
> > 
> > if these registers all read as zero, but there won't actually be
> > a problem on uniprocessor systems and the kernel will boot just
> > fine. Skip this check if we're running a UP kernel or if we
> > detect that the hardware only supports a single processor.
> > 
> > Cc: Nicolas Pitre <nico@linaro.org>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> > 
> > Maybe we should just drop the check entirely? It looks like it may
> > just be debug code that won't ever trigger in practice, even on the
> > 11MPCore that caused this code to be introduced.
> > 
> 
> Apologies if I missed v2 of this patch if there was one. I could not
> locate it in my inbox or the list archives.
> 
> We have a yet to be released single-core A9 MPCore system (AM437x) which
> needs to co-exist in omap2plus_defconfig wherein NR_CPUS is set to 2. 
> This currently leads to the "GIC CPU mask not found..." being printed
> twice during bootup. If the check is really some debug code, can it be
> completely dropped?

I have sent both versions of the patch in hopes that one or the
other will be accepted. Either way works for me.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

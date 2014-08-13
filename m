Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaHMAjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:39:42 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:38608 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaHMAjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:39:41 -0400
Date: Tue, 12 Aug 2014 20:39:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
In-Reply-To: <53EA970C.9070003@codeaurora.org>
Message-ID: <alpine.LFD.2.11.1408122038500.6061@knanqh.ubzr>
References: <alpine.LFD.2.11.1408041858570.6061@knanqh.ubzr> <1407194837-27190-1-git-send-email-sboyd@codeaurora.org> <53E118EE.5040205@codeaurora.org> <alpine.LFD.2.11.1408051537250.6061@knanqh.ubzr> <53E14B33.9080701@codeaurora.org>
 <alpine.LFD.2.11.1408052222350.6061@knanqh.ubzr> <53EA970C.9070003@codeaurora.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Stephen Boyd wrote:

> On 08/05/14 19:34, Nicolas Pitre wrote:
> >
> >> It allows us to synchronize with another CPU that may be inside
> >> gic_raise_softirq(). If the other CPU was in that function then this CPU
> >> would wait until it was done sending the IPI to continue along and
> >> reroute them. If the other CPU was just about to grab the sgi lock then
> >> we would guarantee that the CPU would see the new gic_cpu_map value and
> >> thus any redirection is not necessary.
> > OK I get it now.
> >
> >> I hoped that the commit text explained this.
> > I'm possibly not bright enough to get it the first time.
> >
> >> Honestly it probably isn't a noticeable performance boost either way 
> >> but I think this is the best we can do.
> > Sure, agreed.
> >
> >
> >
> 
> Ok, so which patch is preferred?

I'd say the later.


Nicolas

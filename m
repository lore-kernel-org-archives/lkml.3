Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaCUOy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:54:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57105 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbaCUOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:54:56 -0400
Date: Fri, 21 Mar 2014 15:54:03 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 3/5] ARM: berlin/dt: add cpupll and syspll support to BG2Q
Message-ID: <20140321145403.GC6443@piout.net>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395402220-23503-4-git-send-email-alexandre.belloni@free-electrons.com>
 <532C2C71.4010703@gmail.com>
 <20140321121741.GB6443@piout.net>
 <532C30AB.5020108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532C30AB.5020108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2014 at 13:29:31 +0100, Sebastian Hesselbarth wrote :
> >>Hmm, you probably know better than me, but if cpuclk == cpupll
> >>is always true we don't need another clk layer here. If you
> >>can scale down cpuclk from cpupll and we just have no driver
> >>for it, I am fine with it.
> >>
> >
> >You can actually switch CPU clk from CPU pll to smclk. I'm not sure this
> >is completely useful yet though, probably for suspend ?
> 
> Then it should be clk mux instead?
> 
> >Also, while I'm not sure this is a good reason, other clocks are derived
> >from CPU pll and have another divider.
> 
> I have no strong opinion, but a fixed-factor-clock with 1:1 just to
> rename cpupll to cpuclk seems a bit wasty ;)
> 
> If there is a mux, we should add it now - no matter if we are ever
> going to make any use of it. For the derived clocks we should be
> careful if they actually depend on cpuclk or always cpupll.
> 
> If your (current) knowledge of the berlin clock trees is almost as
> bad as mine, we can also ignore cpuclk mux if you prefer.
> 

Yeah, fact is I know there is a mux but I don't know yet how to get/set
its state so I will ignore it until we have more info.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbaCUPpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:45:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57479 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753761AbaCUPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:45:53 -0400
Date: Fri, 21 Mar 2014 16:45:39 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 1/5] clk: berlin: add support for berlin plls
Message-ID: <20140321154539.GD6443@piout.net>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395402220-23503-2-git-send-email-alexandre.belloni@free-electrons.com>
 <532C355C.3090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532C355C.3090606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[all commentis I agree on are snipped]

On 21/03/2014 at 13:49:32 +0100, Sebastian Hesselbarth wrote :
> On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
> obj-y += pll.o
> obj-$(CONFIG_MACH_BERLIN_BG2)	+= pll-berlin2.o
> obj-$(CONFIG_MACH_BERLIN_BG2CD)	+= pll-berlin2.o
> obj-$(CONFIG_MACH_BERLIN_BG2Q)	+= pll-berlin2q.o
> 
> Which reminds me, that we forgot to add MACH_BERLIN_BG2Q to
> arch/arm/mach-berlin/Kconfig. Can you spin a patch?
> 

I will do that.

> >+static const u8 vcodiv_berlin2[] = {10, 15, 20, 25, 30, 40, 50, 60, 80};
> >+
> >+static struct berlin_pllmap berlin_pll_map = {
> >+	.vcodiv = vcodiv_berlin2,
> >+	.fbdiv_mask = 0x1FF,
> >+	.rfdiv_mask = 0x1F,
> >+	.divsel_mask = 0xF,
> 
> divsel_mask allows 16 possible values, vcodiv_berlin2[] only provides
> 9, and common pll driver below does not know how many valid vcodiv
> values are passed. That can become dangerous..
> 
> I'd rather extend vcodiv_berlin2 to full divsel range and provide
> safe (=1) divisiors. This way wrong/new register values will only
> break clock frequency derived.
> 

Good catch ! Then, what about simply shrinking the mask so that we don't
overflow the table. We'll put it back to its supposed real value whant
we know what are the remaining divisors (my guess is that they are already
all listed here). I would say that we are getting the divisor wrong if
divsel > 8 anyway.

> >+	.fbdiv_shift = 6,
> >+	.rfdiv_shift = 1,
> >+	.divsel_shift = 7,
> 
> Have .foo_mask and .foo_shift together?
> 

This will make the struct larger but I don't really have an opinion.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

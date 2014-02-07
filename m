Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaBGOnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:43:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:47691 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbaBGOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:43:31 -0500
Date: Fri, 7 Feb 2014 11:43:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Emilio =?utf-8?B?TMOzcGV6?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: respect the clock dependencies in of_clk_init
Message-ID: <20140207144325.GA8218@localhost>
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
 <52F4DA40.4090804@elopez.com.ar>
 <20140207142430.GU8533@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140207142430.GU8533@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:24:30AM -0500, Jason Cooper wrote:
> On Fri, Feb 07, 2014 at 10:06:08AM -0300, Emilio López wrote:
> 
> [snip a great explanation]
> 
> Guys, can I get some Tested-by's on this?
> 

In case someone missed Emilio's comment about it, I gave his oneliner
a test on A370 Reference Design. It worked just as well as Sebastian's.

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

> > -----8<------
> > 
> > From ffdb49506e3ce92090c15e1f9b37f4d465097ac1 Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
> > Date: Thu, 6 Feb 2014 18:07:07 -0300
> > Subject: [PATCH] clk: mvebu: fix name dependency during registration time
> > 
> > Currently, mvebu_clk_gating_setup has a silly dependency on clock
> > registration order just to gather the parent clock name. This is
> > completely unnecesary, as it supports using an already provided name
> > via the clk_gating_soc_desc structs, and we can therefore solve this
> > issue with a 69+/- line patch. But, given that the parent name is
> > always "tclk" as default-hardcoded on mvebu_coreclk_setup(), we can
> > just default-hardcode it here too and get away with solving this
> > problem with a one-liner.
> > ---
> >  drivers/clk/mvebu/common.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
> > index 25ceccf..6c63b43 100644
> > --- a/drivers/clk/mvebu/common.c
> > +++ b/drivers/clk/mvebu/common.c
> > @@ -121,7 +121,7 @@ void __init mvebu_clk_gating_setup(struct
> > device_node *np,
> >  	struct clk_gating_ctrl *ctrl;
> >  	struct clk *clk;
> >  	void __iomem *base;
> > -	const char *default_parent = NULL;
> > +	const char *default_parent = "tclk";
> >  	int n;
> > 
> >  	base = of_iomap(np, 0);
> > -- 
> > 1.8.5.3

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3EMIbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:31:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16216 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3EMIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:31:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 May 2013 01:31:07 -0700
Date: Mon, 13 May 2013 11:31:03 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
Message-ID: <20130513083103.GC7949@tbergstrom-lnx.Nvidia.com>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <518D320C.4010707@elopez.com.ar>
 <fe9e603e-a432-4a29-a195-fd393b875a7e@TX2EHSMHS006.ehs.local>
 <518D411D.9070209@elopez.com.ar>
 <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>>
> >>> For debugging purposes, being able to change parents would be nice too.
> >> This is difficult and I don't have a good solution for it, hence it's
> >> missing. A clock consumer like a device driver or this driver, just
> >> knows about it's input clock, but not about the topology further up.
> >> Therefore it is pretty much impossible to implement reparent operations
> >> in a clock consumer, IMHO.
> >> IOW: For a given input clock, how do you figure out it's possible
> >> parents?
> >
> > The parent is just a number
> >
> > int (*set_parent)(struct clk_hw *hw, u8 index);
> > u8 (*get_parent)(struct clk_hw *hw);
> >
> > If you are debugging, you know what the possible parents are, and you
> > can reparent with that information.
> >
> > After checking the clk code however, I didn't find any exposed way to
> > reparent with just the parent indexes. Maybe an interface that takes a n
> > arbitrary string representing the parent name, and gets that clock and
> > then sets the parent would fit.
> >
> >>
> >>> Maybe this belongs to debugfs instead of sysfs though.
> >> Well, the more generic use-case probably. My Zynq use-case rather not,
> >> IMHO.
> >
> > The framework already exposes some information on debugfs, maybe
> > expanding that instead of implementing it as a consumer on sysfs would
> > be best for the debugging use case. @Mike, what's your thoughts on this?
> >
> 
> In the previous thread on this topic we discussed a generic approach
> to exposing clock controls via debugfs.
> 
> One way to do it is to introduce a new config option,
> CONFIG_COMMON_CLK_DEBUG_CONTROL that would expose the controls for
> every clock in the existing debugfs infrastructure.  The downside to
> this approach is that it would get abused and ship in millions of
> Android products using horrible userspace hacks to control clocks.
> Maybe that's not our problem to solve, maybe it is.
> 

We are doing the same. I don't think we can prevent people from abusing this.
If we don't provide it, they will just implement it themselves :)

> If CONFIG_COMMON_CLK_DEBUG_CONTROL existed it might be a good idea to
> intentionally break the abi compatibility with every new release.
> That would certainly reinforce that this is not a condoned or stable
> api (which is true for all debugfs).
> 

:) I would rather not have to change our automated tests for every new release
though...

Cheers,

Peter.

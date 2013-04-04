Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763401Ab3DDIVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:21:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11609 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab3DDIVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:21:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 04 Apr 2013 01:19:51 -0700
Date: Thu, 4 Apr 2013 11:20:44 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <rob.herring@calxeda.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Simon Glass <sjg@chromium.org>, Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <AChew@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 00/14] Tegra114 clockframework
Message-ID: <20130404082043.GY18519@tbergstrom-lnx.Nvidia.com>
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
 <515C6C6E.6060302@wwwdotorg.org>
 <515C7495.8060106@wwwdotorg.org>
 <515CB9D9.90303@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <515CB9D9.90303@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:23:05AM +0200, Stephen Warren wrote:
> On 04/03/2013 12:27 PM, Stephen Warren wrote:
> > On 04/03/2013 11:52 AM, Stephen Warren wrote:
> >> On 04/03/2013 08:40 AM, Peter De Schrijver wrote:
> >>> This is the nineth version of the Tegra114 clockframework. It is based on the
> >>> next-20130320-fixed branch of
> >>> git://nv-tegra.nvidia.com/user/swarren/linux-2.6.git,
> > ... [it depends on]
> >>> http://patchwork.ozlabs.org/patch/233415/
> >>
> >> That is Joseph's "clocksource: tegra: enable arch_timer". Is this
> >> actually a dependency, or an optimization, or ...?
> >>
> >> Rob Herring objected to that patch since it isn't necessary if his
> >> series "ARM arch, sp804 and integrator timer CLKSRC_OF support" is applied.
> >>
> >> If I apply just your (Peter's) CCF series without Joseph's or Rob's
> >> patches, will everything still work, or is this a hard dependency to
> >> create a working system?
> > 
> > I manage to get this series applied on top of my local dev branch, based
> > on next-20130328 (it was painful). Testing indicates that there is no
> > dependency on Joseph's patch mentioned above; I could boot, log in, and
> > play audio (with local patches) with /or/ without Joseph's patch applied.
> > 
> > However, I still find that I need to revert f7db706 ARM: "7674/1: smp:
> > Avoid dummy clockevent being preferred over real hardware clock-event",
> > or I get a hard system hang right after the root fs is mounted. As such,
> > I not sure if it's worthwhile applying this series since it's unlikely
> > to actually work once merged into Torvalds' tree.
> > 
> > Do you have any idea what the problem is here?
> > 
> > I'll try rebasing my local test branch on top of the latest linux-next
> > just in case some other fix solved this already, but I'm not going to
> > hold my breath.
> 
> I've found the problem. My bootloader wasn't initializing the TSC and
> hence I guess it wasn't working properly, even with Joseph's patch to
> add a call to the initialization function.
> 

Ok.

> So, if I:
> 
> a) Fix my bootloader to enable TSC.
> 
> b) Merge Rob's patch series to enable the TSC. This is needed rather
> than Joseph's patch since the two conflict, and I assume that Rob's
> patch is going into 3.10.
> 
> c) Undo my local revert of "ARM: 7674/1: smp: Avoid dummy clockevent
> being preferred over real hardware clock-event".
> 

Ok. Good. That's close to what I have and works here. As well.

> ... then everything now works.
> 
> So the only remaining issues are:
> 
> 1) Should the mux clocks still be defined in the binding document?
> Prashant didn't seem to think so.
> 

I guess we should remove them then.

> 2) I need Mike's ack to apply this series to the Tegra tree.

Ok. Mike?

Cheers,

Peter.

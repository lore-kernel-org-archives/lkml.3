Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764395Ab3DDVUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:20:12 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:58821 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764180Ab3DDVUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:20:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130404082043.GY18519@tbergstrom-lnx.Nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
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
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
 <515C6C6E.6060302@wwwdotorg.org> <515C7495.8060106@wwwdotorg.org>
 <515CB9D9.90303@wwwdotorg.org>
 <20130404082043.GY18519@tbergstrom-lnx.Nvidia.com>
Message-ID: <20130404212002.8665.12387@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v9 00/14] Tegra114 clockframework
Date: Thu, 04 Apr 2013 14:20:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-04-04 01:20:44)
> On Thu, Apr 04, 2013 at 01:23:05AM +0200, Stephen Warren wrote:
> > On 04/03/2013 12:27 PM, Stephen Warren wrote:
> > > On 04/03/2013 11:52 AM, Stephen Warren wrote:
> > >> On 04/03/2013 08:40 AM, Peter De Schrijver wrote:
> > >>> This is the nineth version of the Tegra114 clockframework. It is based on the
> > >>> next-20130320-fixed branch of
> > >>> git://nv-tegra.nvidia.com/user/swarren/linux-2.6.git,
> > > ... [it depends on]
> > >>> http://patchwork.ozlabs.org/patch/233415/
> > >>
> > >> That is Joseph's "clocksource: tegra: enable arch_timer". Is this
> > >> actually a dependency, or an optimization, or ...?
> > >>
> > >> Rob Herring objected to that patch since it isn't necessary if his
> > >> series "ARM arch, sp804 and integrator timer CLKSRC_OF support" is applied.
> > >>
> > >> If I apply just your (Peter's) CCF series without Joseph's or Rob's
> > >> patches, will everything still work, or is this a hard dependency to
> > >> create a working system?
> > > 
> > > I manage to get this series applied on top of my local dev branch, based
> > > on next-20130328 (it was painful). Testing indicates that there is no
> > > dependency on Joseph's patch mentioned above; I could boot, log in, and
> > > play audio (with local patches) with /or/ without Joseph's patch applied.
> > > 
> > > However, I still find that I need to revert f7db706 ARM: "7674/1: smp:
> > > Avoid dummy clockevent being preferred over real hardware clock-event",
> > > or I get a hard system hang right after the root fs is mounted. As such,
> > > I not sure if it's worthwhile applying this series since it's unlikely
> > > to actually work once merged into Torvalds' tree.
> > > 
> > > Do you have any idea what the problem is here?
> > > 
> > > I'll try rebasing my local test branch on top of the latest linux-next
> > > just in case some other fix solved this already, but I'm not going to
> > > hold my breath.
> > 
> > I've found the problem. My bootloader wasn't initializing the TSC and
> > hence I guess it wasn't working properly, even with Joseph's patch to
> > add a call to the initialization function.
> > 
> 
> Ok.
> 
> > So, if I:
> > 
> > a) Fix my bootloader to enable TSC.
> > 
> > b) Merge Rob's patch series to enable the TSC. This is needed rather
> > than Joseph's patch since the two conflict, and I assume that Rob's
> > patch is going into 3.10.
> > 
> > c) Undo my local revert of "ARM: 7674/1: smp: Avoid dummy clockevent
> > being preferred over real hardware clock-event".
> > 
> 
> Ok. Good. That's close to what I have and works here. As well.
> 
> > ... then everything now works.
> > 
> > So the only remaining issues are:
> > 
> > 1) Should the mux clocks still be defined in the binding document?
> > Prashant didn't seem to think so.
> > 
> 
> I guess we should remove them then.
> 
> > 2) I need Mike's ack to apply this series to the Tegra tree.
> 
> Ok. Mike?
> 

Cool to see this come together!

For the drivers/clk bits:

Acked-by: Mike Turquette <mturquette@linaro.org>

> Cheers,
> 
> Peter.

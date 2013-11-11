Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3KLCha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:37:30 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45815 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3KLChH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:37:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20131107204626.GA11746@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <20131106190152.GA8662@breakpoint.cc> <20131106193041.GA26796@roeck-us.net> <20131106203821.GC8662@breakpoint.cc> <20131106211754.GA29300@roeck-us.net> <20131107192558.GA11453@breakpoint.cc> <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com> <20131107204626.GA11746@breakpoint.cc>
Date: Mon, 11 Nov 2013 17:04:53 +0000
Message-Id: <20131111170453.4D999C42336@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013 21:46:26 +0100, Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> On 07.11.13, Pantelis Antoniou wrote:
> > Hi Sebastian,
> Hi Pantelis,
> 
> > FWIW DT has been ported to x86. And is present on arm/powerpc/mips/arc and possibly
> > others.
> 
> Yes, I know. I am the one that did the work for CE4100, the first one
> that boots with DT on x86.
> 
> > So what are we talking about again? If you care about the non-DT case, why
> > don't you make a patch about how you could support Guenter's use case on
> > the x86.
> 
> I am only saying that this "hot-plug a device at a non hot-plugagle bus at
> runtime" is not limited to DT but this solution is. X86 + ACPI is not
> the only limitation. ARM is (forced) going to ACPI as well as far I
> know. And this solution is limited to DT. This is what I am pointing
> out.

I'm going to nip this in the bud before it spreads...  No.

ARM is not going wholesale to ACPI.  ACPI will be implemented on ARMv8
servers. Don't expect the rest of the ARM world to go there anytime
soon, if at all.

As for being limited to DT, that is correct currently, just as SSDT is
an ACPI specific way of doing mostly the same thing. However, I'm not sure
it needs to be a limitation. As long as there is well definied
segregation between the base tree and the overlay (ie. it would be
useful to filter which nodes can be attached to, there are security
implications here too) then it would be fine for a DT overlay to pull in
additional devices on top of an ACPI base tree.

> > His use case is not uncommon, believe it or not, and x86 would benefit from
> > something this flexible.
> 
> I *think* a more flexible solution would be something like bus_type which is
> exposed via configfs. It would be attached behind a certain device/bus where
> the "physical" hotplug interface is. The user would then be able to read the
> configuration based on whatever information he has and could then create
> devices he likes at runtime. This wouldn't depend much on the firmware that is
> used but would require a little more work I think.

I'm certainly fine with investigating the above (modulo security
concerns of creating arbitrary devices). However, that is only one
use-case. There still needs to be the mechanism of passing the kernel a
blob all at once and say, "Here is the layout of this new hunk of
hardware".  For instance, you don't want to have to build up a set of
devices from scratch every time a new device is passed in. Xilinx for
instance has a tool which creates a FDT for an FPGA bitstream right from
the FPGA tools.

g.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3KGXBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:01:04 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38584 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3KGXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:00:54 -0500
Date: Thu, 7 Nov 2013 15:00:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
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
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Message-ID: <20131107230052.GC24450@roeck-us.net>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
 <20131106203821.GC8662@breakpoint.cc>
 <20131106211754.GA29300@roeck-us.net>
 <20131107192558.GA11453@breakpoint.cc>
 <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
 <20131107204626.GA11746@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107204626.GA11746@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 09:46:26PM +0100, Sebastian Andrzej Siewior wrote:
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
> 
I can't tell about ARM, but I am not entirely sure how ACPI support on ARM
is going to help us on powerpc.

> > His use case is not uncommon, believe it or not, and x86 would benefit from
> > something this flexible.
> 
> I *think* a more flexible solution would be something like bus_type which is
> exposed via configfs. It would be attached behind a certain device/bus where
> the "physical" hotplug interface is. The user would then be able to read the
> configuration based on whatever information he has and could then create
> devices he likes at runtime. This wouldn't depend much on the firmware that is
> used but would require a little more work I think.
> 
Quite frankly, I am interested at a solution that works and solves our problems.
I am not looking for something that is 100% perfect and may never be delivered.

Fortunately, the Linux kernel was willing to adopt multiple different file
systems, and still accepts new ones on a regular basis. If a new file system
is better, it will start getting used, and old file systems are being phased out
as fewer people use them. I would hope the same should be possible with DT
overlays and possible other future solutions for the same problem, and that
we won't have to wait for the perfect solution from day 1.

Guenter

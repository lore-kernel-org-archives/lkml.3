Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3KGUqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:46:55 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57899 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab3KGUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:46:46 -0500
Date: Thu, 7 Nov 2013 21:46:26 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
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
Message-ID: <20131107204626.GA11746@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
 <20131106203821.GC8662@breakpoint.cc>
 <20131106211754.GA29300@roeck-us.net>
 <20131107192558.GA11453@breakpoint.cc>
 <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.13, Pantelis Antoniou wrote:
> Hi Sebastian,
Hi Pantelis,

> FWIW DT has been ported to x86. And is present on arm/powerpc/mips/arc and possibly
> others.

Yes, I know. I am the one that did the work for CE4100, the first one
that boots with DT on x86.

> So what are we talking about again? If you care about the non-DT case, why
> don't you make a patch about how you could support Guenter's use case on
> the x86.

I am only saying that this "hot-plug a device at a non hot-plugagle bus at
runtime" is not limited to DT but this solution is. X86 + ACPI is not
the only limitation. ARM is (forced) going to ACPI as well as far I
know. And this solution is limited to DT. This is what I am pointing
out.

> His use case is not uncommon, believe it or not, and x86 would benefit from
> something this flexible.

I *think* a more flexible solution would be something like bus_type which is
exposed via configfs. It would be attached behind a certain device/bus where
the "physical" hotplug interface is. The user would then be able to read the
configuration based on whatever information he has and could then create
devices he likes at runtime. This wouldn't depend much on the firmware that is
used but would require a little more work I think.

> Regards
> 
> -- Pantelis

Sebastian

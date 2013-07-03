Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3GCLdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:33:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50140 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3GCLdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:33:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KSAvLCRgfpqhqqAH3I3gE
Date: Wed, 3 Jul 2013 04:33:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Nishanth Menon <nm@ti.com>, linux-wireless@vger.kernel.org, nsekhar@ti.com,
        mturquette@linaro.org, mark.rutland@arm.com, balbi@ti.com,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/9] wl12xx: use frequency instead of enumerations
 for pdata clocks
Message-ID: <20130703113334.GY5523@atomide.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-5-git-send-email-coelho@ti.com>
 <20130702150208.GA4233@kahuna>
 <1372796850.21065.93.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372796850.21065.93.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [130702 13:33]:
> On Tue, 2013-07-02 at 10:02 -0500, Nishanth Menon wrote:
> > On 17:55-20130702, Luciano Coelho wrote:
> > > Instead of defining an enumeration with the FW specific values for the
> > > different clock rates, use the actual frequency instead.  Also add a
> > > boolean to specify whether the clock is XTAL or not.
> > > 
> > > Change all board files to reflect this.
> > > 
> > > Cc: Tony Lindgren <tony@atomide.com>
> > > Cc: Sekhar Nori <nsekhar@ti.com>
> > > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > > ---
> > >  arch/arm/mach-davinci/board-da850-evm.c      |    3 +-
> > >  arch/arm/mach-omap2/board-4430sdp.c          |    5 ++-
> > ^^
> > >  arch/arm/mach-omap2/board-omap3evm.c         |    3 +-
> > >  arch/arm/mach-omap2/board-omap4panda.c       |    3 +-
> > ^^
> > Please do not add more platform data to platforms that are DT only.
> 
> Ah, I hadn't realized that board_omap4panda.c and board-4430sdp.c had
> been removed in linux-next.  I base my tree on wireless-next and it
> doesn't contain these changes yet.  I would only have noticed this when
> I rebased my tree once the merge window is closed. ;)
> 
> Thanks for pointing out, I'll make sure these changes will not be there
> when I send the pull request.

Please separate out the minimal pdata and arch/arm/mach-omap2 changes int
a immutable branch on v3.11-rc1 that I can also pull in. For v3.12, we're
going to be making more boards device tree only, so these changes may
otherwise cause pointless merge conflicts.

Regards,

Tony

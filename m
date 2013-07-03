Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3GCMPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:15:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50034 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab3GCMPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:15:13 -0400
Message-ID: <1372853674.21065.106.camel@cumari.coelho.fi>
Subject: Re: [PATCH v2 4/9] wl12xx: use frequency instead of enumerations
 for pdata clocks
From: Luciano Coelho <coelho@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Nishanth Menon <nm@ti.com>, <linux-wireless@vger.kernel.org>,
        <nsekhar@ti.com>, <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <balbi@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Wed, 3 Jul 2013 15:14:34 +0300
In-Reply-To: <20130703113334.GY5523@atomide.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
	 <1372776948-24840-5-git-send-email-coelho@ti.com>
	 <20130702150208.GA4233@kahuna> <1372796850.21065.93.camel@cumari.coelho.fi>
	 <20130703113334.GY5523@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 04:33 -0700, Tony Lindgren wrote:
> * Luciano Coelho <coelho@ti.com> [130702 13:33]:
> > On Tue, 2013-07-02 at 10:02 -0500, Nishanth Menon wrote:
> > > On 17:55-20130702, Luciano Coelho wrote:
> > > > Instead of defining an enumeration with the FW specific values for the
> > > > different clock rates, use the actual frequency instead.  Also add a
> > > > boolean to specify whether the clock is XTAL or not.
> > > > 
> > > > Change all board files to reflect this.
> > > > 
> > > > Cc: Tony Lindgren <tony@atomide.com>
> > > > Cc: Sekhar Nori <nsekhar@ti.com>
> > > > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > > > ---
> > > >  arch/arm/mach-davinci/board-da850-evm.c      |    3 +-
> > > >  arch/arm/mach-omap2/board-4430sdp.c          |    5 ++-
> > > ^^
> > > >  arch/arm/mach-omap2/board-omap3evm.c         |    3 +-
> > > >  arch/arm/mach-omap2/board-omap4panda.c       |    3 +-
> > > ^^
> > > Please do not add more platform data to platforms that are DT only.
> > 
> > Ah, I hadn't realized that board_omap4panda.c and board-4430sdp.c had
> > been removed in linux-next.  I base my tree on wireless-next and it
> > doesn't contain these changes yet.  I would only have noticed this when
> > I rebased my tree once the merge window is closed. ;)
> > 
> > Thanks for pointing out, I'll make sure these changes will not be there
> > when I send the pull request.
> 
> Please separate out the minimal pdata and arch/arm/mach-omap2 changes int
> a immutable branch on v3.11-rc1 that I can also pull in. For v3.12, we're
> going to be making more boards device tree only, so these changes may
> otherwise cause pointless merge conflicts.

Okay.  I don't want to freeze my work, I'll continue using my
wireless-based tree (which is based on 3.10) for now.  When the merge
window closes, I'll reorganize all this before sending pull requests, so
we can avoid conflicts.

Please ignore my changes to board files that will disappear on 3.11 and
keep reviewing the rest. ;)

--
Cheers,
Luca.


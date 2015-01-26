Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbbAZPvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:51:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37174 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbbAZPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:50:59 -0500
Date: Mon, 26 Jan 2015 09:50:32 -0600
From: Benoit Parrot <bparrot@ti.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2] ARM: AM43xx: hwmod: add VPFE hwmod entries
Message-ID: <20150126155032.GD2570@ti.com>
References: <1422217915-24231-1-git-send-email-prabhakar.csengg@gmail.com>
 <alpine.DEB.2.02.1501260205090.5450@utopia.booyaka.com>
 <CA+V-a8urS2C20FDcfsGa+Gg+7wmbbQQw3U7BfXf6GBKoBGMc9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+V-a8urS2C20FDcfsGa+Gg+7wmbbQQw3U7BfXf6GBKoBGMc9w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lad, Prabhakar <prabhakar.csengg@gmail.com> wrote on Mon [2015-Jan-26 08:13:01 +0000]:
> Hi Paul,
> 
> Thanks for the review.
> 
> On Mon, Jan 26, 2015 at 2:15 AM, Paul Walmsley <paul@pwsan.com> wrote:
> > Hi
> >
> > On Sun, 25 Jan 2015, Lad, Prabhakar wrote:
> >
> >> From: Benoit Parrot <bparrot@ti.com>
> >>
> >> this patch adds VPFE HWMOD data for AM43xx.
> >>
> >> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> >> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> ---
> >>  Hi Paul,
> >>
> >>  You were right, the hardware team has confirmed that, the VPFE master port is
> >>  connected to L3 and the VPFE slave port is connected to L4. The L3 port cannot
> >>  serve as a register target because it is initiator only.
> >
> > OK makes sense to me.,
> >
> >>
> >>  I have created links referring to dss l3/l4 hwmod and tested it, lemme know
> >>  if I have missed something.
> >
> > A few minor comments below
> >
> >>
> [Snip]
> >>  /* Interfaces */
> >>  static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs = {
> >>       .master         = &am33xx_l3_main_hwmod,
> >> @@ -788,6 +826,36 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
> >>       .user           = OCP_USER_MPU | OCP_USER_SDMA,
> >>  };
> >>
> >> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 = {
> >> +     .master         = &am43xx_vpfe0_hwmod,
> >> +     .slave          = &am33xx_l3_main_hwmod,
> >> +     .clk            = "l3_gclk",
> >> +     .flags          = OCPIF_SWSUP_IDLE,
> >
> > OCPIF_SWSUP_IDLE probably isn't needed here.  Could you please try without
> > it?
> >
> >> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
> >> +};
> >> +
> >> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 = {
> >> +     .master         = &am43xx_vpfe1_hwmod,
> >> +     .slave          = &am33xx_l3_main_hwmod,
> >> +     .clk            = "l3_gclk",
> >> +     .flags          = OCPIF_SWSUP_IDLE,
> >
> > Same point as the above.
> >
> Dropped and tested works! posting a v3.

When you tested it without the OCPIF_SWSUP_IDLE, did you go trhough a complete suspend/resume cycle?
This flag was added early on because otherwise the susbsytem would not go idle without it...

Can you post the console output during a suspend/resume cycle?

Benoit

> 
> Cheers,
> --Prabhakar Lad

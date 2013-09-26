Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3IZJa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:30:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51149 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3IZJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:30:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] pinctrl: sh-pfc: r8a7790: add pin definitions for the I2C3 interface
Date: Thu, 26 Sep 2013 11:30:57 +0200
Message-ID: <1424693.p1P0XFCq6l@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1309261117510.11968@axis700.grange>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de> <1736434.JorZUzD5Dk@avalon> <Pine.LNX.4.64.1309261117510.11968@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thursday 26 September 2013 11:24:26 Guennadi Liakhovetski wrote:
> On Wed, 25 Sep 2013, Laurent Pinchart wrote:
> > On Monday 09 September 2013 18:03:53 Guennadi Liakhovetski wrote:
> > > There are four I2C interfaces on r8a7790, each of them can be connected
> > > to one of the two respective I2C controllers, e.g. interface #0 can be
> > > configured to work with I2C0 or with IIC0. Additionally some of those
> > > interfaces can also use one of several pin sets. Interface #3 is
> > > special, because it can be used in automatic mode for DVFS. It only has
> > > one set of pins available and those pins cannot be used for anything
> > > else, they also lack the GPIO function.
> > > 
> > > This patch uses the sh-pfc ability to configure pins, not associated
> > > with GPIOs and adds support for I2C3 to the r8a7790 PFC set up.
> > 
> > Ulrich Hecht sent a patch titled "sh-pfc: r8a7790: Add I2C pin groups and
> > functions" that added pin groups for I2C1 and I2C2. The patch is available
> > from
> > 
> > 	git://linuxtv.org/pinchartl/fbdev.git pinmux/next
> > 
> > If you need to resubmit this patch due to my comments below, could you
> > please rebase it on top of that branch ?
> > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > ---
> > > 
> > >  drivers/pinctrl/sh-pfc/pfc-r8a7790.c |   28
> > >  ++++++++++++++++++++++++++++
> > >  1 files changed, 28 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> > > b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c index 64fcc006..c3c4d9b 100644
> > > --- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> > > +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> > > @@ -781,6 +781,8 @@ enum {
> > >  	ADICS_SAMP_MARK, DU2_CDE_MARK, QPOLB_MARK, SCIFA2_RXD_B_MARK,
> > >  	USB1_PWEN_MARK, AUDIO_CLKOUT_D_MARK, USB1_OVC_MARK,
> > >  	TCLK1_B_MARK,
> > > +
> > > +	I2C3_SCL_MARK, I2C3_SDA_MARK,
> > > 
> > >  	PINMUX_MARK_END,
> > >  };
> > > @@ -1719,10 +1721,22 @@ static const u16 pinmux_data[] = {
> > >  	PINMUX_IPSR_DATA(IP16_6, AUDIO_CLKOUT_D),
> > >  	PINMUX_IPSR_DATA(IP16_7, USB1_OVC),
> > >  	PINMUX_IPSR_MODSEL_DATA(IP16_7, TCLK1_B, SEL_TMU1_1),
> > > +
> > > +	PINMUX_DATA(I2C3_SCL_MARK, FN_SEL_IICDVFS_1),
> > > +	PINMUX_DATA(I2C3_SDA_MARK, FN_SEL_IICDVFS_1),
> > 
> > You introduce a way to mux the I2C3 function on those two pins, but no way
> > to select the IICDVFS back. I don't think it's an issue, we can always
> > add that later when (if) needed. Linus, is that fine with you ?
> 
> I did it on purpose, since I didn't have a use case for IICDVFS. I prefer
> not to add too many things, that cannot be tested.

Just for the record, I'm fine with that.

> > >  };
> > > 
> > > +/* R8A7790 has 6 banks with 32 GPIOs in each = 192 GPIOs */
> > > +#define ROW_GROUP_A(r) ('Z' - 'A' + 1 + (r))
> > > +#define PIN_NUMBER(r, c) (((r) - 'A') * 16 + (c) + 200)
> > 
> > The BGA package has 31 columns, shouldn't you multiply the row number by
> > 31 instead of 16 ?
> 
> Oops, you're right - the pin table is continued on the second page...

Could you then submit a v2 based on git://linuxtv.org/pinchartl/fbdev.git 
pinmux/next ?

> > As we have 192 GPIOs, shouldn't you use an offset of 192 instead of 200 ?
> > This doesn't matter too much I guess.
> 
> On one of Renesas SoCs I've seen an offset of 2000 used. I thought it
> would be an exaggeration in this case ;) but I followed the pattern of
> using a round number for the offset, is this ok?

I suppose that's fine, yes.

-- 
Regards,

Laurent Pinchart


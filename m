Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbbATHZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:25:22 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:54798 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbATHYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:24:00 -0500
Date: Tue, 20 Jan 2015 07:23:59 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Keerthy <a0393675@ti.com>
cc: tony@atomide.com, t-kristo@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH] ARM: OMAP: DRA7: hwmod: Make gpmc software supervised
 as the smart idle is broken
In-Reply-To: <54BDF469.3030907@ti.com>
Message-ID: <alpine.DEB.2.02.1501200722560.5450@utopia.booyaka.com>
References: <1421139085-27183-1-git-send-email-j-keerthy@ti.com> <54BDF469.3030907@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Keerthy wrote:

> On Tuesday 13 January 2015 02:21 PM, Keerthy wrote:
> > This patch fixes: 'omap_hwmod: gpmc: _wait_target_disable failed'
> > error during suspend.
> > 
> > This is because smart idle is broken.
> > Tested in dra7-evm D1 board.
> 
> Ping on this.
> 
> > Signed-off-by: Keerthy <j-keerthy@ti.com>
> > ---
> >   arch/arm/mach-omap2/omap_hwmod_7xx_data.c |    3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> > b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> > index 9cdd8b8..29e55fe 100644
> > --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> > @@ -826,7 +826,8 @@ static struct omap_hwmod dra7xx_gpmc_hwmod = {
> >   	.name		= "gpmc",
> >   	.class		= &dra7xx_gpmc_hwmod_class,
> >   	.clkdm_name	= "l3main1_clkdm",
> > -	.flags		= HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET,
> > +	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET |
> > +			   HWMOD_SWSUP_SIDLE),
> >   	.main_clk	= "l3_iclk_div",
> >   	.prcm = {
> >   		.omap4 = {

Thanks, queued for v3.20.

Note that I cannot test this since I don't have a DRA7xx board.


- Paul

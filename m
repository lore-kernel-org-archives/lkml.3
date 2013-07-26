Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3GZJJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:09:08 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:41949 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3GZJJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:09:05 -0400
Date: Fri, 26 Jul 2013 11:09:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/4] ASoc: kirkwood: add DT support
Message-ID: <20130726110913.0a193918@armhf>
In-Reply-To: <20130725230533.GH24642@n2100.arm.linux.org.uk>
References: <20130725111459.145a4aa4@armhf>
	<20130725191905.GR9858@sirena.org.uk>
	<20130725230533.GH24642@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 00:05:33 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Jul 25, 2013 at 08:19:05PM +0100, Mark Brown wrote:
> > On Thu, Jul 25, 2013 at 11:14:59AM +0200, Jean-Francois Moine wrote:
	[snip]
> > > -	priv->clk = devm_clk_get(&pdev->dev, NULL);
> > > +	priv->clk = devm_clk_get(&pdev->dev, "internal");
> > >  	if (IS_ERR(priv->clk)) {
> > > -		dev_err(&pdev->dev, "no clock\n");
> > > +		dev_err(&pdev->dev, "no internal clock\n");
> > >  		return PTR_ERR(priv->clk);
> > >  	}
> > 
> > Does the code providing it already name the clock?  If not are updates
> > needed to do that?

I don't know. I will reset the clock name to NULL when no DT, so it
will be compatible.

> > > -	priv->extclk = clk_get(&pdev->dev, "extclk");
> > > +	priv->extclk = clk_get(&pdev->dev, "external");
> > 
> > Is the clock actually called extclk in the datasheet and so on?  If so
> > it seems better to stick with that name.  Do any boards need updates for
> > the new name?
> 
> "AU_EXTCLK" is the exact name (pasted out of the documentation).
> I don't see any purpose to this name changing.

On Tue, Jul 23, 2013 at 02:59:06PM +0200, Sebastian Hesselbarth wrote:
> As Sascha Hauer pointed out, clocks should be distinguished by names
> (clock-names property) instead of position and then use
> devm_clk_get(&pdev->dev, "internal") and
> devm_clk_get(&pdev->dev, "external") respectively.  
> 
> This will possibly also require to update platform_data and legacy
> users of kirkwood-i2s or have different setup functions for non-DT
> and DT.  

The A510 documentation uses the names "DCO PLL" for the internal clock
and "AU_EXTCLK" for the external clock. So, what about "dcopll" and
"extclk"?


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

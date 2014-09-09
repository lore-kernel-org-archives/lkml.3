Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaIISD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:03:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37786 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaIISDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:03:25 -0400
Date: Tue, 9 Sep 2014 11:03:10 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140909180309.GA6784@Asurada>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909112750.GS2601@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909112750.GS2601@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:27:50PM +0100, Mark Brown wrote:
> On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> > -	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
> > +	ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");
> >  	if (IS_ERR(ssi_private->clk)) {
> >  		ret = PTR_ERR(ssi_private->clk);
> > -		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
> > -		return ret;
> 
> Why is this change being made?  It wasn't mentioned in the commit log
> and doesn't seem relevant to moving where the enable and disable are
> done which is what the patch is supposed to be doing...

I think Shengjiu is trying to keep the clock disabled while SSI's idle.
The current driver enables ipg clock anyway even if there's no stream
running.

Apparently, these should be put into the comment log.

Thank you
Nicolin

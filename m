Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3EBHye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:54:34 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59117 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3EBHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:54:32 -0400
Date: Thu, 2 May 2013 09:54:21 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 2/3] ASoC: ux500: move clock controls to ab8500-codec
Message-ID: <20130502075421.GA23346@balto.lan>
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
 <1367330994-7259-3-git-send-email-fabio.baltieri@linaro.org>
 <20130430183035.GC26160@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430183035.GC26160@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 07:30:35PM +0100, Mark Brown wrote:
> On Tue, Apr 30, 2013 at 04:09:53PM +0200, Fabio Baltieri wrote:
> > Move ab8500 clock control definitions to the ab8500 codec driver,
> > leaving only card specific setting in mop500_ab8500_ctrls.
> 
> So, if this is some generic thing and not some weird stuff for the card
> this really reopens the question about why this is done with user
> visible controls...
> 
> >  static struct snd_kcontrol_new ab8500_ctrls[] = {
> > +	/* Digital interface - Clocks */
> > +	SOC_SINGLE("Digital Interface Master Generator Switch",
> > +		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENMASTGEN,
> > +		1, 0),
> > +	SOC_SINGLE("Digital Interface 0 Bit-clock Switch",
> > +		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK0,
> > +		1, 0),
> > +	SOC_SINGLE("Digital Interface 1 Bit-clock Switch",
> > +		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK1,
> > +		1, 0),
> 
> ...this is all stuff that is normally figured out automatically by the
> drivers, we know when the audio interface is in use and hence when it
> needs to be clocked.

It makes sense, I'll poke the documentation I have and try to figure out
how to control those bits from a more appropriate place.

Thanks,
Fabio

-- 
Fabio Baltieri

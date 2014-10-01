Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaJAI7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:59:31 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:4222 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaJAI71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:59:27 -0400
Date: Wed, 1 Oct 2014 10:59:39 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC:kirkwood: Don't raise an error when no DAI format
Message-ID: <20141001105939.1f2b6524@armhf>
In-Reply-To: <20140930181910.GJ4273@sirena.org.uk>
References: <20140928150342.CC21B786A1D@smtpfb1-g21.free.fr>
	<20140928151207.GI5182@n2100.arm.linux.org.uk>
	<20140928180550.5f0b8f03@armhf>
	<20140930181910.GJ4273@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 19:19:10 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Sun, Sep 28, 2014 at 06:05:50PM +0200, Jean-Francois Moine wrote:
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > On Sun, Sep 28, 2014 at 04:19:27PM +0200, Jean-Francois Moine wrote:
> 
> > > > This patch prevents the controller to raise an error when
> > > > the DT audio card definition by the simple card contains the PCM
> > > > format of one CPU DAI only.
> 
> > > I think this is a silly idea - why should every driver have additional code
> > > to detect when it's called to do thing.  Why doesn't the simple card code
> > > always pass the required format?
> 
> > > Looking at other drivers, no one else does this; they all appear to require
> > > the proper format to be specified.
> 
> > > What some drivers do (eg, omap-mcbsp.c) is to block set_fmt when the
> > > DAI is already in use - setting a flag "configured" in hw_params, and
> > > clearing it in shutdown.  Maybe following this will solve your problem.
> 
> > > In any case, random drivers doing stuff differently without reason is
> > > really not a good idea.
> 
> > As the simple card is done, the audio hardware definitions of the
> > platform and all the CPU DAIS are always set in the audio controller.
> 
> > When the PCM format is globally defined (platform), the function
> > set_fmt() is called for all CPU DAIs (then, twice for the kirkwood
> > controller) with the same value. The DT is:
> 
> ...
> 
> > The PCM format may also be defined per DAI link. The following DT works
> > the same as setting globally the format, i.e. there are two calls to
> > set_fmt() with 'i2s':
> 
> > The problem appears when the format is defined in only one DAI link:
> 
> > Then, audio does not work.
> 
> So this is still a generic rather than driver issue and should be solved
> outside of the driver - exactly the same issue is going to apply to any
> other device with a similar shared configuration.  We could either say
> that the DT is buggy here or we could say that the generic card ought to
> assume that if only one link specifies a format then it should use that
> format for other links if possible (since clearly the user doesn't care
> what it chooses).

The 'daifmt' of the callback function set_fmt (snd_soc_dai_set_fmt)
contains 4 parts:
- the physical format,
- the clock gating,
- the signal inversions,
- the master clock definitions.

As the value '0' is not used in the physical format nor in the master
clock, this value would have say 'don't change', permitting the
parameters to be set independently.

But, as you and Russell say 'no', I will let the format definition at
the platform level in the DT. Setting twice the hardware registers is
not a problem.

Thanks.

> Please also try to use subject lines matching the style for the
> subsystem.  You've been working with upstream for a while, you really
> ought to be familiar with this sort of basic process stuff.

Sorry.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

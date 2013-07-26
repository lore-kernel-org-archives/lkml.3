Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3GZHiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:38:46 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:58359 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3GZHio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:38:44 -0400
Date: Fri, 26 Jul 2013 09:38:50 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/4] ASoc: kirkwood: merge kirkwood-i2c and kirkwood-dma
Message-ID: <20130726093850.2d2cd45c@armhf>
In-Reply-To: <20130725225816.GG24642@n2100.arm.linux.org.uk>
References: <20130725111428.419ee278@armhf>
	<20130725191604.GQ9858@sirena.org.uk>
	<20130725225816.GG24642@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 23:58:16 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Jul 25, 2013 at 08:16:04PM +0100, Mark Brown wrote:
> > On Thu, Jul 25, 2013 at 11:14:28AM +0200, Jean-Francois Moine wrote:
> > > To avoid the declaration of a 'kirkwood-pcm-audio' device in the DT,
> > > this patch merges the kirkwood-i2c and kirkwood-dma drivers into one
> > > module.
> > 
> > This seems mostly fine, though it may be best to keep kirkwood-dma as a
> > separate module for the benefit of the S/PDIF support when it gets added
> > - I had a look at the implementation Russell has and it looks like it
> > can be added as a separate interface.
> 
> You wouldn't want I2S and SPDIF to be separate modules though - they're
> the same hardware but different output stream formatters attached to the
> DMA FIFO output.  Don't forget the requirements concerning the simultaneous
> use of I2S and SPDIF - these "output formatters" must both be enabled and
> disabled in unison when concurrent use is required - both bits must be
> set or cleared together with a single register write.
> 
> > > -	.platform_name = "kirkwood-pcm-audio",
> > > +	.platform_name = "kirkwood-i2s",
> > 
> > Should the name be done as dev_name() for the interface (I don't know if
> > there is ever more than one)?
> 
> Getting away from "kirkwood-i2s" would be sensible, because it may not be
> just "i2s" in this hardware block.  The documentation calls this an "audio
> controller" but I guess "kirkwood-pcm" would be a reasonable compromise,
> even though it has a separate AC'97 block which could also be construed
> as being "pcm".
> 
> The AC'97 block uses a separate peripheral DMA controller and so wouldn't
> make use of kirkwood-dma.c either.

As the kirkwood audio subsystem is used in the other mvebu machines,
the name of the module kirkwood-i2s/kirkwood-dma could be
"mvebu-pcm-audio".

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

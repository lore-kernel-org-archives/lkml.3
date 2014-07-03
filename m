Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbaGCN0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:26:34 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:43017 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbaGCN0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:26:33 -0400
Date: Thu, 3 Jul 2014 15:28:26 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140703152826.103c9d6c@armhf>
In-Reply-To: <20140703115924.GY410@sirena.org.uk>
References: <20140702183841.7c964832@armhf>
	<20140702165628.GO20799@lunn.ch>
	<20140702195154.47d6f6b4@armhf>
	<20140702194252.GN410@sirena.org.uk>
	<20140703074959.7c489912@armhf>
	<20140703104432.GV410@sirena.org.uk>
	<20140703133406.2d3e3a1d@armhf>
	<20140703115924.GY410@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 12:59:24 +0100
Mark Brown <broonie@kernel.org> wrote:

> > > Your board happens to only be able to present the same input on both I2S
> > > and S/PDIF but that might not apply to other boards, they may be able to
> > > route different signals to each which would present a practical problem.  
> 
> > If there are two different streamss on I2S and S/PDIF, and if the audio
> > subsystem wants to route these streams to the same connector (widget
> > 'hdmi-out'), then, somewhere, there should be a software or a design
> > bug. No?  
> 
> Yes, which is why the driver shouldn't silently ignore the situation.
> 
> > Anyway, the tda998x cannot know if the double route is wanted or not.  
> 
> It doesn't need to know, it just needs to identify something it can't
> support either by providing a way to pick which interface is used or by
> rejecting the second interface.

OK. no problem, I can do that: only the first stream is switched and
the second is rejected.

But, this means that there will be a lot of errors when DPCM will be
used, because, in most cases for the Cubox (kirkwood audio + tda998x),
both ways I2S and S/PDIF will be activated at the same time for a
single stream (you may note that the routes from the second input
cannot be blocked by the CODEC after it received the first input,
because these routes have already been computed).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

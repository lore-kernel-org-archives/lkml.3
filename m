Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaGCLcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:32:14 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:5092 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaGCLcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:32:13 -0400
Date: Thu, 3 Jul 2014 13:34:06 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140703133406.2d3e3a1d@armhf>
In-Reply-To: <20140703104432.GV410@sirena.org.uk>
References: <20140702183841.7c964832@armhf>
	<20140702165628.GO20799@lunn.ch>
	<20140702195154.47d6f6b4@armhf>
	<20140702194252.GN410@sirena.org.uk>
	<20140703074959.7c489912@armhf>
	<20140703104432.GV410@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 11:44:32 +0100
Mark Brown <broonie@kernel.org> wrote:

> > > I'd expect this to return an error for the busy DAI rather than just
> > > silently ignore it failing to start or (better) implement some control
> > > to let the user select which of the DAIs is active.  
> 
> > This is not an error. If the audio subsystem (DPCM, not the user)
> > chooses to activate both I2S and S/PDIF, this means the HDMI audio may
> > be taken either from I2S or from S/PDIF: both inputs have the right
> > format and rate.  
> 
> Your board happens to only be able to present the same input on both I2S
> and S/PDIF but that might not apply to other boards, they may be able to
> route different signals to each which would present a practical problem.

If there are two different streamss on I2S and S/PDIF, and if the audio
subsystem wants to route these streams to the same connector (widget
'hdmi-out'), then, somewhere, there should be a software or a design
bug. No?

Anyway, the tda998x cannot know if the double route is wanted or not.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

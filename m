Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965849Ab3HIJn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:43:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40857 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287Ab3HIJn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:43:57 -0400
Date: Fri, 9 Aug 2013 10:43:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu
	audio subsystem
Message-ID: <20130809094340.GO23006@n2100.arm.linux.org.uk>
References: <20130808132201.2610aef3@armhf> <5204A716.6070507@gmail.com> <20130809091953.GO6427@sirena.org.uk> <5204B7A6.9050907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5204B7A6.9050907@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:34:30AM +0200, Sebastian Hesselbarth wrote:
> Mark,
>
> I do understand there may be SoCs requiring sophisticated extra audio
> nodes, but Marvell SoCs don't. I prefer having a single node for the
> i2s controller *and* exploit the audio subsystem properties from that.
>
> For Marvell audio, we only need a single node for all three ASoC
> drivers. No other subsystem _requires_ you to have extra nodes for
> it's needs. If you can provide interrupts, just have an interrupt-
> controller property. If you can provide clocks, you can link to that
> very node - no virtual device node required. Even for media they
> do not insist on a virtual node but they do have generic properties
> you can exploit.

Certainly from the "DT is a hardware description" you are completely
correct.  The audio controller _should_ link directly to the codec,
because that's how the hardware is wired.  Remember though that there
are two outputs from the audio controller (please, call it audio
controller, not I2S controller) so you need to specify which of those
two outputs the "codec" is connected to.

I would say that's required irrespective of whether or not we have a
virtual node to aggregate the stuff together for ASoC's purposes (which
should not be part of the DT hardware description - it can be part of
the "software" configuration though.)

We may be able to have kirkwood-i2s.c (which I plan to rename to
mvebu-audio.c) automatically generate the snd_soc_card stuff from the
audio controller node.  Given that we need a more complex description
than the "simple" thing for DPCM, that might be overall the best
solution in any case (maybe calling out to a library which can be
shared between CPU DAI drivers to do this.)

Note that we do have another case not yet in tree, which is DRM, but
this case is different from that, because ASoC can cope with components
with independent initialisation.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaGCPnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:43:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53146 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932231AbaGCPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:43:36 -0400
Date: Thu, 3 Jul 2014 16:43:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140703154325.GY32514@n2100.arm.linux.org.uk>
References: <20140702165628.GO20799@lunn.ch> <20140702195154.47d6f6b4@armhf> <20140702194252.GN410@sirena.org.uk> <20140703074959.7c489912@armhf> <20140703104432.GV410@sirena.org.uk> <20140703133406.2d3e3a1d@armhf> <20140703115924.GY410@sirena.org.uk> <20140703152826.103c9d6c@armhf> <20140703134346.GW32514@n2100.arm.linux.org.uk> <20140703172909.60caf2c7@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703172909.60caf2c7@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 05:29:09PM +0200, Jean-Francois Moine wrote:
> I think that you did not look at my code.
> 
> Both S/PDIF and I2S work with the TDA998x. It is a choice of the audio
> subsystem to do this choice, not Russell King.

If you think I'm arguing because I personally want something, then we're
not going to make any progress.

What I want is for this to be _correct_ and _not_ to introduce silly
restrictions which break people's setups.

> When DPCM will handle the formats and rates, the audio subsystem will
> find by itself if such stream will go to the HDMI only or to the S/PDIF
> only or to both. The kirwood audio driver will work as it is and the tda998x
> CODEC will work as it is. There will be no need to change these drivers.

Except, as Mark has already pointed out, and as I keep pointing out to
you, and you keep refusing to accept, the kirkwood driver as it stands
is *not* a DPCM driver.  It makes no use of that stuff at all.

What you're doing in kirkwood-i2s is providing two plain DAI links,
and then insisting that only one can be active any any one time.

A DPCM solution provides at least one frontend DAI link and at least
one backend DAI link.  Your code does not do this.

The second point is that - and as I keep telling you - that as soon
as you couple your existing code (which restricts things like the
sample rates) you can no longer output anything else through the
optical out ON THE CUBOX.  For this statement, I'm not talking
_generally_,  I'm talking _specifically_ about _one_ _platform_.

> All we need actually is some more code in DPCM or multi-codec or
> whatever mechanism which will route the stream according to the rates
> and formats.

Yes, DPCM currently lacks full support, that's been known about for
some time - I've reported it to Mark, but it seems that this isn't
something that is going to get fixed until others put work into it.

> Eventually, the TDA998x is used in other machines. Are you sure that
> the audio controllers of all these machines have a S/PDIF output
> connected to the S/PDIF input of the tda998x?

Which bit of "we need to support both I2S and SPDIF" in my previous
emails was not clear.  Which bit of "We should only support SPDIF
on the Cubox" was not clear?

I *fully* acknowledge that we need to support both, but I'm putting
a _strong_ recommendation to you _with_ technical reasons why we
should _only_ support SPDIF on the Cubox.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

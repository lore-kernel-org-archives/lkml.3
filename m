Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbbANOXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:23:44 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39740 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272AbbANOXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:23:43 -0500
Date: Wed, 14 Jan 2015 14:23:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Jyri Sarha <jsarha@ti.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150114142327.GX12302@n2100.arm.linux.org.uk>
References: <1421151718.4519.24.camel@pengutronix.de>
 <20150113122715.GP12302@n2100.arm.linux.org.uk>
 <20150113165411.5469930d@armhf>
 <20150113160313.GR12302@n2100.arm.linux.org.uk>
 <20150113200252.3dbfab14@armhf>
 <20150113192648.GU12302@n2100.arm.linux.org.uk>
 <54B574CD.9020905@ti.com>
 <20150113195415.GV12302@n2100.arm.linux.org.uk>
 <1421232418.3155.31.camel@pengutronix.de>
 <20150114125056.GU4160@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114125056.GU4160@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:50:56PM +0000, Mark Brown wrote:
> Trying to hook up a controller that doesn't natively support this format
> to a device that uses it is definitely tricky, as well as describing the
> physical hookup we also need to worry about how things look to userspace
> - it's ideally going to want a single multi-channel audio stream.

Trying to get the synchronisation correct for proper surround audio
reproduction would also be interesting.  I suspect that userspace
would have to be taught specifically about a hardware setup like this -
in order to ensure that the slave I2S blocks are ready before the master
starts outputting the I2S clocks.

I'm /not/ that thrilled with the whole idea; I'd much rather suggest
that we should concentrate on sane setups, but we know that hardware
engineers do create some silly setups "because they can".

> I think from a binding point of view we need a way to say "this endpoint
> on the link is constructed from these DAIs on the device side" and say
> if this is TDM or multi-data, and what's driving the clocks.

This seems to favour the "one DT port for I2S" model - possibly with
multiple endpoints for each I2S channel (if desired).  There's nothing
in that model which would prevent having one end point for all four
channels.  To put that another way, we can remain flexible.

Maybe we should document the binding indicating that for I2S, one port
and one endpoint connected to one I2S block which supplies all I2S
channels is the preferred model, but others are permitted but not
necessarily guaranteed to work correctly.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

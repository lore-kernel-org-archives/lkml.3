Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968494Ab3HJJSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 05:18:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47868 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968472Ab3HJJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 05:18:47 -0400
Date: Sat, 10 Aug 2013 11:16:19 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaroslav Kysela <perex@perex.cz>, Mark Brown <broonie@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu
 audio subsystem
Message-ID: <20130810111619.3444fda5@skate>
In-Reply-To: <20130809110623.7bb3e7ad@armhf>
References: <20130808132201.2610aef3@armhf>
	<5204A716.6070507@gmail.com>
	<20130809110623.7bb3e7ad@armhf>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Francois Moine,

On Fri, 9 Aug 2013 11:06:23 +0200, Jean-Francois Moine wrote:

> > we need at least two more compatibles for the audio controller found on
> > Dove and Kirkwood respectively. This is how we are going to distinguish
> > those two, e.g. Kirkwood has SPDIF in which Dove hasn't.
> 
> Sebastian,
> 
> s/has/hasn't & s/hasn't/has
> 
> Are 2 compatibles enough, i.e. "mvebu-audio" and "mbevu-audio-spdif"?

Or:

	marvell,kirkwood-audio
	marvell,dove-audio

> > Also, we have used "marvell" as prefix for a long time. I know there has
> > been discussion about the stock ticker appreviation, has there been any
> > decision on that already?
> 
> Don't know, but, sure, there are still a lot of "mrvl".

Yes, but they are being converted over to 'marvell', I've seen some
patches posted. Also, as per
Documentation/devicetree/bindings/vendor-prefixes.txt, 'marvell' is the
right prefix for Marvell compatible strings.


> > Also we will need some phandle reference to the audio codec here. As
> > this property is ongoing work in ASoC core, I suggest we wait for it
> > and propose a binding afterwards.
> 
> I don't think that we need any reference to the codec here. The glue is
> done by the audio device. For example, using the (soon?) extended
> simple audio card:

Have you looked at the Samsung DT bindings for audio:

        sound {
                compatible = "samsung,smdk-wm8994";

                samsung,i2s-controller = <&i2s0>;
                samsung,audio-codec = <&wm8994>;
        };

it definitely has a codec phandle reference here.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

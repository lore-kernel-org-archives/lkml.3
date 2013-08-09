Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965561Ab3HIJF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:05:29 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:49441 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845Ab3HIJF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:05:27 -0400
Date: Fri, 9 Aug 2013 11:06:23 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu
 audio subsystem
Message-ID: <20130809110623.7bb3e7ad@armhf>
In-Reply-To: <5204A716.6070507@gmail.com>
References: <20130808132201.2610aef3@armhf>
	<5204A716.6070507@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 10:23:50 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> On 08/08/2013 01:22 PM, Jean-Francois Moine wrote:
> > This patch adds DT support to the audio subsystem of the mvebu family
> > (Kirkwood, Dove, Armada 370).
> >
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> >   .../devicetree/bindings/sound/mvebu-audio.txt      | 29 ++++++++++++++++++++++
> >   sound/soc/kirkwood/kirkwood-i2s.c                  | 26 +++++++++++++++++-----
> >   2 files changed, 49 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/sound/mvebu-audio.txt b/Documentation/devicetree/bindings/sound/mvebu-audio.txt
> > new file mode 100644
> > index 0000000..7e5fd37
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/sound/mvebu-audio.txt
> > @@ -0,0 +1,29 @@
> > +* mvebu (Kirkwood, Dove, Armada 370) audio controller
> > +
> > +Required properties:
> > +
> > +- compatible: "mrvl,mvebu-audio"
> 
> Jean-Francois,
> 
> we need at least two more compatibles for the audio controller found on
> Dove and Kirkwood respectively. This is how we are going to distinguish
> those two, e.g. Kirkwood has SPDIF in which Dove hasn't.

Sebastian,

s/has/hasn't & s/hasn't/has

Are 2 compatibles enough, i.e. "mvebu-audio" and "mbevu-audio-spdif"?

> Also, we have used "marvell" as prefix for a long time. I know there has
> been discussion about the stock ticker appreviation, has there been any
> decision on that already?

Don't know, but, sure, there are still a lot of "mrvl".

> > +- reg: physical base address of the controller and length of memory mapped
> > +  region.
> > +
> > +- interrupts: list of two irq numbers.
> > +  The first irq is used for data flow and the second one is used for errors.
> > +
> > +- clocks: one or two phandles.
> > +  The first one is mandatory and defines the internal clock.
> > +  The second one is optional and defines an external clock.
> > +
> > +- clock-names: names associated to the clocks:
> > +	"internal" for the internal clock
> 
> s/internal/dcoclk/

Once, I got this message:

On Fri, 26 Jul 2013 10:21:56 +0100 Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Fri, Jul 26, 2013 at 11:09:13AM +0200, Jean-Francois Moine wrote:
> > The A510 documentation uses the names "DCO PLL" for the internal clock
> > and "AU_EXTCLK" for the external clock. So, what about "dcopll" and
> > "extclk"?
> 
> Stop naming them according to their source.  Their _consumer_ names
> not _source_ names.

But Russell did not tell clearly which name could be the best.

BTW, as we are naming the clocks, the 'clk' in "xxxclk" seems redondant...

> > +	"extclk" for the external clock
> > +
> > +Example:
> > +
> > +i2s1: audio-controller@b4000 {
> > +	compatible = "mrvl,mvebu-audio";
> > +	reg = <0xb4000 0x2210>;
> > +	interrupts = <21>, <22>;
> > +	clocks = <&gate_clk 13>;
> > +	clock-names = "internal";
> > +};
> 
> Also we will need some phandle reference to the audio codec here. As
> this property is ongoing work in ASoC core, I suggest we wait for it
> and propose a binding afterwards.

I don't think that we need any reference to the codec here. The glue is
done by the audio device. For example, using the (soon?) extended
simple audio card:

	spdif: spdif {
		compatible = "linux,spdif-dit";
	};
	sound {
		compatible = "linux,simple-audio";
		audio-controller = <&i2s1>;
		audio-codec = <&spdif>;
		codec-dai-name = "dit-hifi";
	};

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

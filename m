Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaCRIRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:17:22 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:53460 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbaCRIRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:17:18 -0400
X-Greylist: delayed 78832 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 04:17:17 EDT
Date: Tue, 18 Mar 2014 09:17:28 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH v3 4/4] ASoC: simple-card: Add DT documentation for
 multi-DAI links
Message-ID: <20140318091728.1d2240ca@armhf>
In-Reply-To: <20140317164339.GR11706@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
	<d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
	<20140317164339.GR11706@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 16:43:39 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Sat, Mar 15, 2014 at 12:30:05PM +0100, Jean-Francois Moine wrote:
	[snip]
> > +sound {
> > +	compatible = "simple-audio-card";
> > +	simple-audio-card,name = "Cubox Audio";
> > +
> > +	simple-audio-card,cpu@0 {		/* I2S - HDMI */
> > +		sound-dai = <&audio1 0>;
> > +		format = "i2s";
> > +	};
> > +	simple-audio-card,codec@0 {
> > +		sound-dai = <&tda998x 0>;
> > +	};
> > +
> > +	simple-audio-card,cpu@1 {		/* S/PDIF - HDMI */
> > +		sound-dai = <&audio1 1>;
> > +	};
> > +	simple-audio-card,codec@1 {
> > +		sound-dai = <&tda998x 1>;
> > +	};
> 
> So, this is not exactly pretty as a binding.  I would expect to see the
> links explicitly represented in the DT so you see the two DAIs in each
> link grouped into a container, the above isn't very easy to read and as
> Jyri says this lack of clarity also causes practical problems in that
> there's nowhere to place link specific parameters.
> 
> I think what I'd expect to see here is that the simple card can either
> be a container with a link in it directly or a container of links.

I agree. I see two possible syntaxes:

1) keep the same definitions in the containers:

sound {
	compatible = "simple-audio-card";
	simple-audio-card,name = "Cubox Audio";

	simple-audio-card,dai-link@0 {		/* I2S - HDMI */
		simple-audio-card,cpu {
			sound-dai = <&audio1 0>;
			format = "i2s";
		};
		simple-audio-card,codec {
			sound-dai = <&tda998x 0>;
		};
	};

	simple-audio-card,dai-link@1 {		/* S/PDIF - HDMI */
		simple-audio-card,cpu {
			sound-dai = <&audio1 1>;
		};
		simple-audio-card,codec {
			sound-dai = <&tda998x 1>;
		}
	};
	...

2) new definitions in the container

sound {
	compatible = "simple-audio-card";
	simple-audio-card,name = "Cubox Audio";

	simple-audio-card,dai-link@0 {		/* I2S - HDMI */
		format = "i2s";
		cpu-dai  = <&audio1 0>;
		codec-dai = <&tda998x 0>;
	};

	simple-audio-card,dai-link@1 {		/* S/PDIF - HDMI */
		cpu-dai = <&audio1 1>;
		codec-dai = <&tda998x 1>;
	};
	...

The 2nd syntax is simpler and clearer, but the properties of the CPU
DAI and of the CODEC DAI are the same in the container (format, clock
and PCM slots). Is this a problem?

BTW, there is a 'dai_fmt' in the DAI link, but this format is not used
in the simple-card. Why?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

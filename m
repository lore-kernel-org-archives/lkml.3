Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3LJKcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:32:15 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:48066
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab3LJKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:32:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Tue, 10 Dec 2013 18:25:24 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Nicolin Chen <b42378@freescale.com>, <lgirdwood@gmail.com>,
        <alsa-devel@alsa-project.org>, <tiwai@suse.de>, <perex@perex.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
Message-ID: <20131210102523.GB12042@MrMyself>
References: <cover.1386344000.git.b42378@freescale.com>
 <105d07ac1a77bf99872d75608c97b3342079bfb7.1386344000.git.b42378@freescale.com>
 <20131209175640.GL29268@sirena.org.uk>
 <20131210051740.GA10655@MrMyself>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131210051740.GA10655@MrMyself>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:18:42PM +0800, Nicolin Chen wrote:
> On Mon, Dec 09, 2013 at 05:56:40PM +0000, Mark Brown wrote:
> > On Fri, Dec 06, 2013 at 11:38:29PM +0800, Nicolin Chen wrote:
> > 
> > > +static int imx_hifi_hw_free(struct snd_pcm_substream *substream)
> > > +{
> > > +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> > > +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> > > +
> > > +	/* Don't diable FLL if still having multiple substreams running */
> > > +	if (codec_dai->active != 1)
> > > +		return 0;
> > > +
> > > +	return imx_wm8962_disable_fll(codec_dai);
> > 
> > This will still disable the FLL if there's an analogue bypass path
> > active.  I'd suggest changing enable() and disable() to reference count.
> 
> I was expecting this would disable it for further reconfiguration. But it
> seems I should also considerate the case using bypass path and normal PCM
> playback simultaneously, which looks a bit complex.

Hmm...Sorry for asking a stupid question that how to test bypass path with
WM8962? I've tried some amixer commands to enable the bypass-path switches.
But we still need to power the Codec up like using arecord or aplay to call
wm8962_resume() and DAPM-related, right?

Sir, could you please share a simple flow for user space so that I can test
and make the patch more comprehensive?

Thank you,
Nicolin Chen


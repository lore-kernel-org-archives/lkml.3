Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab3LFOr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:47:59 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:11613
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab3LFOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:47:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 6 Dec 2013 22:31:39 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
Message-ID: <20131206143138.GA29975@MrMyself>
References: <cover.1386322845.git.b42378@freescale.com>
 <bed76b8bfd2d4ed9739269657cd55e4a81b65403.1386322845.git.b42378@freescale.com>
 <20131206143433.GH29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131206143433.GH29268@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:34:33PM +0000, Mark Brown wrote:
> On Fri, Dec 06, 2013 at 05:47:43PM +0800, Nicolin Chen wrote:
> 
> > +static int imx_wm8962_enable_fll(struct snd_soc_dai *codec_dai, u32 sample_rate,
> > +				snd_pcm_format_t sample_format)
> > +{
> > +	struct imx_priv *priv = &card_priv;
> > +	struct device *dev = &priv->pdev->dev;
> > +	struct imx_wm8962_data *data = platform_get_drvdata(priv->pdev);
> > +	u32 freq, ret;
> > +
> > +	if (data->fll_lock)
> > +		return 0;
> 
> Don't we need an actual lock to protect this?

Thank you for the advice, I will revise it.

Best regards,
Nicolin Chen



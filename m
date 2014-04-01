Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaDAD70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:59:26 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:51600
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbaDAD7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:59:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehz98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
Date: Tue, 1 Apr 2014 11:37:59 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Wang Dongsheng-B40534 <Dongsheng.Wang@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Xiubo Li-B47053 <Li.Xiubo@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "timur@tabi.org" <timur@tabi.org>
Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
Message-ID: <20140401033758.GB26925@MrMyself>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
 <d00e324f09954dcbb509f8c135ad51af@BN1PR03MB188.namprd03.prod.outlook.com>
 <20140401031409.GA26925@MrMyself>
 <034c8b9a3822441dac07512ae2bbb1e7@BN1PR03MB188.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <034c8b9a3822441dac07512ae2bbb1e7@BN1PR03MB188.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:48:16AM +0800, Wang Dongsheng-B40534 wrote:
> 
> 
> > -----Original Message-----
> > From: Nicolin Chen [mailto:Guangyu.Chen@freescale.com]
> > Sent: Tuesday, April 01, 2014 11:14 AM
> > To: Wang Dongsheng-B40534
> > Cc: broonie@kernel.org; alsa-devel@alsa-project.org; Xiubo Li-B47053; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; timur@tabi.org
> > Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for
> > Tx and Rx streams
> > 
> > On Tue, Apr 01, 2014 at 11:25:02AM +0800, Wang Dongsheng-B40534 wrote:
> > > > Subject: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts for
> > Tx
> > > > and Rx streams
> > > >
> > > > We only enable one side interrupt for each stream since over/underrun
> > > > on the opposite stream would be resulted from what we previously did,
> > > > enabling TERE but remaining FRDE disabled, even though the xrun on the
> > > > opposite direction will not break the current stream.
> > > >
> > > > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > > > Acked-by: Xiubo Li <Li.Xiubo@freescale.com>
> > > > ---
> > > >  sound/soc/fsl/fsl_sai.c | 8 ++++++--
> > > >  sound/soc/fsl/fsl_sai.h | 1 +
> > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > > > index bdfd497..d64c33f 100644
> > > > --- a/sound/soc/fsl/fsl_sai.c
> > > > +++ b/sound/soc/fsl/fsl_sai.c
> > > > @@ -397,4 +397,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> > > > *substream, int cmd,
> > > >
> > > >  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > > +				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
> > > > +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > >  				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
> > > >  		break;
> > > > @@ -404,4 +406,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> > > > *substream, int cmd,
> > > >  		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > >  				   FSL_SAI_CSR_FRDE, 0);
> > > > +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> > > > +				   FSL_SAI_CSR_xIE_MASK, 0);
> > > >
> > > >  		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
> > > > @@ -464,6 +468,6 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
> > > >  	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
> > > >
> > > > -	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, FSL_SAI_FLAGS);
> > > > -	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, FSL_SAI_FLAGS);
> > > > +	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
> > > > +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
> > >
> > > Why are you remove this macro? Don't use magic number.
> > 
> > It's pretty clear that the so-called magic number is to clear the settings
> > in the registers for driver init as what this driver did at the first place
> > -- no offense but I don't think you would ask this if you check the git-log
> > of the driver.
> > 
> ~FSL_SAI_MASK is better than 0x0. And you also replace 0xffffffff.

I would later send a patch to reset SAI for a true init instead of these lines
but not within this patch as it's focusing on the interrupts enabling.

So please don't grasp the mask here. Just let me continue.

Thank you,
Nicolin Chen


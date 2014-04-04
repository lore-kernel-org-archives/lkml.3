Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaDDJrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:47:55 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:14247
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbaDDJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:47:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Fri, 4 Apr 2014 17:38:47 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH 1/2] ASoC: fsl_sai: Add clock control for SAI
Message-ID: <20140404093847.GB2735@MrMyself>
References: <cover.1396352401.git.Guangyu.Chen@freescale.com>
 <87d225a25812d730c0865f9d0bb733c67d8b3ed1.1396352401.git.Guangyu.Chen@freescale.com>
 <49295d4f0f0f42c4b9c6de77583b978e@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140404092804.GA2735@MrMyself>
 <f713ce2310f44ef883194429ba97d4a8@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f713ce2310f44ef883194429ba97d4a8@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 05:43:12PM +0800, Xiubo Li-B47053 wrote:
> > Subject: Re: [PATCH 1/2] ASoC: fsl_sai: Add clock control for SAI
> > 
> > Hi Xiubo,
> > 
> > On Fri, Apr 04, 2014 at 05:24:39PM +0800, Xiubo Li-B47053 wrote:
> > > Hi,
> > >
> > > I have test this series on my Vybrid-TWR board and it works happily.
> > 
> > You just checked the wrong version. I've sent a mail to let people disregard
> > this version and a newer v2.
> > 
> 
> Sorry, I didn't receive these, I will search it in the web page.
> 
> > >
> > > [...]
> > > > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > > > index 3847d2a..2d749df 100644
> > > > --- a/sound/soc/fsl/fsl_sai.c
> > > > +++ b/sound/soc/fsl/fsl_sai.c
> > > > @@ -428,5 +428,18 @@ static int fsl_sai_startup(struct snd_pcm_substream
> > > > *substream,
> > > >  {
> > > >  	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> > > > -	u32 reg;
> > > > +	struct device *dev = &sai->pdev->dev;
> > > > +	u32 reg, ret;
> > > > +
> > >
> > > I'd prefer:
> > >   +	int ret;
> > 
> > Just like last time I said, it would be converted to 'int' any way. There's
> > no much difference between them.
> > 
> 
> Yes, it is...
> 
> I have ever encounter something like this in the feature maybe someone will
> do the following check:
> 
> If (ret < 0)
> 	...
> 
> Just one potential problem and one suggestion.

Fine...I'll revise it as you wish..after you checked the v2.

Thanks,
Nicolin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaBJIbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:31:16 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17893
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaBJIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:31:13 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551biz98dI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h1155h)
Date: Mon, 10 Feb 2014 16:15:05 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: fsl-esai: fix ESAI TDM slot setting
Message-ID: <20140210081504.GA16574@MrMyself>
References: <1392014837-22308-1-git-send-email-Li.Xiubo@freescale.com>
 <20140210075031.GA16453@MrMyself>
 <5e5bb7d466fc4197939379273f11c4b6@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5e5bb7d466fc4197939379273f11c4b6@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:24:43PM +0800, Xiubo Li-B47053 wrote:
> Sorry, my misunderstanding about your comment.
> 
> Please ignore the last mail.
> 
> I will send v2 of this patch.

No, you don't need to.

Just rechecked it with RM. Your patch is correct.

I forgot I used A's WIDTH intentionally at the first place.

TSMA-> [15:0]
TSMB-> [31:16] -> higher 16bits.

Thus its shift should be corresponding to A's WIDTH.

The patch is fine. Acked.

Thank you.

> > > > diff --git a/sound/soc/fsl/fsl_esai.h b/sound/soc/fsl/fsl_esai.h
> > > > index 9c9f957..75e1403 100644
> > > > --- a/sound/soc/fsl/fsl_esai.h
> > > > +++ b/sound/soc/fsl/fsl_esai.h
> > > > @@ -322,7 +322,7 @@
> > > >  #define ESAI_xSMB_xS_SHIFT	0
> > > >  #define ESAI_xSMB_xS_WIDTH	16
> > > >  #define ESAI_xSMB_xS_MASK	(((1 << ESAI_xSMB_xS_WIDTH) - 1) <<
> > > ESAI_xSMB_xS_SHIFT)
> > > > -#define ESAI_xSMB_xS(v)		(((v) >> ESAI_xSMA_xS_WIDTH) &
> > > ESAI_xSMA_xS_MASK)
> > > > +#define ESAI_xSMB_xS(v)		(((v) >> ESAI_xSMA_xS_WIDTH) &
> > > ESAI_xSMB_xS_MASK)
> > >
> > > It should use ESAI_xSMB_xS_WIDTH.
> > >
> > 
> > Well, the ESAI_xSMB_xS_WIDTH is 0x0010(16), and ESAI_xSMB_xS_MASK will
> > be 0xFFFF.
> > 
> > 
> > 
> > Thanks,
> > 
> > --
> > Best Regards,
> > Xiubo



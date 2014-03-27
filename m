Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaC0Dqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 23:46:54 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:27819
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbaC0Dqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 23:46:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
Date: Thu, 27 Mar 2014 11:31:18 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Message-ID: <20140327033117.GD16197@MrMyself>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <11a8271c31044515bd2657a93aefdaec@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327023617.GB16197@MrMyself>
 <1e2d210764724c7e834c5307b54c37ab@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327025647.GC16197@MrMyself>
 <12f887b3889a41849026965f0cf7db1f@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <12f887b3889a41849026965f0cf7db1f@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 11:41:02AM +0800, Xiubo Li-B47053 wrote:
> 
> > Subject: Re: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
> > 
> > On Thu, Mar 27, 2014 at 10:53:50AM +0800, Xiubo Li-B47053 wrote:
> > > > On Thu, Mar 27, 2014 at 10:13:48AM +0800, Xiubo Li-B47053 wrote:
> > > > > > +	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
> > > > > > +	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);
> > > > > > +
> > > > > > +	if (xcsr & FSL_SAI_CSR_WSF)
> > > > > > +		dev_dbg(dev, "isr: Start of Tx word detected\n");
> > > > > > +
> > > > > > +	if (xcsr & FSL_SAI_CSR_SEF)
> > > > > > +		dev_dbg(dev, "isr: Tx Frame sync error detected\n");
> > > > > > +
> > > > > > +	if (xcsr & FSL_SAI_CSR_FEF)
> > > > > > +		dev_dbg(dev, "isr: Transmit underrun detected\n");
> > > > > > +
> > > > >
> > > > > Actually, the above three isrs should to write a logic 1 to this field
> > > > > to clear this flag.
> > > > >
> > > > >
> > > > > > +	if (xcsr & FSL_SAI_CSR_FWF)
> > > > > > +		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
> > > > > > +
> > > > > > +	if (xcsr & FSL_SAI_CSR_FRF)
> > > > > > +		dev_dbg(dev, "isr: Transmit FIFO watermark has been
> > reached\n");
> > > > > > +
> > > > >
> > > > > While are these ones really needed to clear manually ?
> > > >
> > > > The reference manual doesn't mention about the requirement. So SAI should
> > do
> > > > the self-clearance.
> > >
> > > Yes, I do think we should let it do the self-clearance, and shouldn't
> > interfere
> > > of them...
> > 
> > SAI is supposed to ignore the interference, isn't it?
> > 
> 
> Maybe, but I'm not very sure.
> And these bits are all writable and readable.

Double-confirmed? Because FWF and FRF should be read-only bits.



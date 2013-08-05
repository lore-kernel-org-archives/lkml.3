Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3HEJpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:45:00 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:38307
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230Ab3HEJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:44:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371Ic89bh542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Li Xiaochun-B41219 <B41219@freescale.com>,
        Wang Huan-B18965 <B18965@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "djbw@fb.com" <djbw@fb.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOkalqGPXHKXOLdUmC+rshJrmQD5mGPn+AgAAcKkA=
Date: Mon, 5 Aug 2013 09:44:55 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E851FC086@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
	<1375682824-11443-2-git-send-email-b35083@freescale.com>
 <20991.23049.78707.457046@ipc1.ka-ro>
In-Reply-To: <20991.23049.78707.457046@ipc1.ka-ro>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.98]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r759jEsY010542

> -----Original Message-----
> From: Lothar WaÃŸmann [mailto:LW@KARO-electronics.de]
> Sent: Monday, August 05, 2013 3:54 PM
> To: Lu Jingchang-B35083
> Cc: vinod.koul@intel.com; Li Xiaochun-B41219; Wang Huan-B18965; linux-
> kernel@vger.kernel.org; djbw@fb.com; shawn.guo@linaro.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support

> [...]
> > +	fsl_desc->n_tcds = sg_len;
> > +	for (i = 0; i < sg_len; i++) {
> > +		fsl_desc->tcd[i].vtcd = dma_pool_alloc(fsl_chan->tcd_pool,
> > +					GFP_ATOMIC, &fsl_desc->tcd[i].ptcd);
> >
> Why is this called with GFP_ATOMIC while fsl_desc above is being
> allocated with GFP_KERNEL?
[Lu Jingchang-B35083] 
 I will make these consistently. Thanks.
> 
> > +	for (ch = 0; ch < 32; ch++)
> > +		if (intr & (0x1 << ch))
> > +			break;
> > +
> What, if IRQs for multiple channels are pending at the same time?
> You could handle them all in one go without extra calls of the IRQ
> handler.
[Lu Jingchang-B35083] 
Yes, It will be more efficiently to handle all the irqs once. Thanks.
> 
> > +	writeb(EDMA_CINT_CINT(ch), base_addr + EDMA_CINT);
> > +
> > +	fsl_chan = &fsl_edma->chans[ch];
> > +
> > +	if (!fsl_chan->edesc->iscyclic) {
> > +		list_del(&fsl_chan->edesc->vdesc.node);
> >
> Ain't there any protection needed for the list operation?
[Lu Jingchang-B35083] 
Protection is needed indeed, I will fix this, thanks.
> 
> > +		clk_prepare_enable(fsl_edmamux->clk);
> >
> What, if this fails?
[Lu Jingchang-B35083] 
I will add code to check the return value. Thanks.
> 





Best Regards,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

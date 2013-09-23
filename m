Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3IWG7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:59:54 -0400
Received: from [216.32.180.30] ([216.32.180.30]:28196 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab3IWG7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:59:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I103dK542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>, "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOqh42n/m/IZ+OnUOyyFvNQ0U/dpnJb5uAgAAzEbCACTMNgIAAKM8Q
Date: Mon, 23 Sep 2013 06:56:37 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E852260F9@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1378374799-16357-1-git-send-email-b35083@freescale.com>
 <20130917045359.GN17188@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E85223E21@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130923042549.GC17188@intel.com>
In-Reply-To: <20130923042549.GC17188@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8N6xwDi014607


> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Monday, September 23, 2013 12:26 PM
> To: Lu Jingchang-B35083
> Cc: djbw@fb.com; shawn.guo@linaro.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
> 
> On Tue, Sep 17, 2013 at 08:08:46AM +0000, Lu Jingchang-B35083 wrote:
> > > > +	case DMA_PAUSE:
> > > > +		if (fsl_chan->edesc)
> > > > +			fsl_edma_disable_request(fsl_chan);
> > > racy here too...
> > It only set the channel HW register, no list is handled,
> > is lock needed here? Thanks!
> well thats the point while you are terminating the current trasnaction
> can
> complete and then start another one. You want to try and prevent these
> case
> also. Here you are neither locking the HW access nor the the list, so its
> juts
> waiting to crash!
Thanks! I have sent out the new v6 patch last week with holding lock here,
Could you please help review it?


Best Regards,
Jingchang



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

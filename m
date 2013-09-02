Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3IBHdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:33:00 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:49552
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab3IBHc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:32:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOmk6HmvW+8Uz+BkmoowcYjqk1XpmqWYUAgAAO9YCAB5LmAIAAJBEQ///5soCAAA2oYA==
Date: Mon, 2 Sep 2013 07:32:53 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E8520F101@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1376633274-17850-1-git-send-email-b35083@freescale.com>
 <20130828081742.GC11414@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520A8C7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130902045050.GE7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902063721.GK7376@intel.com>
In-Reply-To: <20130902063721.GK7376@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r827X6P5006360

> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Monday, September 02, 2013 2:37 PM
> To: Lu Jingchang-B35083
> Cc: shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
> 
> On Mon, Sep 02, 2013 at 07:10:53AM +0000, Lu Jingchang-B35083 wrote:
> > > -----Original Message-----
> > > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > > Sent: Monday, September 02, 2013 12:51 PM
> > > To: Lu Jingchang-B35083
> > > Cc: shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> > > kernel@lists.infradead.org; devicetree@vger.kernel.org
> > > Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver
> support
> > >
> > > On Thu, Aug 29, 2013 at 03:32:04AM +0000, Lu Jingchang-B35083 wrote:
> > >
> > > Please use a right MUA and wrap your lines at 80chars...
> 
> > > > [Lu Jingchang]
> > > No need to put your name :)
> > [Lu Jingchang-b35083]
> > Aha, the Microsoft Outlook adds this automatically with default option.
> You can change that!!
Thanks.
> > >
> > > > > > +static bool fsl_edma_filter_fn(struct dma_chan *chan, void
> > > *fn_param)
> > > > > > +{
> > > > > > +	struct fsl_edma_filter_param *fparam = fn_param;
> > > > > > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > > > > > +
> > > > > > +	if (fsl_chan->edmamux->mux_id != fparam->mux_id)
> > > > > > +		return false;
> > > > > > +
> > > > > > +	fsl_chan->slot_id = fparam->slot_id;
> > > > > > +	chan->private = fn_param;
> > > > > why do you need to use chan->private?
> > > > [Lu Jingchang]
> > > > The private used here is to store the slot_id information, which
> must
> > > be used
> > > > by the DMAMUX in alloc_chan_resources function. Thanks.
> > > Why dont you pass this in struct dma_slave_config memeber slave_id
> for
> > > this.
> > [Lu Jingchang-b35083]
> > I will drop this private and setup the slave_id directly in the filter
> function.
> why in filter? before calling prepare function you can set the slave
> config
How about change the filter_fn to follow:
static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
{
        struct fsl_edma_filter_param *fparam = fn_param;
        struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
        unsigned char val;

        if (fsl_chan->edmamux->mux_id != fparam->mux_id)
                return false;

        val = EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(fparam->slot_id);
        fsl_edmamux_config_chan(fsl_chan, val);
        return true;
}
In fact the slot_id isn't need elsewhere, and if the filter return true, 
This channel should be to this request. So no need to save the slave id, Right?



Best Regareds,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

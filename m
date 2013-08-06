Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3HFFQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:16:09 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:24731
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab3HFFQE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:16:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I103dK542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>, "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wang Huan-B18965 <B18965@freescale.com>,
        Li Xiaochun-B41219 <B41219@freescale.com>
Subject: RE: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOkalqGPXHKXOLdUmC+rshJrmQD5mG0A4AgACPSMCAADc7AIAAC/dw
Date: Tue, 6 Aug 2013 05:15:54 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E851FD6C6@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
 <1375682824-11443-2-git-send-email-b35083@freescale.com>
 <20130805163444.GQ29095@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E851FD63C@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130806042514.GR29095@intel.com>
In-Reply-To: <20130806042514.GR29095@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.98]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Tuesday, August 06, 2013 12:25 PM
> To: Lu Jingchang-B35083
> Cc: djbw@fb.com; shawn.guo@linaro.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; Wang Huan-B18965; Li Xiaochun-
> B41219
> Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
> 
> On Tue, Aug 06, 2013 at 01:24:31AM +0000, Lu Jingchang-B35083 wrote:
> > > -----Original Message-----
> > > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > > Sent: Tuesday, August 06, 2013 12:35 AM
> > > To: Lu Jingchang-B35083
> > > Cc: djbw@fb.com; shawn.guo@linaro.org; linux-kernel@vger.kernel.org;
> > > linux-arm-kernel@lists.infradead.org; Wang Huan-B18965; Li Xiaochun-
> > > B41219
> > > Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver
> > > support
> > > > +
> > > > +static void fsl_edma_free_desc(struct virt_dma_desc *vdesc) {
> > > > +	struct fsl_edma_desc *fsl_desc;
> > > > +	int i;
> > > > +
> > > > +	fsl_desc = to_fsl_edma_desc(vdesc);
> > > > +	for (i = 0; i < fsl_desc->n_tcds; i++)
> > > > +			dma_pool_free(fsl_desc->echan->tcd_pool,
> > > > +					fsl_desc->tcd[i].vtcd,
> > > > +					fsl_desc->tcd[i].ptcd);
> > > > +	kfree(fsl_desc);
> > > should this be called with lock held or not?
> > [Lu Jingchang-B35083]
> > The desc list to be freed is got with lock held, and the free for each
> desc is independent, and the lock is not needed. Thanks.
> Would be apt to add this comment in the code, so that people know this
> function needs to be always called with lock held!
[Lu Jingchang-B35083] 
Sorry, this function is called without lock held, I mean that the free() doesn't need the lock held, 
just as other drivers do.
It is called from vchan_free_chan_resources().
Thanks!


Best Regards,
Jingchang



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3JIEsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 00:48:05 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:28992
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab3JIEsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 00:48:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI9371I936eI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i2184m1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 1/7] powerpc: Add interface to get msi region information
Thread-Topic: [PATCH 1/7] powerpc: Add interface to get msi region
 information
Thread-Index: AQHOtQsCCE10MlaCVk+3VPe/9gzyOZnriWKAgABgYOA=
Date: Wed, 9 Oct 2013 04:47:19 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071A1526@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
 <1381273037.7979.298.camel@snotra.buserror.net>
In-Reply-To: <1381273037.7979.298.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r994mItB009052



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Wednesday, October 09, 2013 4:27 AM
> To: Bhushan Bharat-R65777
> Cc: alex.williamson@redhat.com; joro@8bytes.org; benh@kernel.crashing.org;
> galak@kernel.crashing.org; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-pci@vger.kernel.org; agraf@suse.de;
> iommu@lists.linux-foundation.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
> 
> On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> > @@ -376,6 +405,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
> >  	int len;
> >  	u32 offset;
> >  	static const u32 all_avail[] = { 0, NR_MSI_IRQS };
> > +	static int bank_index;
> >
> >  	match = of_match_device(fsl_of_msi_ids, &dev->dev);
> >  	if (!match)
> > @@ -419,8 +449,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
> >  				dev->dev.of_node->full_name);
> >  			goto error_out;
> >  		}
> > -		msi->msiir_offset =
> > -			features->msiir_offset + (res.start & 0xfffff);
> > +		msi->msiir = res.start + features->msiir_offset;
> > +		printk("msi->msiir = %llx\n", msi->msiir);
> 
> dev_dbg or remove

Oops, sorry it was leftover of debugging :(

> 
> >  	}
> >
> >  	msi->feature = features->fsl_pic_ip; @@ -470,6 +500,7 @@ static int
> > fsl_of_msi_probe(struct platform_device *dev)
> >  		}
> >  	}
> >
> > +	msi->bank_index = bank_index++;
> 
> What if multiple MSIs are boing probed in parallel?

Ohh, I have not thought that it can be called in parallel

>  bank_index is not atomic.

Will declare bank_intex as atomic_t and use atomic_inc_return(&bank_index)

> 
> > diff --git a/arch/powerpc/sysdev/fsl_msi.h
> > b/arch/powerpc/sysdev/fsl_msi.h index 8225f86..6bd5cfc 100644
> > --- a/arch/powerpc/sysdev/fsl_msi.h
> > +++ b/arch/powerpc/sysdev/fsl_msi.h
> > @@ -29,12 +29,19 @@ struct fsl_msi {
> >  	struct irq_domain *irqhost;
> >
> >  	unsigned long cascade_irq;
> > -
> > -	u32 msiir_offset; /* Offset of MSIIR, relative to start of CCSR */
> > +	dma_addr_t msiir; /* MSIIR Address in CCSR */
> 
> Are you sure dma_addr_t is right here, versus phys_addr_t?  It implies that it's
> the output of the DMA API, but I don't think the DMA API is used in the MSI
> driver.  Perhaps it should be, but we still want the raw physical address to
> pass on to VFIO.

Looking through the conversation I will make this phys_addr_t

> 
> >  	void __iomem *msi_regs;
> >  	u32 feature;
> >  	int msi_virqs[NR_MSI_REG];
> >
> > +	/*
> > +	 * During probe each bank is assigned a index number.
> > +	 * index number ranges from 0 to 2^32.
> > +	 * Example  MSI bank 1 = 0
> > +	 * MSI bank 2 = 1, and so on.
> > +	 */
> > +	int bank_index;
> 
> 2^32 doesn't fit in "int" (nor does 2^32 - 1).

Right :(

> 
> Just say that indices start at 0.

Will correct this

Thanks
-Bharat

> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

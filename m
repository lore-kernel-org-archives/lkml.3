Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab3B0MEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:04:31 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:52501
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab3B0ME3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:04:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: RE: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Topic: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Index: AQHODdfGismM9fsq90SfjKazZaDao5iNoBSAgAAIE4A=
Date: Wed, 27 Feb 2013 12:04:20 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3C26F6@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-2-git-send-email-Varun.Sethi@freescale.com>
 <20130227113045.GH26252@8bytes.org>
In-Reply-To: <20130227113045.GH26252@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,Ben,
I am implementing the Freescale PAMU (IOMMU) driver using the Linux IOMMU API. In this particular patch, I have added a new field to dev_archdata structure to store the dma domain information.
This field is updated whenever we attach a device to an iommu domain.

Regards
Varun

> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Wednesday, February 27, 2013 5:01 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; Wood Scott-B07421; Yoder Stuart-B08248
> Subject: Re: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information
> pointer in archdata.
> 
> On Mon, Feb 18, 2013 at 06:22:14PM +0530, Varun Sethi wrote:
> > Add a new field in the device (powerpc) archdata structure for storing
> > iommu domain information pointer. This pointer is stored when the
> > device is attached to a particular domain.
> >
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> > - no change.
> >  arch/powerpc/include/asm/device.h |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/device.h
> > b/arch/powerpc/include/asm/device.h
> > index 77e97dd..6dc79fe 100644
> > --- a/arch/powerpc/include/asm/device.h
> > +++ b/arch/powerpc/include/asm/device.h
> > @@ -28,6 +28,10 @@ struct dev_archdata {
> >  		void		*iommu_table_base;
> >  	} dma_data;
> >
> > +	/* IOMMU domain information pointer. This would be set
> > +	 * when this device is attached to an iommu_domain.
> > +	 */
> > +	void			*iommu_domain;
> 
> Please Cc the PowerPC Maintainers on this, so that they can have a look
> at it. This also must be put this into an #ifdef CONFIG_IOMMU_API.
> 
> 
> 	Joerg
> 
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3DCFVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:21:37 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:28180
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761928Ab3DCFVg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:21:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Id799hzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: RE: [PATCH 4/5 v11] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Topic: [PATCH 4/5 v11] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Index: AQHOK+8pPGq+LiDGlU6EDVNccUHNI5jDEHkAgADstjA=
Date: Wed, 3 Apr 2013 05:21:16 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D45047E@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-5-git-send-email-Varun.Sethi@freescale.com>
 <20130402151011.GH15687@8bytes.org>
In-Reply-To: <20130402151011.GH15687@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, April 02, 2013 8:40 PM
> To: Sethi Varun-B16395
> Cc: Yoder Stuart-B08248; Wood Scott-B07421; iommu@lists.linux-
> foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; galak@kernel.crashing.org;
> benh@kernel.crashing.org
> Subject: Re: [PATCH 4/5 v11] iommu/fsl: Add additional iommu attributes
> required by the PAMU driver.
> 
> On Fri, Mar 29, 2013 at 01:24:01AM +0530, Varun Sethi wrote:
> > +/* cache stash targets */
> > +enum stash_target {
> > +	IOMMU_ATTR_CACHE_L1 = 1,
> > +	IOMMU_ATTR_CACHE_L2,
> > +	IOMMU_ATTR_CACHE_L3,
> > +};
> > +
> > +/* This attribute corresponds to IOMMUs capable of generating
> > + * a stash transaction. A stash transaction is typically a
> > + * hardware initiated prefetch of data from memory to cache.
> > + * This attribute allows configuring stashig specific parameters
> > + * in the IOMMU hardware.
> > + */
> > +
> > +struct iommu_stash_attribute {
> > +	u32 	cpu;	/* cpu number */
> > +	u32 	cache;	/* cache to stash to: L1,L2,L3 */
> > +};
> > +
> 
> I would prefer these PAMU specific enum and struct to be in a pamu-
> specific iommu-header.
> 

[Sethi Varun-B16395] But, these would be used by the IOMMU API users (e.g. VFIO), they shouldn't depend on PAMU specific headers.

-Varun


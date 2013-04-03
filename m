Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab3DCP4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:56:05 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:24346
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761643Ab3DCP4D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:56:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Sethi Varun-B16395 <B16395@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>, Timur Tabi <timur@tabi.org>
CC: Joerg Roedel <joro@8bytes.org>, lkml <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHOMA3mO/4GVyqmPkuty25lenzG/ZjD84EAgACzKZA=
Date: Wed, 3 Apr 2013 15:55:36 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15035A1B2E@039-SN1MPN1-003.039d.mgd.msft.net>
References: <CAOZdJXWS50mpgMYu8o8K11yQFU6y-vNwxd9zPkqSd7euGt7XQg@mail.gmail.com>	(from
 timur@tabi.org on Tue Apr  2 20:35:54 2013) <1364953950.8690.4@snotra>
 <C5ECD7A89D1DC44195F34B25E172658D45040D@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D45040D@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.84.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Wednesday, April 03, 2013 12:12 AM
> To: Wood Scott-B07421; Timur Tabi
> Cc: Joerg Roedel; lkml; Kumar Gala; Yoder Stuart-B08248; iommu@lists.linux-foundation.org; Benjamin
> Herrenschmidt; linuxppc-dev@lists.ozlabs.org
> Subject: RE: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu implementation.
> 
> 
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Wednesday, April 03, 2013 7:23 AM
> > To: Timur Tabi
> > Cc: Joerg Roedel; Sethi Varun-B16395; lkml; Kumar Gala; Yoder Stuart-
> > B08248; iommu@lists.linux-foundation.org; Benjamin Herrenschmidt;
> > linuxppc-dev@lists.ozlabs.org
> > Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
> > implementation.
> >
> > On 04/02/2013 08:35:54 PM, Timur Tabi wrote:
> > > On Tue, Apr 2, 2013 at 11:18 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > >
> > > > > +     panic("\n");
> > > >
> > > > A kernel panic seems like an over-reaction to an access violation.
> > >
> > > We have no way to determining what code caused the violation, so we
> > > can't just kill the process.  I agree it seems like overkill, but what
> > > else should we do?  Does the IOMMU layer have a way for the IOMMU
> > > driver to stop the device that caused the problem?
> >
> > At a minimum, log a message and continue.  Probably turn off the LIODN,
> > at least if it continues to be noisy (otherwise we could get stuck in an
> > interrupt storm as you note).  Possibly let the user know somehow,
> > especially if it's a VFIO domain.
> [Sethi Varun-B16395] Can definitely log the message and disable the LIODN (to avoid an interrupt storm),
> but
> we definitely need a mechanism to inform vfio subsystem about the error. Also, disabling LIODN may not
> be a viable
> option with the new LIODN allocation scheme (where LIODN would be associated with a domain).

I think for phase 1 of this, just log the error, shut down DMA as you described.
We can implement more full featured error management, like notifying vfio
or the VM somehow in the future.

Stuart



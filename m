Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3JHDmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:42:53 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:20992
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab3JHDmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:42:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 2/7] iommu: add api to get iommu_domain of a device
Thread-Topic: [PATCH 2/7] iommu: add api to get iommu_domain of a device
Thread-Index: AQHOtQsGaQsPvJ8CfEu+dkEJoOsdkZnWszeAgA2xFOCAAGMFgIAAC5rAgAAM6gCAAABh8IAAECcAgAPjuzCAAWppAIAABe8A
Date: Tue, 8 Oct 2013 03:42:45 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071950B2@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-3-git-send-email-Bharat.Bhushan@freescale.com>
	 <1380127533.3030.319.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0718FD1C@039-SN2MPN1-011.039d.mgd.msft.net>
	 <1380901507.2673.204.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07190F35@039-SN2MPN1-011.039d.mgd.msft.net>
	 <1380906772.25705.19.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07191143@039-SN2MPN1-011.039d.mgd.msft.net>
	 <1380910322.25705.56.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0719385B@039-SN2MPN1-011.039d.mgd.msft.net>
 <1381201980.6330.4.camel@ul30vt.home>
In-Reply-To: <1381201980.6330.4.camel@ul30vt.home>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r983h3uZ032508

> > > Do you really want module dependencies between vfio and your core
> > > kernel MSI setup?  Look at the vfio external user interface that we've
> already defined.
> > > That allows other components of the kernel to get a proper reference
> > > to a vfio group.  From there you can work out how to get what you
> > > want.  Another alternative is that vfio could register an MSI to
> > > IOVA mapping with architecture code when the mapping is created.
> > > The MSI setup path could then do a lookup in architecture code for
> > > the mapping.  You could even store the MSI to IOVA mapping in VFIO
> > > and create an interface where SET_IRQ passes that mapping into setup code.
> >
> > Ok, What I want is to get IOVA associated with a physical address
> > (physical address of MSI-bank).
> > And currently I do not see a way to know IOVA of a physical address
> > and doing all this domain get and then search through all of
> > iommu-windows of that domain.
> >
> > What if we add an iommu-API which can return the IOVA mapping of a
> > physical address. Current use case is setting up MSI's for aperture
> > type of IOMMU also getting a phys_to_iova() mapping is independent of
> > VFIO, your thought?
> 
> A physical address can be mapped to multiple IOVAs, so the interface seems
> flawed by design.  It also has the same problem as above, it's a backdoor that
> can be called asynchronous to the owner of the domain, so what reason is there
> to believe the result?  It just replaces an iommu_domain pointer with an IOVA.
> VFIO knows this mapping, so why are we trying to go behind its back and ask the
> IOMMU?
IOMMU is the final place where mapping is created, so may be today it is calling on behalf of VFIO, tomorrow it can be for normal Linux or some other interface. But I am fine to directly talk to vfio and will not try to solve a problem which does not exists today.

MSI subsystem knows pdev (pci device) and physical address, then what interface it will use to get the IOVA from VFIO?

Thanks
-Bharat

>  Thanks,
> 
> Alex
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

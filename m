Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812Ab3DDNAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:00:45 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:50169
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760365Ab3DDNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:00:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432Id799h4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: RE: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHOK+8t5MYhVlGTF0iQ16GsJktLA5jDI3qAgAGvMoCAATtRIA==
Date: Thu, 4 Apr 2013 13:00:23 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D45883B@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
	 <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
	 <20130402161812.GI15687@8bytes.org> <1365012091.2882.252.camel@bling.home>
In-Reply-To: <1365012091.2882.252.camel@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.237]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r34D0hYl002809



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, April 03, 2013 11:32 PM
> To: Joerg Roedel
> Cc: Sethi Varun-B16395; Yoder Stuart-B08248; Wood Scott-B07421;
> iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; galak@kernel.crashing.org;
> benh@kernel.crashing.org
> Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
> implementation.
> 
> On Tue, 2013-04-02 at 18:18 +0200, Joerg Roedel wrote:
> > Cc'ing Alex Williamson
> >
> > Alex, can you please review the iommu-group part of this patch?
> 
> Sure, it looks pretty reasonable.  AIUI, all PCI devices are below some
> kind of host bridge that is either new and supports partitioning or old
> and doesn't.  I don't know if that's a visibility or isolation
> requirement, perhaps PCI ACS-ish.  In the new host bridge case, each
> device gets a group.  This seems not to have any quirks for multifunction
> devices though.  On AMD and Intel IOMMUs we test multifunction device ACS
> support to determine whether all the functions should be in the same
> group.  Is there any reason to trust multifunction devices on PAMU?
> 
[Sethi Varun-B16395] In the case where we can partition endpoints we can distinguish transactions based on the bus,device,function number combination. This support is available in the PCIe controller (host bridge).

> I also find it curious what happens to the iommu group of the host
> bridge.  In the partitionable case the host bridge group is removed, in
> the non-partitionable case the host bridge group becomes the group for
> the children, removing the host bridge.  It's unique to PAMU so far that
> these host bridges are even in an iommu group (x86 only adds pci
> devices), but I don't see it as necessarily wrong leaving it in either
> scenario.  Does it solve some problem to remove them from the groups?
> Thanks,
[Sethi Varun-B16395] The PCIe controller isn't a partitionable entity, it would always be owned by the host.

-Varun

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

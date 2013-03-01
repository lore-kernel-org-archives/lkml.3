Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3CAQWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:22:06 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:6022 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab3CAQWE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:22:04 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9hbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sethi Varun-B16395 <B16395@freescale.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Joerg Roedel <joro@8bytes.org>, Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: RE: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Topic: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Index: AQHOFN3gD3TFzHsUwUSBVpo19drGMpiNm2oAgAHRxICAAKA/gIAAfeYAgAAUBACAAGagoA==
Date: Fri, 1 Mar 2013 16:21:57 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E1503565876@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-2-git-send-email-Varun.Sethi@freescale.com>
 <20130227113045.GH26252@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D3C26F6@039-SN2MPN1-013.039d.mgd.msft.net>
 <BAB98EA5-5324-4FB2-97C2-A28A96C569DC@kernel.crashing.org>
 <51300367.6080300@ozlabs.ru>
 <C5ECD7A89D1DC44195F34B25E172658D3C802F@039-SN2MPN1-013.039d.mgd.msft.net>
 <51307DCE.1050506@ozlabs.ru>
In-Reply-To: <51307DCE.1050506@ozlabs.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.82.121.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexey Kardashevskiy [mailto:aik@ozlabs.ru]
> Sent: Friday, March 01, 2013 4:07 AM
> To: Sethi Varun-B16395
> Cc: Kumar Gala; Benjamin Herrenschmidt; iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org
> list; linux-kernel@vger.kernel.org list; Wood Scott-B07421; Yoder Stuart-B08248; Joerg Roedel; Paul
> Mackerras; David Gibson; Alex Williamson
> Subject: Re: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information pointer in archdata.
> 
> btw the device struct already has a pointer to its iommu_group, and the
> iommu_group struct itself has a pointer void *iommu_data which you could
> use for anything you want (iommu_group_get_iommudata(),
> iommu_group_set_iommudata()).
>
> By design you are expected to add iommu groups to a domain but not devices
> so I am not so sure that you really need a pointer to domain in the device
> struct.

Well, at the lowest level the IOMMU API does attach devices to domains-- i.e.
API attach_dev().  So, it seems to conceptually make sense to have a ptr
from the device to the associated domain.  When you implement attach_dev()
you need to be able to see whether the device is already attached to
a domain.   Adding a couple of levels of indirection...from device to
group to domain...doesn't seems to make things simpler or better IMHO.

x86 keeps a pointer to the domain in device archdata and since there is
a direct correlation between a device and domain I'd rather see it
where this patch has it.

Stuart


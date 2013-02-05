Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3BEKxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:53:39 -0500
Received: from [216.32.180.186] ([216.32.180.186]:40926 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751378Ab3BEKxh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:53:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Stuart Yoder <b08248@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Thread-Topic: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Thread-Index: AQHOAto2wzGTacmHgEKF4kls7teXNphq9JTwgAAgjICAAACt0A==
Date: Tue, 5 Feb 2013 10:52:03 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3752B1@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-6-git-send-email-joro@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D373D2B@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130205104155.GR25591@8bytes.org>
In-Reply-To: <20130205104155.GR25591@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DOMAIN_ATTR_PAMU_ENABLE is required to enable a particular DMA window. My point is about the domain geometry, which is incomplete in case of PAMU without the number of subwindows. Geometry parameters are used for initializing the PAMU window settings. Individual subwindows can only be enabled, once the PAMU window has been initialized using the geometry settings.

Regards
Varun


> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, February 05, 2013 4:12 PM
> To: Sethi Varun-B16395
> Cc: Stuart Yoder; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org; Wood Scott-B07421
> Subject: Re: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
> 
> Hi,
> 
> On Tue, Feb 05, 2013 at 09:14:40AM +0000, Sethi Varun-B16395 wrote:
> > In case of PAMU, geometry would be meaningless without specifying the
> > number of subwindows. If the API user specifies a geometry but fails
> > to specify the number of required subwindows, we would assume a
> > default (max supported) value, which may be incorrect. It's going to
> > be really ugly. I think we should add the number of sub windows to the
> > domain geometry. This parameter would be used in case of a window
> > based iommu. So, a separate set_window API wouldn't be required.
> 
> I think this can all be implemented with the interface proposed here
> together with a PAMU-specific DOMAIN_ATTR_PAMU_ENABLE attribute. Stuart
> outlined in his RFC mail how this can be done. I don't consider this
> ugly, it is rather a clean tradeoff between putting functionality into
> the generic part of the IOMMU-API and putting it into the PAMU specific
> part.
> 
> Regards,
> 
> 	Joerg
> 
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3BERPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:15:53 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:5943
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755980Ab3BERPv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:15:51 -0500
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
Thread-Index: AQHOAto2wzGTacmHgEKF4kls7teXNphq9JTwgAAgjICAAACt0IAAJ3UAgAAvmeA=
Date: Tue, 5 Feb 2013 17:15:45 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3792D4@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-6-git-send-email-joro@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D373D2B@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130205104155.GR25591@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D3752B1@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130205130534.GS25591@8bytes.org>
In-Reply-To: <20130205130534.GS25591@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, February 05, 2013 6:36 PM
> To: Sethi Varun-B16395
> Cc: Stuart Yoder; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org; Wood Scott-B07421
> Subject: Re: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
> 
> On Tue, Feb 05, 2013 at 10:52:03AM +0000, Sethi Varun-B16395 wrote:
> > DOMAIN_ATTR_PAMU_ENABLE is required to enable a particular DMA window.
> > My point is about the domain geometry, which is incomplete in case of
> > PAMU without the number of subwindows. Geometry parameters are used
> > for initializing the PAMU window settings. Individual subwindows can
> > only be enabled, once the PAMU window has been initialized using the
> > geometry settings.
> 
> I understand that. What you do is:
> 
> 	/* Set geometry */
> 	set_attr(domain, DOMAIN_ATTR_GEOMETRY);
> 
> 	/* Set number of PAMU subwindows */
> 	set_attr(domain, DOMAIN_ATTR_WINDOWS);
> 
> 	/* Commit changes to hardware and enable the window */
> 	set_attr(domain, DOMAIN_ATTR_PAMU_ENABLE);
> 
> And I don't see any problem with that. The domain_attr interface was
> introduced to cope with device specifics, we don't change global
> interface data structures for that.
> 
> 
[Sethi Varun-B16395] But, then it would be mandatory to set the DOMAIN_ATTR_WINDOWS attribute in case of PAMU. I guess that it would be implementation specific. I am fine with the API.

-Varun


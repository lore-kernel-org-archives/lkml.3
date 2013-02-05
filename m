Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3BEDvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:51:45 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:22542
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab3BEDvo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:51:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946hbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>, Joerg Roedel <joro@8bytes.org>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] iommu: Add domain window handling functions
Thread-Topic: [PATCH 4/4] iommu: Add domain window handling functions
Thread-Index: AQHOAzBxxvWr3lRlWEqDAJflSPVsqJhqmj5Q
Date: Tue, 5 Feb 2013 03:41:03 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E150354A1DC@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
	<1359582228-21552-5-git-send-email-joro@8bytes.org>
	<C5ECD7A89D1DC44195F34B25E172658D3670ED@039-SN2MPN1-013.039d.mgd.msft.net>
	<20130204130214.GN25591@8bytes.org> <1360020980.14901.17@snotra>
In-Reply-To: <1360020980.14901.17@snotra>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Monday, February 04, 2013 5:36 PM
> To: Joerg Roedel
> Cc: Sethi Varun-B16395; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Wood Scott-
> B07421; Yoder Stuart-B08248
> Subject: Re: [PATCH 4/4] iommu: Add domain window handling functions
> 
> On 02/04/2013 07:02:14 AM, Joerg Roedel wrote:
> > On Thu, Jan 31, 2013 at 09:32:26AM +0000, Sethi Varun-B16395 wrote:
> > > We need a mechanism to determine the maximum number of subwindows
> > supported by PAMU. How about representing it in the iommu_domain
> > structure:
> > > struct  iommu_domain {
> > > 	struct iommu_ops *ops;
> > > 	void *priv;
> > > 	iommu_fault_handler_t handler;
> > > 	void *handler_token;
> > > 	struct iommu_domain_geometry geometry;
> > > 	u32 max_sub_windows; -----> maximum number of sub windows
> > supported by the hardware.
> > > }
> >
> > I`ll leave that flag to the private-data of the IOMMU domain. Instead
> > I
> > added a DOMAIN_ATTR_WINDOWS attribute to get/set the number of
> > subwindows. I'll post the updated patch-set soon.
> 
> If it's private data, how does the caller know what sort of geometry it
> can request?

The way I thought this could work based on the patch that Joerg posted today
was that when the domain is created the caller could read the DOMAIN_ATTR_WINDOWS 
domain_get_windows() to determine the max.  The initial/default value is the
max.  The caller could then set a smaller value if they wanted to.

Stuart


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3BDXg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:36:28 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:34351
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033Ab3BDXg1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:36:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h1155h)
Date: Mon, 4 Feb 2013 17:36:20 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 4/4] iommu: Add domain window handling functions
To: Joerg Roedel <joro@8bytes.org>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
	<1359582228-21552-5-git-send-email-joro@8bytes.org>
	<C5ECD7A89D1DC44195F34B25E172658D3670ED@039-SN2MPN1-013.039d.mgd.msft.net>
	<20130204130214.GN25591@8bytes.org>
In-Reply-To: <20130204130214.GN25591@8bytes.org> (from joro@8bytes.org on
	Mon Feb  4 07:02:14 2013)
X-Mailer: Balsa 2.4.11
Message-ID: <1360020980.14901.17@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 07:02:14 AM, Joerg Roedel wrote:
> On Thu, Jan 31, 2013 at 09:32:26AM +0000, Sethi Varun-B16395 wrote:
> > We need a mechanism to determine the maximum number of subwindows  
> supported by PAMU. How about representing it in the iommu_domain  
> structure:
> > struct  iommu_domain {
> > 	struct iommu_ops *ops;
> > 	void *priv;
> > 	iommu_fault_handler_t handler;
> > 	void *handler_token;
> > 	struct iommu_domain_geometry geometry;
> > 	u32 max_sub_windows; -----> maximum number of sub windows  
> supported by the hardware.
> > }
> 
> I`ll leave that flag to the private-data of the IOMMU domain. Instead  
> I
> added a DOMAIN_ATTR_WINDOWS attribute to get/set the number of
> subwindows. I'll post the updated patch-set soon.

If it's private data, how does the caller know what sort of geometry it  
can request?

-Scott

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaHRX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 19:28:35 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57329 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaHRX2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:28:34 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
Thread-Topic: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
Thread-Index: AQHPusLtJD7eZgXm8U+STnK1YS2mE5vW+l6ggAAG8ACAAADm4A==
Date: Mon, 18 Aug 2014 23:27:01 +0000
Message-ID: <1267BB84A242B24E81E0C0C8955CFFC061A4CA69@G9W0343.americas.hpqcorp.net>
References: <1408352352-14449-1-git-send-email-zhen-hual@hp.com>
 <1267BB84A242B24E81E0C0C8955CFFC061A4BA26@G9W0343.americas.hpqcorp.net>
 <20140818232328.GK9809@8bytes.org>
In-Reply-To: <20140818232328.GK9809@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

: [fault reason 01] Present bit in root entry is clear
It appears when iommu initializing in the kdump kernel.

-----Original Message-----
From: Joerg Roedel [mailto:joro@8bytes.org] 
Sent: Tuesday, August 19, 2014 7:23 AM
To: Li, Zhen-Hua
Cc: David Woodhouse; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel

On Mon, Aug 18, 2014 at 11:01:56PM +0000, Li, Zhen-Hua wrote:
> There is a bug when Linux running on an HP large system: 
> 	when kdump kernel runs, the hardware is still using the old 
> root entry. This causes error message when iommu not finished initialization.

What error message are you seeing? When the kdump kernel boots the iommu
should be still enabled from the old kernel with the old root-entry. So
any in-flight DMA initiated from the old kernel can still pass and there
should be no error messages.

When you clear the root-entry that in-flight DMA might go to another
random location in system memory or just fail, no?


	Joerg


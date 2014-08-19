Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaHSFvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:51:02 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:48955 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaHSFvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:51:01 -0400
Message-ID: <53F2E55D.6000405@hp.com>
Date: Tue, 19 Aug 2014 13:49:17 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
References: <1408352352-14449-1-git-send-email-zhen-hual@hp.com> <1267BB84A242B24E81E0C0C8955CFFC061A4BA26@G9W0343.americas.hpqcorp.net> <20140818232328.GK9809@8bytes.org>  <1267BB84A242B24E81E0C0C8955CFFC061A4CA86@G9W0343.americas.hpqcorp.net> <1267BB84A242B24E81E0C0C8955CFFC061A4DACB@G9W0343.americas.hpqcorp.net>
In-Reply-To: <1267BB84A242B24E81E0C0C8955CFFC061A4DACB@G9W0343.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found there are more data need to be cleared for the dump kernel.
So please ignore this patch, I will send out another one.

Thanks
Zhenhua

On 08/19/2014 07:59 AM, Li, Zhen-Hua wrote:
> My debugging result is this:
>
> 1. Clear the old root entry table, dump kernel will choose another
>   memory region for root entry.
> 2. Do NOT clear the old root entry, when dump kernel initializing
> the iommu data structure, it  will allocate memory for root entry,
> this is different from the old address.
>
> If not clear old entry , the error message appears before dump kernel
> finishes the iommu init works, and also appears in other places(before
> device inits).
>
> If I clear the old root entry, the error message disappears before iommu
> init work finish, but still appears in other places.
>
> -----Original Message-----
> From: Li, Zhen-Hua
> Sent: Tuesday, August 19, 2014 7:48 AM
> To: Li, Zhen-Hua; Joerg Roedel
> Cc: David Woodhouse; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
>
> When the dump kernel boots, it will initialize iommu again, and the root entry will be allocted
> in another memory region.
>
> That means, no matter kernel clears the old root entry table or not,  the dump kernel will use
> another memory region when iommu initializing.
>
> -----Original Message-----
> From: Li, Zhen-Hua
> Sent: Tuesday, August 19, 2014 7:27 AM
> To: 'Joerg Roedel'
> Cc: David Woodhouse; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
>
> : [fault reason 01] Present bit in root entry is clear
> It appears when iommu initializing in the kdump kernel.
>
> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, August 19, 2014 7:23 AM
> To: Li, Zhen-Hua
> Cc: David Woodhouse; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
>
> On Mon, Aug 18, 2014 at 11:01:56PM +0000, Li, Zhen-Hua wrote:
>> There is a bug when Linux running on an HP large system:
>> 	when kdump kernel runs, the hardware is still using the old
>> root entry. This causes error message when iommu not finished initialization.
> What error message are you seeing? When the kdump kernel boots the iommu
> should be still enabled from the old kernel with the old root-entry. So
> any in-flight DMA initiated from the old kernel can still pass and there
> should be no error messages.
>
> When you clear the root-entry that in-flight DMA might go to another
> random location in system memory or just fail, no?
>
>
> 	Joerg
>


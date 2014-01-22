Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaAVTEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:04:04 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55490 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbaAVTDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:03:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,701,1384300800"; 
   d="scan'208";a="95452172"
Message-ID: <52E015F5.70408@citrix.com>
Date: Wed, 22 Jan 2014 19:03:17 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [Xen-devel] [PATCH v4] xen/grant-table: Avoid m2p_override during
 mapping
References: <1390335755-29328-1-git-send-email-zoltan.kiss@citrix.com> <alpine.DEB.2.02.1401221618340.21510@kaball.uk.xensource.com> <52E00FB7.3040508@citrix.com> <alpine.DEB.2.02.1401221848080.21510@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1401221848080.21510@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/14 18:50, Stefano Stabellini wrote:
> On Wed, 22 Jan 2014, Zoltan Kiss wrote:
>> On 22/01/14 16:39, Stefano Stabellini wrote:
>>> On Tue, 21 Jan 2014, Zoltan Kiss wrote:
>>>> @@ -121,7 +125,7 @@ static inline unsigned long mfn_to_pfn(unsigned long
>>>> mfn)
>>>>    		pfn = m2p_find_override_pfn(mfn, ~0);
>>>>    	}
>>>>
>>>> -	/*
>>>> +	/*
>>>
>>> Spurious change?
>> It removes a stray space from the original code. Not necessary, but if it's
>> there, I think we can keep it.
>
> Usually cosmetic changes are done in a separate patch, or at the very
> least they are mentioned in the commit message.
Ok, I'll mention it.
>
>
>>>> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
>>>> index 2ae8699..0060178 100644
>>>> --- a/arch/x86/xen/p2m.c
>>>> +++ b/arch/x86/xen/p2m.c
>>>> @@ -872,15 +872,13 @@ static unsigned long mfn_hash(unsigned long mfn)
>>>>
>>>>    /* Add an MFN override for a particular page */
>>>>    int m2p_add_override(unsigned long mfn, struct page *page,
>>>> -		struct gnttab_map_grant_ref *kmap_op)
>>>> +		struct gnttab_map_grant_ref *kmap_op, unsigned long pfn)
>>>
>>> Do we really need to add another additional parameter to
>>> m2p_add_override?
>>> I would just let m2p_add_override and m2p_remove_override call
>>> page_to_pfn again. It is not that expensive.
>> Yes, because that page_to_pfn can return something different. That's why the
>> v2 patches failed.
>
> I am really curious: how can page_to_pfn return something different?
> I don't think is supposed to happen.
You call set_phys_to_machine before calling m2p* functions.

Zoli


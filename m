Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaBSM2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:28:03 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29037 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBSM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:28:01 -0500
X-IronPort-AV: E=Sophos;i="4.97,505,1389744000"; 
   d="scan'208";a="102155025"
Message-ID: <5304A34E.1090503@citrix.com>
Date: Wed, 19 Feb 2014 12:27:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <xen-devel@lists.xenproject.org>,
        <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next v5 2/9] xen-netback: Change TX path
 from grant copy to mapping
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>		<1390253069-25507-3-git-send-email-zoltan.kiss@citrix.com>	 <1392745235.23084.60.camel@kazak.uk.xensource.com>	 <5303AA97.3010202@citrix.com> <1392803670.23084.100.camel@kazak.uk.xensource.com>
In-Reply-To: <1392803670.23084.100.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/14 09:54, Ian Campbell wrote:
> On Tue, 2014-02-18 at 18:46 +0000, David Vrabel wrote:
>> On 18/02/14 17:40, Ian Campbell wrote:
>>> On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
>>>>
>>>> @@ -344,8 +346,26 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
>>>>  	vif->pending_prod = MAX_PENDING_REQS;
>>>>  	for (i = 0; i < MAX_PENDING_REQS; i++)
>>>>  		vif->pending_ring[i] = i;
>>>> -	for (i = 0; i < MAX_PENDING_REQS; i++)
>>>> -		vif->mmap_pages[i] = NULL;
>>>> +	spin_lock_init(&vif->dealloc_lock);
>>>> +	spin_lock_init(&vif->response_lock);
>>>> +	/* If ballooning is disabled, this will consume real memory, so you
>>>> +	 * better enable it.
>>>
>>> Almost no one who would be affected by this is going to read this
>>> comment. And it doesn't just require enabling ballooning, but actually
>>> booting with some maxmem "slack" to leave space.
>>>
>>> Classic-xen kernels used to add 8M of slop to the physical address space
>>> to leave a suitable pool for exactly this sort of thing. I never liked
>>> that but perhaps it should be reconsidered (or at least raised as a
>>> possibility with the core-Xen Linux guys).
>>
>> I plan to fix the balloon memory hotplug stuff to do the right thing
> 
> Which is for alloc_xenballoon_pages to hotplug a new empty region,
> rather than inflating the balloon if it doesn't have enough pages to
> satisfy the allocation?

Yes.

David

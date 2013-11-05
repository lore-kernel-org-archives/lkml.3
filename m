Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3KEVuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:50:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:59771 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab3KEVuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:50:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,641,1378882800"; 
   d="scan'208";a="422792173"
Message-ID: <52796916.3010703@linux.intel.com>
Date: Tue, 05 Nov 2013 13:54:30 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <Pine.LNX.4.44L0.1311051039250.1360-100000@iolanthe.rowland.org> <52793566.9080704@linux.intel.com>
In-Reply-To: <52793566.9080704@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 10:13 AM, David Cohen wrote:
> On 11/05/2013 07:41 AM, Alan Stern wrote:
>> On Tue, 5 Nov 2013, David Cohen wrote:
>>
>>>>> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
>>>>> +{
>>>>> +	int aligned;
>>>>> +
>>>>> +	if (ep->desc->bmAttributes & USB_ENDPOINT_XFER_INT)
>>>>> +		/*
>>>>> +		 * Interrupt eps don't need max packet size to be power of 2,
>>>>> +		 * so can't use cheap IS_ALIGNED() macro.
>>>>> +		 */
>>>>> +		aligned = !(len % ep->desc->wMaxPacketSize);
>>>>> +	else
>>>>> +		aligned = IS_ALIGNED(len, ep->desc->wMaxPacketSize);
>>>>
>>>> This isn't on a hot path, and I suspect that the extra "if" will
>>>> require nearly as much time as you save by not doing the division.  You
>>>> might as well always use the % operation.
>>>
>>> Perhaps if I use unlikely() on 'if' condition instead?
>>> Anyway I'll double check the costs of if + IS_ALIGNED vs modulo.
>>
>> You're missing the point.  You and I (not to mention anybody who ever
>> reads this code in the future) have already wasted more time talking
>> about it and trying to understand it than you will ever save by using
>> IS_ALIGNED.
>>
>> The difference to the computer is minimal at best.  Make things easier
>> for the programmers.
>
> I don't see it as complex :)
> But I'm fine with your proposal. I can send new patch dropping
> IS_ALIGNED() case.

At a second though, it's even better to drop both 'if' cases.
I can just return round_up(...) directly.

Br, David


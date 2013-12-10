Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3LJDhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:37:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:63103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3LJDh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:37:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,862,1378882800"; 
   d="scan'208";a="422043477"
Message-ID: <52A68BF7.2080901@linux.intel.com>
Date: Mon, 09 Dec 2013 19:35:19 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com> <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com> <xa1t7gbdfn8c.fsf@mina86.com>
In-Reply-To: <xa1t7gbdfn8c.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 06:34 PM, Michal Nazarewicz wrote:
> dOn Tue, Dec 10 2013, David Cohen wrote:
>> Due to USB controllers may have different restrictions, usb gadget layer
>> needs to provide a generic way to inform gadget functions to complain
>> with non-standard requirements.
>>
>> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
>> to inform when controller's epout requires buffer size to be aligned to
>> MaxPacketSize. A helper is also provided to align buffer size when
>> necessary.
>>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
>> ---
>>  include/linux/usb/gadget.h | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>> index 23b3bfd0a842..cae8a6216551 100644
>> --- a/include/linux/usb/gadget.h
>> +++ b/include/linux/usb/gadget.h
>> @@ -502,6 +502,8 @@ struct usb_gadget_ops {
>>   *	only supports HNP on a different root port.
>>   * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
>>   *	enabled HNP support.
>> + * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned to
>> + *	MaxPacketSize.
>>   *
>>   * Gadgets have a mostly-portable "gadget driver" implementing device
>>   * functions, handling all usb configurations and interfaces.  Gadget
>> @@ -541,6 +543,7 @@ struct usb_gadget {
>>  	unsigned			b_hnp_enable:1;
>>  	unsigned			a_hnp_support:1;
>>  	unsigned			a_alt_hnp_support:1;
>> +	unsigned			quirk_ep_out_aligned_size:1;
>>  };
>>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
>>  
>> @@ -559,6 +562,23 @@ static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
>>  
>>  
>>  /**
>> + * usb_ep_align_maybe - returns @len aligned to ep's maxpacketsize if gadget
>> + *	requires quirk_ep_out_aligned_size, otherwise reguens len.
> 
> “returns”

I've got no idea how returns became reguens :)
But maybe Felipe can fix it when applying?

Br, David

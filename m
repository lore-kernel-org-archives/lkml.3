Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3J3QWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:22:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:54574 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3J3QWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:22:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,602,1378882800"; 
   d="scan'208";a="419810602"
Message-ID: <5271333F.9040500@linux.intel.com>
Date: Wed, 30 Oct 2013 09:26:39 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2 1/3] usb: gadget: add quirks field to struct usb_gadget
References: <Pine.LNX.4.44L0.1310301033040.1312-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310301033040.1312-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>> index 942ef5e..7014ad9 100644
>> --- a/include/linux/usb/gadget.h
>> +++ b/include/linux/usb/gadget.h
>> @@ -540,6 +540,11 @@ struct usb_gadget {
>>   	struct device			dev;
>>   	unsigned			out_epnum;
>>   	unsigned			in_epnum;
>> +
>> +	u32				quirks;
>> +/* epout requires buffer size to be aligned to MaxPacketSize */
>> +#define USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE		(1 << 0)
>
> If you decide to go through with this, it might be better to define a
> series of single-bit flags instead of a single "quirks" field.  For
> example:
>
> 	unsigned			quirk_ep_out_aligned_size:1;
>
> Yes, other people (including me!) have done it your way in the past,
> but now this seems to make more sense.

It would be less error-prone. I'll change it.

Thanks,

David

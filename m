Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3JaUAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:00:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:52156 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab3JaUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:00:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,611,1378882800"; 
   d="scan'208";a="420504083"
Message-ID: <5272B67B.6050509@linux.intel.com>
Date: Thu, 31 Oct 2013 12:58:51 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        Paul.Zimmerman@synopsys.com
Subject: Re: [PATCH v3 3/3] usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE
 to gadget driver
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com> <1383152778-30739-4-git-send-email-david.a.cohen@linux.intel.com> <20131030173553.GP12193@gimli>
In-Reply-To: <20131030173553.GP12193@gimli>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 10:35 AM, Felipe Balbi wrote:
> On Wed, Oct 30, 2013 at 10:06:18AM -0700, David Cohen wrote:
>> DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
>> This patch adds necessary quirk for it.
>>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>  drivers/usb/dwc3/gadget.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 5452c0f..528c7d7 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -2600,6 +2600,12 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>>  	dwc->gadget.name		= "dwc3-gadget";
>>  
>>  	/*
>> +	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
>> +	 * on ep out.
>> +	 */
>> +	dwc->gadget.quirk_ep_out_aligned_size = 1;
> 
> just to make it look cooler and neater, could you set to 'true' instead
> :-)

'bool' is an alien in C :)
But I can change to true in next patch set.

Br, David Cohen


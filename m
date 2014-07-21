Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaGUFI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:08:29 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57654 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbaGUFI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:08:28 -0400
Message-ID: <53CCA019.7030007@st.com>
Date: Mon, 21 Jul 2014 10:37:37 +0530
From: Amit Virdi <amit.virdi@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
References: <Pine.LNX.4.44L0.1407181034220.979-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407181034220.979-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/2014 8:09 PM, Alan Stern wrote:
> On Fri, 18 Jul 2014, Amit Virdi wrote:
>
>> On 7/17/2014 8:25 PM, Alan Stern wrote:
>>> I can't say this is actually wrong, but have you ever encountered a
>>> situation where this would be needed?  How often does anyone need to do
>>> a multi-packet transfer over an interrupt endpoint?
>>
>> Honestly, I haven't found any such real device yet. I did this change
>> while I was going through the code when adding support for interrupt
>> transfers in gadget zero. I'm a no expert, but the spec says it should
>> be supported so this code should be added.
>
> I just remembered, the HID spec requires that all reports (except the
> longest) end with a short packet.  And since output reports are allowed
> to be sent over an Interrupt-OUT endpoint, we have to accept the
> URB_ZERO_PACKET flag for interrupt URBs.
>

Ok, great!

>> However, I messed up a little in this patch. It should have been
>> ---
>>           case USB_ENDPOINT_XFER_ISOC:
>>                   allowed |= URB_ISO_ASAP;
>>                   break;
>> +       case USB_ENDPOINT_XFER_INT:
>> +               if (is_out)
>> +                       allowed |= URB_ZERO_PACKET;
>> +               else
>> +                       allowed |= URB_SHORT_NOT_OK;
>> +               break;
>>           }
>>           allowed &= urb->transfer_flags;
>>
>> ---
>> Otherwise, it sets zero packet flag for control out transfers too.
>>
>> I'll send a V2 with this change if you agree to setting of the zero
>> packet flag for interrupt transfers.
>
> How about this change instead?
>
>   			URB_FREE_BUFFER);
>   	switch (xfertype) {
>   	case USB_ENDPOINT_XFER_BULK:
> +	case USB_ENDPOINT_XFER_INT:

Looks better.
I'll submit a V2 with this change.

Regards
Amit Virdi

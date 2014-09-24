Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaIXOW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:22:29 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54204 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:22:27 -0400
Message-ID: <5422D39D.70006@gmail.com>
Date: Wed, 24 Sep 2014 21:22:21 +0700
From: Lars Melin <larsm17@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: hs@denx.de
CC: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Macpaul Lin <macpaul@gmail.com>
Subject: Re: [PATCH] usb: gadget: f_rndis: fix usb_interface_descriptor for
 rndis
References: <1411541339-32400-1-git-send-email-hs@denx.de> <5422B83A.8030406@gmail.com> <5422C33F.400@denx.de>
In-Reply-To: <5422C33F.400@denx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-24 20:12, Heiko Schocher wrote:
> Hello Lars,
>
> Am 24.09.2014 14:25, schrieb Lars Melin:
>> On 2014-09-24 13:48, Heiko Schocher wrote:
>>> use the values for RNDIS over Ethernet as defined in
>>> http://www.usb.org/developers/defined_class
>>> (search for RDNIS):
>>>
>>> - baseclass: 0xef (miscellaneous)
>>> - subclass: 0x04
>>> - protocol: 0x01
>>>
>> That is usb class, it is not the same thing as communication device 
>> class.
>>> --- a/include/uapi/linux/usb/cdc.h
>>> +++ b/include/uapi/linux/usb/cdc.h
>>> @@ -12,6 +12,7 @@
>>> #include <linux/types.h>
>>> #define USB_CDC_SUBCLASS_ACM 0x02
>>> +#define USB_CDC_SUBCLASS_RNDIS 0x04
>> No, no, no.
>> There is no CDC_SUBCLASS_RNDIS and you can not define one over an 
>> already used cdc subclass number, 0x04 is Multi-Channel Control Model
>
> Ah, ok, so I have to define this values in a new header file, as there
> is no current file for the USB_CLASS_MISC defines? Or is there a proper
> place for them?
>
> BTW: where do I find the "cdc subclass number, 0x04 is Multi-Channel
> Control Model" define?
>
> bye,
> Heiko

You can still find the original specification usbcdc11.pdf on the net if 
you google for it, it has been pulled from usb.org where you could 
download it until a few years ago.
It is old but covers a lot of what you need to know.

Linux has afaik only the cdc.h definition file, everything else is coded 
by class/subclass in respectively drivers when needed.
02/02/ff  or  e0/01/03  are the most common interface attribute for 
rndis,  both of them together with a data interface with attributes 
0a/00/00.
Please check the whitelisting in drivers/net/usb/rndis_host.c  and also 
blacklistings in other net drivers under the same path, it should give 
you an idea how to bind an interface to a specific driver by interface 
attributes and/or usb vid:pid.
You should be able to do the same for your particular device.


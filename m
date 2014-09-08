Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaIHPxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:53:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37891 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbaIHPxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:53:02 -0400
Message-ID: <540DD0CF.4000501@ti.com>
Date: Mon, 8 Sep 2014 11:52:47 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: update to support multiple pci ports
References: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com> <3654923.JrIGV2dJ70@wuerfel> <540A1F05.80706@ti.com> <5769746.NkKjYOOUiv@wuerfel>
In-Reply-To: <5769746.NkKjYOOUiv@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 05:11 PM, Arnd Bergmann wrote:
> On Friday 05 September 2014 16:37:25 Murali Karicheri wrote:
>> On 09/05/2014 03:00 PM, Arnd Bergmann wrote:
>>> On Friday 05 September 2014 14:33:54 Murali Karicheri wrote:
>>>>> This looks like it's a shared register of some sort that doesn't
>>>>> really belong into the registers of a particular port. Could it
>>>>> be that it's actually for the PHY?
>>>>>
>>>> This a shared device configuration register between the two ports the
>>>> desciption states it is bootstrap configuration of the PCIe module as
>>>> Endpoint or Root complex and Not Phy. Hope below text will help.
>>>
>>> Ok. Why do you want to have this user-selectable though? Can't it
>>> just be set by the boot loader before starting Linux?
>>
>> Arnd,
>>
>> As the driver is responsible for configuring the device to support the
>> device functionality, it make sense to do this in the device driver. The
>> driver enables clock to the IP and this is an addition thing to be
>> configured so that when the device is powered up, it should function as
>> RC. The IP can be configured to work as Root Complex or Endpoint. So not
>> sure why you want to me to move this functionality to boot loader.
>
> But the driver can only do root complex mode, and we would probably
> want a completely different driver if we were to start supporting
> endpoint mode.
>
Arnd,

Good point! I will drop index#2 handling in the driver code and will 
handle the same in boot loader. But I have a question though. The 
original driver which is queued up for merge to v3.18 has index #2 for 
this reg offset and is documented in the DT documentation as

	index 2 is the base address and length of PCI mode configuration
	register.
	index 3 is the base address and length of PCI device ID register.


Will this create any issue in terms of backward compatibility if I 
remove it and move index3 to index2 and update the code for the same? I 
assume since this patch also will likely be on the next branch soon, and 
gets merged together with original driver to v3.18, this should be fine. 
But for some reason, if this patch doesn't make to v3.18, then won't 
this break the backward compatibility?

I think the other option is document index2 as obsolete and update the 
document and remove the code for handling it. Any suggestion?

Thanks

Murali

> This also implies that the firmware has to pass a different DT for
> endpoint mode, so it should be responsible for setting up the hardware
> to match the DT.
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


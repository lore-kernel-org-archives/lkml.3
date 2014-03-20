Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbaCTRis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:38:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42770 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbaCTRiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:38:46 -0400
Message-ID: <532B2766.6090506@ti.com>
Date: Thu, 20 Mar 2014 13:37:42 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <dwmw2@infradead.org>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH 2/3] mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE
 option
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com> <1395335184-4745-3-git-send-email-ivan.khoronzhuk@ti.com> <532B2183.2080309@ti.com> <20140320172912.GW31517@norris-Latitude-E6410>
In-Reply-To: <20140320172912.GW31517@norris-Latitude-E6410>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 20 March 2014 01:29 PM, Brian Norris wrote:
> On Thu, Mar 20, 2014 at 01:12:35PM -0400, Santosh Shilimkar wrote:
>> Boris,
>
> Who's Boris? And why should Boris be taking this patch? It's an MTD
> patch.
> 
I got your name completely wrong. Sorry....

>> On Thursday 20 March 2014 01:06 PM, Ivan Khoronzhuk wrote:
>>> From: Murali Karicheri <m-karicheri2@ti.com>
>>>
>>> After testing NAND flash with ubifs for k2hk-emv board were committed
>>> that flash doesn't support subpage writing, so we can fix it by
>>> adding a property to disable subpage write.
> 
> What flash? We try to autodetect NAND as much as possible. Perhaps we
> should be adding infrastructure support instead of hacking it with a DT
> property.
>
We can't auto detect it and thats why the DT approach was taken. We
will double check that.

>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> ---
>> Can you please pick this up for 3.15 fixes ? Ofcourse assuming DT folks
>> are ok with the patch.
>>
>> I can then take patch 1/3 and 3/3 in my 3.15 fixes queue.
>>
>>>  Documentation/devicetree/bindings/mtd/davinci-nand.txt | 2 ++
>>>  drivers/mtd/nand/davinci_nand.c                        | 3 +++
>>>  2 files changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> index cfb18ab..50af930 100644
>>> --- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> +++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> @@ -53,6 +53,8 @@ Recommended properties :
>>>  				identifier is saved in OOB area. If not present
>>>  				false.
>>>  
>>> +- ti,davinci-nosubpage-write:	disable subpage write for the device
> 
> If we really need the DT property, I'd prefer a generic
> "nand-numer-of-partial-programs" or something like that, and if it's
> equal to 1, then the flash doesn't support partial page programming.
>
OK. It can be updated as you suggested.
 
Thanks for quick response and sorry for the rename

Regards,
Santosh



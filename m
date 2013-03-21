Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3CURC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:02:27 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:42288 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3CURCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:02:25 -0400
Message-ID: <514B3D05.3070501@synopsys.com>
Date: Thu, 21 Mar 2013 21:01:57 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Simek <monstr@monstr.eu>, Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        <dahinds@users.sourceforge.net>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com> <CAHTX3dKPWg35Az8eE45AGriPZh2G6LLaQMynhFPKSZ+7UvM=9g@mail.gmail.com> <201302121725.07641.arnd@arndb.de>
In-Reply-To: <201302121725.07641.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 09:25 PM, Arnd Bergmann wrote:
> On Tuesday 12 February 2013, Michal Simek wrote:
>> But on Microblaze LE is necessary to use different datain/out_le16
>> functions as below
>> which are also not compatible with Microblaze and PPC BE.
>>
>> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
>> index bbad046..8dd192c 100644
>> --- a/drivers/block/xsysace.c
>> +++ b/drivers/block/xsysace.c
>> @@ -314,7 +314,7 @@ static void ace_datain_le16(struct ace_device *ace)
>>          int i = ACE_FIFO_SIZE / 2;
>>          u16 *dst = ace->data_ptr;
>>          while (i--)
>> -               *dst++ = ioread16be(ace->baseaddr + 0x40);
>> +               *dst++ = ioread16(ace->baseaddr + 0x40);
>>          ace->data_ptr = dst;
>>   }
>
> Hmm, that actually seems sane then: You can replace the loop around
> ioread16be with a single ioread32_rep() call, which will use
> the correct native endian accesses on both LE Microblaze
> and on all the big-endian platforms. Note that the asm-generic
> definition of that function was broken until quite recently
> when Will Deacon repaired it in order to support ARM64.
>
> 	Arnd
>

It seems like this thread was not updated for many weeks now.
I'm wondering if I missed something or if I may do something to help you 
guys move forward with proposed patch?

-Alexey

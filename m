Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3DYIzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:55:05 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19196
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab3DYIzB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:55:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z3121kzc89bh1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1155h)
Message-ID: <5178EFC9.9080207@freescale.com>
Date: Thu, 25 Apr 2013 16:56:41 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 6/9] mtd: add a new field for ecc info in the nand_flash_dev{}
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>	<1366707297-31309-7-git-send-email-b32955@freescale.com> <CAN8TOE_5CeJfGpgJtKBXmb5ai3w9dZ8juk5GdQhRTZQ7MPKbZw@mail.gmail.com>
In-Reply-To: <CAN8TOE_5CeJfGpgJtKBXmb5ai3w9dZ8juk5GdQhRTZQ7MPKbZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月25日 14:57, Brian Norris 写道:
>
> A bit late on this one, but is there a good reason this wasn't just 2
> separate 16-bit fields? We already have a few, and I don't see why
> this couldn't be the same.
>
I just want to make the ecc_strength/ecc_size more coupled for the 
nand_flash_dev{}.
If we spilit to two fields. It makes the nand_flash_ids[] less readable.
>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>> ---
>>   include/linux/mtd/nand.h |   10 ++++++++++
>>   1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
>> index 063e517..f4c7777 100644
>> --- a/include/linux/mtd/nand.h
>> +++ b/include/linux/mtd/nand.h
>> @@ -624,6 +624,10 @@ struct nand_chip {
>>          { .name = (nm), {{ .dev_id = (devid) }}, .chipsize = (chipsz), \
>>            .options = (opts) }
>>
>> +#define NAND_ECC_INFO(strength, size)  (((strength)<<  16) | (size))
> We could redefine this:
>
> #define NAND_ECC_INFO(strength, size) .ecc_strength = (strength),
> .ecc_size = (size)
Do this type of macro could be accepted by the kernel?

I think your macro needs a pair of bracket, such as:
#define NAND_ECC_INFO(strength, size) (.ecc_strength = (strength), 
.ecc_size = (size))

But if we add the brackets, we will meet a compiler error.




thanks
Huang Shijie



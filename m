Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaC3Acj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 20:32:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45422 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaC3Aci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 20:32:38 -0400
Message-ID: <533765F8.2090700@oracle.com>
Date: Sat, 29 Mar 2014 20:31:52 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Subject: Re: [PATCH] mtd: diskonchip: mem resource name is not optional
References: <1395267877-15223-1-git-send-email-sasha.levin@oracle.com> <1395477572.57478225@f224.i.mail.ru>
In-Reply-To: <1395477572.57478225@f224.i.mail.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2014 04:39 AM, Alexander Shiyan wrote:
> Wed, 19 Mar 2014 18:24:37 -0400 от Sasha Levin <sasha.levin@oracle.com>:
>> Passing a name to request_mem_region() isn't optional and can't just
>> be NULL. Passing NULL causes a NULL ptr deref later in the boot
>> process.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>   drivers/mtd/nand/diskonchip.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
>> index b9b4db6..f68a7bc 100644
>> --- a/drivers/mtd/nand/diskonchip.c
>> +++ b/drivers/mtd/nand/diskonchip.c
>> @@ -1439,7 +1439,7 @@ static int __init doc_probe(unsigned long physadr)
>>   	int reg, len, numchips;
>>   	int ret = 0;
>>
>> -	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, NULL))
>> +	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, "DiskOnChip"))
>>   		return -EBUSY;
>>   	virtadr = ioremap(physadr, DOC_IOREMAP_LEN);
>>   	if (!virtadr) {
>> --
>
> Tested-by: Alexander Shiyan <shc_work@mail.ru>

It seems that no one pulled this patch anywhere. It fixes a straightforward
boot failure on boot when diskonchip is enabled in the config.

Someone grab it please?


Thanks,
Sasha


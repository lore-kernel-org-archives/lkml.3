Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3CNNZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:25:38 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44307 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab3CNNZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:25:25 -0400
Message-ID: <5142878A.7050701@gmail.com>
Date: Thu, 14 Mar 2013 22:29:30 -0400
From: Huang Shijie <shijie8@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110817 Fedora/3.1.12-1.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mtd: add 4 Toshiba nand chips for the full-id
 case
References: <1363229965-13128-1-git-send-email-b32955@freescale.com>	<1363229965-13128-4-git-send-email-b32955@freescale.com> <CAN8TOE9aGckZ2PrCCPQe4ZgW6Aph3otXGohNuRPssu8f302xaA@mail.gmail.com>
In-Reply-To: <CAN8TOE9aGckZ2PrCCPQe4ZgW6Aph3otXGohNuRPssu8f302xaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月14日 01:10, Brian Norris 写道:
> On Wed, Mar 13, 2013 at 7:59 PM, Huang Shijie<b32955@freescale.com>  wrote:
>> I have 4 Toshiba nand chips which can not be parsed out by the
>> id data. We can not get the oob size from the id data. So add them
>> as the full-id nand chips in the first of nand_flash_ids.
>>
>> The nand_get_flash_type() scans the full id nands firstly.
>> If a full-id nand matchs, it will not continue to parse other
>> non-full-id nand types, else it will continue to parse the non-full-id nands.
>>
>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>> ---
>>   drivers/mtd/nand/nand_ids.c |   22 ++++++++++++++++++++++
>>   1 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
>> index 625bc89..38b8cee 100644
>> --- a/drivers/mtd/nand/nand_ids.c
>> +++ b/drivers/mtd/nand/nand_ids.c
>> @@ -10,6 +10,7 @@
>>    */
>>   #include<linux/module.h>
>>   #include<linux/mtd/nand.h>
>> +#include<linux/sizes.h>
>>
>>   #define LP_OPTIONS NAND_SAMSUNG_LP_OPTIONS
>>   #define LP_OPTIONS16 (LP_OPTIONS | NAND_BUSWIDTH_16)
>> @@ -22,6 +23,27 @@
>>    * extended chip ID.
>>    */
>>   struct nand_flash_dev nand_flash_ids[] = {
>> +       /*
>> +        * The full-id nands may share the same Device ID with the non-full-id
>> +        * nands. In order to distinguish the two type nands, we put the
>> +        * full-id nands in the first of the table. So the nand_get_flash_type()
>> +        * scans the full id nands firstly. If a full-id nand matchs, it will
>> +        * not continue to parse other non-full-id nand types, else it will
>> +        * continue to parse the non-full-id nands.
>> +        */
> There are a few grammar/language issues (nands ->  NAND chips, id ->
> ID, firstly ->  first). Also, I don't think you need to explain the
> full search here. I would rewrite this whole paragraph as:
>
sorry for my poor english.

> "Some incompatible NAND chips share device ID's and so must be listed
> by full ID. We list them first so that we can easily identify the most
> specific match."
>
thanks. I will use this description.



Huang Shijie

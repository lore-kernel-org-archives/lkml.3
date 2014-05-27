Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaE0GC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:02:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54267 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaE0GC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:02:28 -0400
Message-ID: <53842A53.1060404@ahsoftware.de>
Date: Tue, 27 May 2014 08:01:55 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/27] mtd: nand: pxa3xx: show device structure in sysfs
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de> <1401142372-14148-10-git-send-email-holler@ahsoftware.de> <1401160341.192042842@f271.i.mail.ru>
In-Reply-To: <1401160341.192042842@f271.i.mail.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.05.2014 05:12, schrieb Alexander Shiyan:
> Tue, 27 May 2014 00:12:34 +0200 от Alexander Holler <holler@ahsoftware.de>:
>> Fix a common error in nand-drivers which do not set up a parent devicefor
>> the mtd-device by using a new inline function.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>>   drivers/mtd/nand/pxa3xx_nand.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
>> index 7588fe2..7f62e7c 100644
>> --- a/drivers/mtd/nand/pxa3xx_nand.c
>> +++ b/drivers/mtd/nand/pxa3xx_nand.c
>> @@ -1584,8 +1584,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
>>   		host->mtd = mtd;
>>   		host->cs = cs;
>>   		host->info_data = info;
>> -		mtd->priv = host;
>> -		mtd->owner = THIS_MODULE;
>> +		mtd_setup_common_members(mtd, host, pdev);
>>
>>   		chip->ecc.read_page	= pxa3xx_nand_read_page_hwecc;
>>   		chip->ecc.write_page	= pxa3xx_nand_write_page_hwecc;
>> --
>
> Should we add "driver.owner = THIS_MODULE" field for struct platform_driver in this case?

Yes. I assumed all drivers/modules already had an owner. I will check 
them all and will send a v2 for those which don't have one. I wonder 
what this field is used for if it works without. ;)

Regards,

Alexander Holler


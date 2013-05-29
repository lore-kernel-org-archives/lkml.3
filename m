Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab3E2Cmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:42:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:5155 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab3E2Cms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:42:48 -0400
Message-ID: <51A56AA6.9030706@huawei.com>
Date: Wed, 29 May 2013 10:40:38 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: <dwmw2@infradead.org>, <zajec5@gmail.com>,
        <artem.bityutskiy@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>, <hauke@hauke-m.de>,
        <linux-mtd@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH RESEND] mtd: fix kfree bcm47xxsflash
References: <1367743225-3484-1-git-send-email-libo.chen@huawei.com> <519C40A8.1070506@huawei.com> <CAHp75VfXZMZvw_XmPKEWcBikbx7pk1oHoxa0ztoQ1ywhi5Ovew@mail.gmail.com>
In-Reply-To: <CAHp75VfXZMZvw_XmPKEWcBikbx7pk1oHoxa0ztoQ1ywhi5Ovew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/28 23:29, Andy Shevchenko wrote:
> This is good fix, but I rather prefer not to see it in this shape.
> See comments below.
> 
> On Wed, May 22, 2013 at 6:51 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>>
>> mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash  not its member.
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> Acked-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/mtd/devices/bcm47xxsflash.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> * add Acked-by: Rafał Miłecki <zajec5@gmail.com>
>> * change send list
>>
>> diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
>> index 9526628..4aa9141 100644
>> --- a/drivers/mtd/devices/bcm47xxsflash.c
>> +++ b/drivers/mtd/devices/bcm47xxsflash.c
>> @@ -76,7 +76,7 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
>>         return 0;
>>
>>  err_dev_reg:
>> -       kfree(&b47s->mtd);
>> +       kfree(b47s);
>>  out:
>>         return err;
>>  }
> 
> What about to switch to devm_* and remove those labels and kfrees at all?
> 
> Additionally you can add another patch to use module_platform_driver()
> macro instead of module_init/exit.
> 

ok, I will update later.

thanks,

Libo


> --
> With Best Regards,
> Andy Shevchenko
> 
> .
> 



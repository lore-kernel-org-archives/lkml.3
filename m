Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab3E3KbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:31:08 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62663 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968083Ab3E3Ka7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <51A6B7D8.8090600@huawei.com>
References: <51A6B7D8.8090600@huawei.com>
Date: Thu, 30 May 2013 13:30:57 +0300
Message-ID: <CAHp75Vc9mYmUM4pmeKLBzxNFsx-xiSez6oxC1F5+Hh-hPXto5A@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] mtd: bcm47: convert to module_platform_driver
 instead of init/exit
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        artem.bityutskiy@linux.intel.com, Bill Pemberton <wfp5p@virginia.edu>,
        hauke@hauke-m.de, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 5:22 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>
> convert to module_platform_driver instead of init/exit

I give another thought about it. We have to be sure that the flash
device will be online when it's really needed.
module_init initcall is quite far in the boot process. Is it what we want?

> --- a/drivers/mtd/devices/bcm47xxsflash.c
> +++ b/drivers/mtd/devices/bcm47xxsflash.c
> @@ -108,22 +108,4 @@ static struct platform_driver bcma_sflash_driver = {
>   * Init
>   **************************************************/
>
> -static int __init bcm47xxsflash_init(void)
> -{
> -       int err;
> -
> -       err = platform_driver_register(&bcma_sflash_driver);
> -       if (err)
> -               pr_err("Failed to register BCMA serial flash driver: %d\n",
> -                      err);
> -
> -       return err;
> -}
> -
> -static void __exit bcm47xxsflash_exit(void)
> -{
> -       platform_driver_unregister(&bcma_sflash_driver);
> -}
> -
> -module_init(bcm47xxsflash_init);
> -module_exit(bcm47xxsflash_exit);
> +module_platform_driver(bcma_sflash_driver);
> --
> 1.7.1
>
>



--
With Best Regards,
Andy Shevchenko

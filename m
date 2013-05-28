Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3E1PaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:30:01 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39277 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab3E1PaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <519C40A8.1070506@huawei.com>
References: <1367743225-3484-1-git-send-email-libo.chen@huawei.com>
	<519C40A8.1070506@huawei.com>
Date: Tue, 28 May 2013 18:29:58 +0300
Message-ID: <CAHp75VfXZMZvw_XmPKEWcBikbx7pk1oHoxa0ztoQ1ywhi5Ovew@mail.gmail.com>
Subject: Re: [PATCH RESEND] mtd: fix kfree bcm47xxsflash
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dwmw2@infradead.org, zajec5@gmail.com, artem.bityutskiy@linux.intel.com,
        Bill Pemberton <wfp5p@virginia.edu>, hauke@hauke-m.de,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is good fix, but I rather prefer not to see it in this shape.
See comments below.

On Wed, May 22, 2013 at 6:51 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>
> mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash  not its member.
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> Acked-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/mtd/devices/bcm47xxsflash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> * add Acked-by: Rafał Miłecki <zajec5@gmail.com>
> * change send list
>
> diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
> index 9526628..4aa9141 100644
> --- a/drivers/mtd/devices/bcm47xxsflash.c
> +++ b/drivers/mtd/devices/bcm47xxsflash.c
> @@ -76,7 +76,7 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
>         return 0;
>
>  err_dev_reg:
> -       kfree(&b47s->mtd);
> +       kfree(b47s);
>  out:
>         return err;
>  }

What about to switch to devm_* and remove those labels and kfrees at all?

Additionally you can add another patch to use module_platform_driver()
macro instead of module_init/exit.

--
With Best Regards,
Andy Shevchenko

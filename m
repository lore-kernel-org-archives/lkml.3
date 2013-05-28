Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab3E1MoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:44:23 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26733 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052Ab3E1MoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:44:22 -0400
Message-ID: <51A4A5C9.1010909@huawei.com>
Date: Tue, 28 May 2013 20:40:41 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <dwmw2@infradead.org>
CC: <zajec5@gmail.com>, <artem.bityutskiy@linux.intel.com>,
        <wfp5p@virginia.edu>, <hauke@hauke-m.de>,
        <linux-mtd@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] mtd: fix kfree bcm47xxsflash
References: <1367743225-3484-1-git-send-email-libo.chen@huawei.com> <519C40A8.1070506@huawei.com>
In-Reply-To: <519C40A8.1070506@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...

On 2013/5/22 11:51, Libo Chen wrote:
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
>  	return 0;
> 
>  err_dev_reg:
> -	kfree(&b47s->mtd);
> +	kfree(b47s);
>  out:
>  	return err;
>  }
> 



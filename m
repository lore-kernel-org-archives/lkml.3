Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaEJLjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 07:39:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33303 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaEJLjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 07:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <1399716396.580639659@f244.i.mail.ru>
References: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
	<1399715823-19839-2-git-send-email-gautam.vivek@samsung.com>
	<1399716396.580639659@f244.i.mail.ru>
Date: Sat, 10 May 2014 17:09:44 +0530
X-Google-Sender-Auth: 1aDsiLlfgUQYqfJfP_MWDOHonEU
Message-ID: <CAFp+6iGZ6i6a95O4UhWRQc6QdknK4AgVOh+fSKdRZcAhmgn-Rw@mail.gmail.com>
Subject: Re: [PATCH 1/6] usb: host: ehci-exynos: Use devm_ioremap_resource
 instead of devm_ioremap
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "thierry.reding" <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sat, May 10, 2014 at 3:36 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
> Sat, 10 May 2014 15:26:58 +0530 от Vivek Gautam <gautam.vivek@samsung.com>:
>> Using devm_ioremap_resource() API should actually be preferred over
>> devm_ioremap(), since the former request the mem region first and then
>> gives back the ioremap'ed memory pointer.
>> devm_ioremap_resource() calls request_mem_region(), therby preventing
>> other drivers to make any overlapping call to the same region.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/usb/host/ehci-exynos.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
>> index 7f425ac..bccb6f1 100644
>> --- a/drivers/usb/host/ehci-exynos.c
>> +++ b/drivers/usb/host/ehci-exynos.c
>> @@ -135,9 +135,8 @@ skip_phy:
>>
>>       hcd->rsrc_start = res->start;
>>       hcd->rsrc_len = resource_size(res);
>> -     hcd->regs = devm_ioremap(&pdev->dev, res->start, hcd->rsrc_len);
>> +     hcd->regs = devm_ioremap_resource(&pdev->dev, res);
>>       if (!hcd->regs) {
>> -             dev_err(&pdev->dev, "Failed to remap I/O memory\n");
>>               err = -ENOMEM;
>>               goto fail_io;
>>       }
>
> You should check this as:
>
> if (IS_ERR(hcd->regs)) {
> err = PTR_ERR(hcd->regs);
> ...

Thanks for pointing out. Will change this.

>
> Same in other patches in this series.
>
> ---
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India

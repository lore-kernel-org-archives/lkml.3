Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaEJKHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:07:35 -0400
Received: from fallback8.mail.ru ([94.100.176.136]:41670 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaEJKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:07:33 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Vml2ZWsgR2F1dGFt?= <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, swarren@wwwdotorg.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu,
        linux-tegra@vger.kernel.org, thierry.reding@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzZdIHVzYjogaG9zdDogZWhjaS1leHlub3M6IFVzZSBk?=
 =?UTF-8?B?ZXZtX2lvcmVtYXBfcmVzb3VyY2UgaW5zdGVhZCBvZiBkZXZtX2lvcmVtYXA=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Sat, 10 May 2014 14:06:36 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1399716396.580639659@f244.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1399715823-19839-2-git-send-email-gautam.vivek@samsung.com>
References: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
 <1399715823-19839-2-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4AA7jmX008344

Sat, 10 May 2014 15:26:58 +0530 Ğ¾Ñ‚ Vivek Gautam <gautam.vivek@samsung.com>:
> Using devm_ioremap_resource() API should actually be preferred over
> devm_ioremap(), since the former request the mem region first and then
> gives back the ioremap'ed memory pointer.
> devm_ioremap_resource() calls request_mem_region(), therby preventing
> other drivers to make any overlapping call to the same region.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/host/ehci-exynos.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index 7f425ac..bccb6f1 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -135,9 +135,8 @@ skip_phy:
>  
>  	hcd->rsrc_start = res->start;
>  	hcd->rsrc_len = resource_size(res);
> -	hcd->regs = devm_ioremap(&pdev->dev, res->start, hcd->rsrc_len);
> +	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
>  	if (!hcd->regs) {
> -		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
>  		err = -ENOMEM;
>  		goto fail_io;
>  	}

You should check this as:

if (IS_ERR(hcd->regs)) {
err = PTR_ERR(hcd->regs);
...

Same in other patches in this series.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3LSRhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:37:47 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:36059 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3LSRhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:37:45 -0500
MIME-Version: 1.0
In-Reply-To: <1387465429-3568-31-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com> <1387465429-3568-31-git-send-email-levex@linux.com>
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 19 Dec 2013 09:37:04 -0800
X-Google-Sender-Auth: 1cXTJ_L1sfXHqhHrPm5pPyK4zP4
Message-ID: <CAGVrzcZKKbm9B0A0eQbPRevT7+4CD=H_UbDCd8NaamrOjxAbcg@mail.gmail.com>
Subject: Re: [PATCH 30/38] vlynq: add missing put_device call
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/19 Levente Kurusa <levex@linux.com>:
> This is required so that we give up the last reference to the device.
> This will result in vlynq_device_release being called making the kfree()
> in the errorpath unneccessary.
>
> Signed-off-by: Levente Kurusa <levex@linux.com>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>  drivers/vlynq/vlynq.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
> index 7b07135..71d5905 100644
> --- a/drivers/vlynq/vlynq.c
> +++ b/drivers/vlynq/vlynq.c
> @@ -748,11 +748,14 @@ static int vlynq_probe(struct platform_device *pdev)
>         return 0;
>
>  fail_register:
> +       put_device(&dev->dev);
> +       dev->dev = 0;
>         iounmap(dev->local);
>  fail_remap:
>  fail_request:
>         release_mem_region(regs_res->start, len);
> -       kfree(dev);
> +       if(dev)
> +               kfree(dev);

This probably now generates a checkpatch warning since it is safe to
call kfree() on a NULL pointer.

>         return result;
>  }
>
> --
> 1.8.3.1



-- 
Florian

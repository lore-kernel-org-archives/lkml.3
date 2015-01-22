Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbbAVJhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:37:36 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50922 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbAVJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <1421852809-29733-1-git-send-email-a.ryabinin@samsung.com>
References: <1421852809-29733-1-git-send-email-a.ryabinin@samsung.com>
Date: Thu, 22 Jan 2015 10:37:25 +0100
X-Google-Sender-Auth: s2RWs3yVErXvSPw9qujEk5kM5xY
Message-ID: <CAJKOXPfuxD91=hEYoTQ2Vdes+cf-FXGUZRD2HUbeNzS3czKobA@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] rtc: s5m: terminate s5m_rtc_id array with
 empty element
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-21 16:06 GMT+01:00 Andrey Ryabinin <a.ryabinin@samsung.com>:
> Array of platform_device_id elements should be terminated
> with empty element.
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  drivers/rtc/rtc-s5m.c | 1 +
>  1 file changed, 1 insertion(+)


Right, good catch.

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Maybe also cc stable for fixing 5bccae6ec458 ("rtc: s5m-rtc: add
real-time clock driver for s5m8767")?

Best regards,
Krzysztof

>
> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
> index b5e7c46..89ac1d5 100644
> --- a/drivers/rtc/rtc-s5m.c
> +++ b/drivers/rtc/rtc-s5m.c
> @@ -832,6 +832,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
>  static const struct platform_device_id s5m_rtc_id[] = {
>         { "s5m-rtc",            S5M8767X },
>         { "s2mps14-rtc",        S2MPS14X },
> +       { },
>  };
>
>  static struct platform_driver s5m_rtc_driver = {
> --
> 2.2.1
>
> --
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.
> ---
> You received this message because you are subscribed to the Google Groups "rtc-linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.

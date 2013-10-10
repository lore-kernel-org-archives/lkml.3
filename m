Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3JJDlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:41:39 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36958 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JJDli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <001e01ceb840$f0628810$d1279830$%han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
	<001e01ceb840$f0628810$d1279830$%han@samsung.com>
Date: Thu, 10 Oct 2013 11:41:37 +0800
Message-ID: <CAD6h2NRxPR1WRKXQaFzDO-+OyF+jY1FA4ZrDC+aQP9d4QMZEBg@mail.gmail.com>
Subject: Re: [PATCH 02/15] rtc: rtc-88pm860x: use dev_get_platdata()
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 September 2013 17:40, Jingoo Han <jg1.han@samsung.com> wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly. This is a cosmetic change
> to make the code simpler and enhance the readability.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-88pm860x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
> index 4e30c85..81650484 100644
> --- a/drivers/rtc/rtc-88pm860x.c
> +++ b/drivers/rtc/rtc-88pm860x.c
> @@ -316,7 +316,7 @@ static int pm860x_rtc_probe(struct platform_device *pdev)
>         unsigned long ticks = 0;
>         int ret;
>
> -       pdata = pdev->dev.platform_data;
> +       pdata = dev_get_platdata(&pdev->dev);
>
>         info = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_rtc_info),
>                             GFP_KERNEL);
> --
> 1.7.10.4
>
>

Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>

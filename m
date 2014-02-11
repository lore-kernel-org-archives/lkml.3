Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBKQpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:45:45 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53928 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaBKQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:45:43 -0500
MIME-Version: 1.0
In-Reply-To: <1390928069-7313-1-git-send-email-badarkhe.manish@gmail.com>
References: <1390928069-7313-1-git-send-email-badarkhe.manish@gmail.com>
Date: Tue, 11 Feb 2014 22:15:41 +0530
Message-ID: <CAKDJKT5PuL6RTwUC3pkZCPDVosfcX51TRmrX3tC952L2N+X43Q@mail.gmail.com>
Subject: Re: [PATCH V4] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?4KSu4KSo4KS/4KS3IOCkrOCkpuCksOCkluClhw==?= 
	<badarkhe.manish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Jan 28, 2014 at 10:24 PM, Manish Badarkhe
<badarkhe.manish@gmail.com> wrote:
> Instead of "#ifdef CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
> option for DT code to avoid if-deffery in code.
>
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> Changes since V1:
> 1.Updated code to use "IS_ENABLED" during retrieval
>   of platform/DT data.
>
> Changes since V2:
> 1.Updated code as per Dmitry's comment to give preferance to
>   platform data.
>
> Changes since V3:
> 1.Updated code to use "IS_ENABLED(CONFIG_OF)" to remove
>   DT data retrieval function during compilation itself
>   when CONFIG_OF option is not set.
>
> :100644 100644 b4513f2... a7482db... M  drivers/power/max8925_power.c
>  drivers/power/max8925_power.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index b4513f2..a7482db 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
>         return 0;
>  }
>
> -#ifdef CONFIG_OF
>  static struct max8925_power_pdata *
>  max8925_power_dt_init(struct platform_device *pdev)
>  {
> @@ -440,9 +439,6 @@ max8925_power_dt_init(struct platform_device *pdev)
>         int no_insert_detect;
>         struct max8925_power_pdata *pdata;
>
> -       if (!nproot)
> -               return pdev->dev.platform_data;
> -
>         np = of_find_node_by_name(nproot, "charger");
>         if (!np) {
>                 dev_err(&pdev->dev, "failed to find charger node\n");
> @@ -468,13 +464,6 @@ max8925_power_dt_init(struct platform_device *pdev)
>
>         return pdata;
>  }
> -#else
> -static struct max8925_power_pdata *
> -max8925_power_dt_init(struct platform_device *pdev)
> -{
> -       return pdev->dev.platform_data;
> -}
> -#endif
>
>  static int max8925_power_probe(struct platform_device *pdev)
>  {
> @@ -483,7 +472,11 @@ static int max8925_power_probe(struct platform_device *pdev)
>         struct max8925_power_info *info;
>         int ret;
>
> -       pdata = max8925_power_dt_init(pdev);
> +       pdata = dev_get_platdata(&pdev->dev);
> +
> +       if (IS_ENABLED(CONFIG_OF) && !pdata && chip->dev->of_node)
> +               pdata = max8925_power_dt_init(pdev);
> +
>         if (!pdata) {
>                 dev_err(&pdev->dev, "platform data isn't assigned to "
>                         "power supply\n");

Gentle ping!!
Please let me know, are there any review comments on this patch?

Thanks
Manish Badarkhe

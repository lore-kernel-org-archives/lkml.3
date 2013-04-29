Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3D2MNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:13:37 -0400
Received: from smtp-out-009.synserver.de ([212.40.185.9]:1055 "EHLO
	smtp-out-009.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab3D2MNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:13:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12939
Message-ID: <517E63C8.6040809@metafoo.de>
Date: Mon, 29 Apr 2013 14:12:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
References: <000001ce42f2$96128cc0$c237a640$@samsung.com> <20119404.Sfu5WntByi@vostro.rjw.lan> <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com>
In-Reply-To: <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 07:41 AM, Jingoo Han wrote:
> On Saturday, April 27, 2013 11:41 PM, Rafael J. Wysocki:
>>
>> On Saturday, April 27, 2013 11:54:50 AM Jingoo Han wrote:
>>> Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
>>> to be assigned without having an #define xxx NULL for the case that PM is
>>> not enabled.
>>>
>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>>
>> First, I'm not taking any more PM patches for v3.10 (that don't fix recent
>> regressions).
>>
>> Second, please add that macro along with a user.
> 
> Hi Rafael,
> 
> This macro can be used as below:
> This macro cannot affect the procedure of suspend/resume
> calls; thus, there is no side effect.
> It just reduces the code size of each drivers.
> In this way, of_match_ptr() macro has been already used.
> 
> 
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  }
>  #endif
> 
> -#ifdef CONFIG_PM
>  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #ifdef CONFIG_PM_SLEEP
>         .suspend_noirq = s3c24xx_i2c_suspend_noirq,
> @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #endif
>  };
> 
> -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> -#else
> -#define S3C24XX_DEV_PM_OPS NULL
> -#endif
> -
>  /* device driver for platform bus bits */
> 
>  static struct platform_driver s3c24xx_i2c_driver = {
> @@ -1240,7 +1234,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
>         .driver         = {
>                 .owner  = THIS_MODULE,
>                 .name   = "s3c-i2c",
> -               .pm     = S3C24XX_DEV_PM_OPS,
> +               .pm     = pm_ops_ptr(&s3c24xx_i2c_dev_pm_ops),
>                 .of_match_table = of_match_ptr(s3c24xx_i2c_match),
>         },
>  };

Won't that generate a warning about an unused s3c24xx_i2c_dev_pm_ops when
CONFIG_PM is not enabled?


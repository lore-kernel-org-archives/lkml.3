Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbbATLaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:30:07 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54553 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbbATLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:30:06 -0500
Date: Tue, 20 Jan 2015 11:30:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [RESEND PATCH] mfd: wm8994: set mfd id-base for
 regulator devs creation to avoid conflicts
Message-ID: <20150120113000.GH13701@x1>
References: <1420679073-3316-1-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420679073-3316-1-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2015, Inha Song wrote:

> After commit: 6e3f62f0793e ("mfd: core: Fix platform-device id generation")
> We must set the id base when register a duplicate name of mfd_cell.
> If not, duplicate filename error was reported.
> 
> - sysfs: cannot create duplicate filename '/devices/.../wm8994-ldo'
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  drivers/mfd/wm8994-core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index e6fab94..47cd3cc 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -36,12 +36,12 @@
>  static const struct mfd_cell wm8994_regulator_devs[] = {
>  	{
>  		.name = "wm8994-ldo",
> -		.id = 1,
> +		.id = 0,
>  		.pm_runtime_no_callbacks = true,
>  	},
>  	{
>  		.name = "wm8994-ldo",
> -		.id = 2,
> +		.id = 1,
>  		.pm_runtime_no_callbacks = true,
>  	},
>  };
> @@ -344,7 +344,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
>  	dev_set_drvdata(wm8994->dev, wm8994);
>  
>  	/* Add the on-chip regulators first for bootstrapping */
> -	ret = mfd_add_devices(wm8994->dev, -1,
> +	ret = mfd_add_devices(wm8994->dev, 0,
>  			      wm8994_regulator_devs,
>  			      ARRAY_SIZE(wm8994_regulator_devs),
>  			      NULL, 0, NULL);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

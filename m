Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaLJJq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:46:58 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54487 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaLJJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:46:55 -0500
Date: Wed, 10 Dec 2014 09:46:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, broonie@kernel.org,
        anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix platform-device id collision
Message-ID: <20141210094649.GA23481@x1>
References: <1418175593-23474-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418175593-23474-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2014, Fabio Estevam wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Allow multiple DA9052 regulators be registered by registering with
> PLATFORM_DEVID_AUTO instead of PLATFORM_DEVID_NONE.
>    
> The subdevices are currently registered with PLATFORM_DEVID_NONE, which
> will cause a name collision on the platform bus when multiple regulators
> are registered:
> 
> [    0.128855] da9052-regulator da9052-regulator: invalid regulator ID specified
> [    0.128973] da9052-regulator: probe of da9052-regulator failed with error -22
> [    0.129148] ------------[ cut here ]------------
> [    0.129200] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5c/0x7c()
> [    0.129233] sysfs: cannot create duplicate filename '/devices/platform/soc/60000000.aips/63fc8000.i2c/i2c-0/0-0048/da9052-regulator
> ...
> [    0.132891] ------------[ cut here ]------------
> [    0.132924] WARNING: CPU: 0 PID: 1 at lib/kobject.c:240 kobject_add_internal+0x24c/0x2cc()
> [    0.132957] kobject_add_internal failed for da9052-regulator with -EEXIST, don't try to register things with the same name in the same directory.
> ...
> [    0.137000] da9052 0-0048: mfd_add_devices failed: -17
> [    0.138486] da9052: probe of 0-0048 failed with error -17
> 
> Based on the fix done by Johan Hovold at commit b6684228726cc255 ("mfd: 
> viperboard: Fix platform-device id collision"). 
> 
> Tested on a imx53-qsb board, where multiple DA9053 regulators can be 
> successfully probed.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/da9052-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied for v3.20, thanks.

> diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
> index 52a0c2f..ae498b5 100644
> --- a/drivers/mfd/da9052-core.c
> +++ b/drivers/mfd/da9052-core.c
> @@ -554,7 +554,8 @@ int da9052_device_init(struct da9052 *da9052, u8 chip_id)
>  		return ret;
>  	}
>  
> -	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
> +	ret = mfd_add_devices(da9052->dev, PLATFORM_DEVID_AUTO,
> +			      da9052_subdev_info,
>  			      ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
>  	if (ret) {
>  		dev_err(da9052->dev, "mfd_add_devices failed: %d\n", ret);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

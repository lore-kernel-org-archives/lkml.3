Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaHYW0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:26:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64715 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751780AbaHYW0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:26:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fan.c: printk replacement
Date: Tue, 26 Aug 2014 00:45:20 +0200
Message-ID: <6969509.uGLFfCOQBb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408709001-3272-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1408709001-3272-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2014 05:33:21 PM Sudip Mukherjee wrote:
> printk replaced with corresponding dev_err and dev_info
> fixed one broken user-visible string
> multiine comment edited for correct commenting style
> asm/uaccess.h replaced with linux/uaccess.h
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/acpi/fan.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> index 8acf53e..7900d55 100644
> --- a/drivers/acpi/fan.c
> +++ b/drivers/acpi/fan.c
> @@ -27,7 +27,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include <linux/thermal.h>
>  #include <linux/acpi.h>
>  
> @@ -127,8 +127,9 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
>  };
>  
>  /* --------------------------------------------------------------------------
> -                                 Driver Interface
> -   -------------------------------------------------------------------------- */
> + *                               Driver Interface
> + * --------------------------------------------------------------------------
> +*/
>  
>  static int acpi_fan_add(struct acpi_device *device)
>  {
> @@ -143,7 +144,7 @@ static int acpi_fan_add(struct acpi_device *device)
>  
>  	result = acpi_bus_update_power(device->handle, NULL);
>  	if (result) {
> -		printk(KERN_ERR PREFIX "Setting initial power state\n");
> +		dev_err(&device->dev, PREFIX "Setting initial power state\n");

While at it, please define a proper pr_fmt() for this file and get rid of PREFIX
too.

Otherwise I don't see a compelling reason to apply this.

>  		goto end;
>  	}
>  
> @@ -168,10 +169,10 @@ static int acpi_fan_add(struct acpi_device *device)
>  				   &device->dev.kobj,
>  				   "device");
>  	if (result)
> -		dev_err(&device->dev, "Failed to create sysfs link "
> -			"'device'\n");
> +		dev_err(&device->dev,
> +			"Failed to create sysfs link 'device'\n");
>  
> -	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
> +	dev_info(&device->dev, PREFIX "%s [%s] (%s)\n",
>  	       acpi_device_name(device), acpi_device_bid(device),
>  	       !device->power.state ? "on" : "off");
>  
> @@ -214,10 +215,9 @@ static int acpi_fan_resume(struct device *dev)
>  
>  	if (!dev)
>  		return -EINVAL;
> -

That empty line is intentional, please don't remove it.

Moreover, in any case this change doesn't belong to your patch.

>  	result = acpi_bus_update_power(to_acpi_device(dev)->handle, NULL);
>  	if (result)
> -		printk(KERN_ERR PREFIX "Error updating fan power state\n");
> +		dev_err(dev, PREFIX "Error updating fan power state\n");
>  
>  	return result;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

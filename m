Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaJ1Vj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:39:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64975 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755208AbaJ1VjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:39:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Tue, 28 Oct 2014 22:59:57 +0100
Message-ID: <2740724.5yjNTKs1RY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
> acpi_dev_add_driver_gpios() makes it possible to set up mapping between
> properties and ACPI GpioIo resources in a driver, so we can take index
> parameter in acpi_find_gpio() into use with _DSD device properties now.
> 
> This index can be used to select a GPIO from a property with multiple
> GPIOs:
> 
>   Package () {
>   	"data-gpios",
>   	Package () {
>   		\_SB.GPIO, 0, 0, 0,
>   		\_SB.GPIO, 1, 0, 0,
>   		\_SB.GPIO, 2, 0, 1,
>   	}
>   }
> 
> In order to retrieve the last GPIO from a driver we can simply do:
> 
>   desc = devm_gpiod_get_index(dev, "data", 2);
> 
> and so on.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Cool. :-)

Any objections anyone?

> ---
> This is on top of latest linux-pm/device-properties.
> 
>  drivers/gpio/gpiolib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index fbf717a56b0a..58659dbe702a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1522,7 +1522,7 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
>  				 suffixes[i]);
>  		}
>  
> -		desc = acpi_get_gpiod_by_index(adev, propname, 0, &info);
> +		desc = acpi_get_gpiod_by_index(adev, propname, idx, &info);
>  		if (!IS_ERR(desc) || (PTR_ERR(desc) == -EPROBE_DEFER))
>  			break;
>  	}
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaLOOO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:14:27 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64847 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaLOOOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:14:23 -0500
Date: Mon, 15 Dec 2014 06:14:18 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 12/12] input: cyapa: add acpi device id supported
Message-ID: <20141215141418.GJ918@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
 <1418624603-19054-13-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418624603-19054-13-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Mon, Dec 15, 2014 at 02:23:23PM +0800, Dudley Du wrote:
> Add acpi device tree supported.
                       support.

> acpi device id "CYAP0000" is for old gen3 trackpad devices.
> acpi device id "CYAP0001" is for new gen5 trackpad devices.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> ---
>  drivers/input/mouse/cyapa.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index dac3996..9fb97e2 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/acpi.h>
>  #include "cyapa.h"
>  
>  
> @@ -1315,11 +1316,23 @@ static const struct i2c_device_id cyapa_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, cyapa_id_table);
>  
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id cyapa_acpi_id[] = {
> +	{ "CYAP0000", 0 },  /* Gen3 trackpad with 0x67 I2C address. */
> +	{ "CYAP0001", 0 },  /* Gen5 trackpad with 0x24 I2C address. */
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(acpi, cyapa_acpi_id);
> +#endif
> +
>  static struct i2c_driver cyapa_driver = {
>  	.driver = {
>  		.name = "cyapa",
>  		.owner = THIS_MODULE,
>  		.pm = &cyapa_pm_ops,
> +#ifdef CONFIG_ACPI
> +		.acpi_match_table = ACPI_PTR(cyapa_acpi_id),
> +#endif
>  	},
>  
>  	.probe = cyapa_probe,
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
- Jeremiah Mahler

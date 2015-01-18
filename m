Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbbARI2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 03:28:23 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46088 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbbARI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 03:28:20 -0500
Date: Sun, 18 Jan 2015 00:28:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: jmmahler@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 12/12] input: cyapa: add acpi device id support
Message-ID: <20150118082814.GD15720@dtor-ws>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-13-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421390055-32760-13-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 02:34:15PM +0800, Dudley Du wrote:
> Add acpi device tree support.
> acpi device id "CYAP0000" is for old gen3 trackpad devices.
> acpi device id "CYAP0001" is for new gen5 trackpad devices.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudl@cypress.com>
> ---
>  drivers/input/mouse/cyapa.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index 5f9b24a..9dc9f65 100644
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
> @@ -1356,11 +1357,23 @@ static const struct i2c_device_id cyapa_id_table[] = {
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

I do not think you should guard it with CONFIG_ACPI, so I dropped it.

> +#endif
>  	},
>  
>  	.probe = cyapa_probe,
> -- 
> 1.9.1
> 

Thanks.

-- 
Dmitry

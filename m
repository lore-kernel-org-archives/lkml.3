Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab3K1NRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:17:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62827 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751588Ab3K1NRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:17:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Drews <paul.drews@intel.com>, linus.walleij@linaro.org
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Add BayTrail SoC GPIO and LPSS ACPI IDs
Date: Thu, 28 Nov 2013 14:29:53 +0100
Message-ID: <1595199.2xkkMsZdTD@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385417755-21776-1-git-send-email-paul.drews@intel.com>
References: <1385417755-21776-1-git-send-email-paul.drews@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 02:15:55 PM Paul Drews wrote:
> This adds the new ACPI ID (INT33FC) for the BayTrail GPIO
> banks as seen on a BayTrail M System-On-Chip platform.  This
> ACPI ID is used by the BayTrail GPIO (pinctrl) driver to
> manage the Low Power Subsystem (LPSS).
> 
> Signed-off-by: Paul Drews <paul.drews@intel.com>

Linus, any objections to this?  If not, I'll take it for 3.14.

Thanks,
Rafael


> ---
>  drivers/acpi/acpi_lpss.c           | 1 +
>  drivers/pinctrl/pinctrl-baytrail.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 6745fe1..e603905 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -162,6 +162,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
>  	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
>  	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
>  	{ "INT33B2", },
> +	{ "INT33FC", },
>  
>  	{ "INT3430", (unsigned long)&lpt_dev_desc },
>  	{ "INT3431", (unsigned long)&lpt_dev_desc },
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index 2832576..114f5ef 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -512,6 +512,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
>  
>  static const struct acpi_device_id byt_gpio_acpi_match[] = {
>  	{ "INT33B2", 0 },
> +	{ "INT33FC", 0 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

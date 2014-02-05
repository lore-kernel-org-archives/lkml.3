Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaBDX4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:56:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63711 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755179AbaBDX4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:56:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] ACPI / LPSS: Add BYT ACPI mode PWM
Date: Wed, 05 Feb 2014 01:10:46 +0100
Message-ID: <7753658.iUv9mCkDx9@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1390245122-18907-1-git-send-email-chiau.ee.chew@intel.com>
References: <1390245122-18907-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 21, 2014 03:12:02 AM Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> Intel BayTrail LPSS consists of two PWM controllers which can
> be enumerated from ACPI namespace.

First, please say "Bay Trail" (or similar) instead of BYT in the subject.

Second, please say in the changelog what the patch will cause to happen.

For example, "This change will cause platform device objects to be
created for PWM controllers on Bay Trail which will allow the <driver
that's going to handle those things> driver to bind to them and handle
those devices."

Finally, the PWM maintainer has to see this.

Thanks!

> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  drivers/acpi/acpi_lpss.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 6745fe1..8c2bae9 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -102,6 +102,16 @@ static struct lpss_device_desc lpt_sdio_dev_desc = {
>  	.ltr_required = true,
>  };
>  
> +static struct lpss_shared_clock pwm_clock = {
> +	.name = "pwm_clk",
> +	.rate = 25000000,
> +};
> +
> +static struct lpss_device_desc byt_pwm_dev_desc = {
> +	.clk_required = true,
> +	.shared_clock = &pwm_clock,
> +};
> +
>  static struct lpss_shared_clock uart_clock = {
>  	.name = "uart_clk",
>  	.rate = 44236800,
> @@ -157,6 +167,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
>  	{ "INT33C7", },
>  
>  	/* BayTrail LPSS devices */
> +	{ "80860F09", (unsigned long)&byt_pwm_dev_desc },
>  	{ "80860F0A", (unsigned long)&byt_uart_dev_desc },
>  	{ "80860F0E", (unsigned long)&byt_spi_dev_desc },
>  	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

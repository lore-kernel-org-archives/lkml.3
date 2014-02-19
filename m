Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaBSAcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:32:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61369 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752610AbaBSAc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:32:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH v2] ACPI / LPSS: Add Intel BayTrail ACPI mode PWM
Date: Wed, 19 Feb 2014 01:47:19 +0100
Message-ID: <4137960.8hdMdSsOri@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392747869-31435-1-git-send-email-chiau.ee.chew@intel.com>
References: <1392747869-31435-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 19, 2014 02:24:29 AM Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> Intel BayTrail LPSS consists of two PWM controllers which can
> be enumerated from ACPI namespace. This change will cause
> platform device objects to be created for Intel BayTrail PWM
> controllers which will allow the pwm-lpss driver to bind to them
> and handle those devices.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Queued up for 3.15, thanks!

> ---
>  drivers/acpi/acpi_lpss.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 2428857..9e22c13 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -96,6 +96,16 @@ static struct lpss_device_desc lpt_sdio_dev_desc = {
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
> @@ -151,6 +161,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
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

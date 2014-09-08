Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaIHVyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:54:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63524 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754703AbaIHVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:54:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>, Darren Hart <dvhart@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Tue, 09 Sep 2014 00:14:04 +0200
Message-ID: <1786905.chzpd7cfQ3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408807277.3315.43.camel@rzhang1-toshiba>
References: <5487060.QsgluucUH4@vostro.rjw.lan> <3770704.uNPCcL4EDK@vostro.rjw.lan> <1408807277.3315.43.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 23, 2014 11:21:17 PM Zhang Rui wrote:

[cut]

Darren, would there be any problems if I took the patch below from Rui for 3.18?

> 
> So I guess the following patch can be upstream candidate, right?
> 
> From e32c2de37750d622dae6ef9d2f5c448a528a7edb Mon Sep 17 00:00:00 2001
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Fri, 22 Aug 2014 09:06:10 +0800
> Subject: [PATCH] ACPI: remove Fujitsu backlight and hotkey device ID from ACPI
>  PNP id list
> 
> Fujitsu backlight and hotkey devices have ACPI drivers.
> The PNP MODULE_DEVICE_TABLE in fujitsu-laptop driver is just used as an
> indicator for module autoloading. But this is wrong because what we need is
> ACPI module device table instead because the driver is probing ACPI devices.
> 
> Thus remove those ids from ACPI PNP scan handler list as we don't
> have PNP driver for them, and convert the fujitsu-laptop PNP
> MODULE_DEVICE_TABLE to ACPI MODULE_DEVICE_TABLE.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=81971
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Tested-by: Dirk Griesbach <spamthis@freenet.de>
> ---
>  drivers/acpi/acpi_pnp.c               |  4 ----
>  drivers/platform/x86/fujitsu-laptop.c | 16 +++++++---------
>  2 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> index 1f8b204..b193f84 100644
> --- a/drivers/acpi/acpi_pnp.c
> +++ b/drivers/acpi/acpi_pnp.c
> @@ -130,10 +130,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
>  	{"PNP0401"},		/* ECP Printer Port */
>  	/* apple-gmux */
>  	{"APP000B"},
> -	/* fujitsu-laptop.c */
> -	{"FUJ02bf"},
> -	{"FUJ02B1"},
> -	{"FUJ02E3"},
>  	/* system */
>  	{"PNP0c02"},		/* General ID for reserving resources */
>  	{"PNP0c01"},		/* memory controller */
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index 87aa28c..2655d4a 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -1050,6 +1050,13 @@ static struct acpi_driver acpi_fujitsu_hotkey_driver = {
>  		},
>  };
>  
> +static const struct acpi_device_id fujitsu_ids[] __used = {
> +	{ACPI_FUJITSU_HID, 0},
> +	{ACPI_FUJITSU_HOTKEY_HID, 0},
> +	{"", 0}
> +};
> +MODULE_DEVICE_TABLE(acpi, fujitsu_ids);
> +
>  static int __init fujitsu_init(void)
>  {
>  	int ret, result, max_brightness;
> @@ -1208,12 +1215,3 @@ MODULE_LICENSE("GPL");
>  MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
>  MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
>  MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
> -
> -static struct pnp_device_id pnp_ids[] __used = {
> -	{.id = "FUJ02bf"},
> -	{.id = "FUJ02B1"},
> -	{.id = "FUJ02E3"},
> -	{.id = ""}
> -};
> -
> -MODULE_DEVICE_TABLE(pnp, pnp_ids);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

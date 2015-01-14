Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbbANPwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:52:31 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34399 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbANPw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:52:29 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [Linaro-acpi] [PATCH 2/2] ata: ahci_platform: Add ACPI _CLS
 matching
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, rjw@rjwysocki.net,
        lenb@kernel.org, hdegoede@redhat.com, tj@kernel.org, arnd@arndb.de,
        mjg59@srcf.ucam.org
Cc: linux-ide@vger.kernel.org, linaro-acpi@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <1419019988-4398-3-git-send-email-Suravee.Suthikulpanit@amd.com>
References: <1419019988-4398-1-git-send-email-Suravee.Suthikulpanit@amd.com>
	<1419019988-4398-3-git-send-email-Suravee.Suthikulpanit@amd.com>
Date: Wed, 14 Jan 2015 15:52:25 +0000
Message-Id: <20150114155225.7F098C40FDA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014 14:13:08 -0600
, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
 wrote:
> This patch adds ACPI supports for AHCI platform driver, which uses _CLS
> method to match the device.
> 
> The following is an example of ASL structure in DSDT for a SATA controller,
> which contains _CLS package to be matched by the ahci_platform driver:
> 
>   Device (AHC0) // AHCI Controller
>   {
>     Name(_HID, "AMDI0600")
>     Name (_CCA, 1)
>     Name (_CLS, Package (3)
>     {
>       0x01, // Base Class: Mass Storage
>       0x06, // Sub-Class: serial ATA
>       0x01, // Interface: AHCI
>     })
>     Name (_CRS, ResourceTemplate ()
>     {
>       Memory32Fixed (ReadWrite, 0xE0300000, 0x00010000)
>       Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive,,,) { 387 }
>     })
>   }
> 
> Also, since ATA driver should not require PCI support for ATA_ACPI,
> this patch removes dependency in the driver/ata/Kconfig.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Looks good to me.

Reviewed-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/ata/Kconfig         | 2 +-
>  drivers/ata/ahci_platform.c | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index cd4cccb..edb00c6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -48,7 +48,7 @@ config ATA_VERBOSE_ERROR
>  
>  config ATA_ACPI
>  	bool "ATA ACPI Support"
> -	depends on ACPI && PCI
> +	depends on ACPI
>  	default y
>  	help
>  	  This option adds support for ATA-related ACPI objects.
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 06f1d59..4879f9b 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -71,6 +71,8 @@ static const struct of_device_id ahci_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);
>  
> +static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
> +
>  static struct platform_driver ahci_driver = {
>  	.probe = ahci_probe,
>  	.remove = ata_platform_remove_one,
> @@ -78,6 +80,7 @@ static struct platform_driver ahci_driver = {
>  		.name = "ahci",
>  		.owner = THIS_MODULE,
>  		.of_match_table = ahci_of_match,
> +		.acpi_cls = &ahci_cls,
>  		.pm = &ahci_pm_ops,
>  	},
>  };
> -- 
> 1.9.3
> 
> 
> _______________________________________________
> Linaro-acpi mailing list
> Linaro-acpi@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-acpi


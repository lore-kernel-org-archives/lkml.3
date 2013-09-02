Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3IBMOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:14:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52181 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab3IBMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:14:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Imre Kaloz <kaloz@openwrt.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / LPSS: don't crash if a device has no MMIO resources
Date: Mon, 02 Sep 2013 14:25:22 +0200
Message-ID: <2039525.IqjUGZ56ra@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378117825-15852-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378117825-15852-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 02, 2013 01:30:25 PM Mika Westerberg wrote:
> Intel LPSS devices that are enumerated from ACPI have both MMIO and IRQ
> resources returned in their _CRS method. However, Apple Macbook Air with
> Haswell has LPSS devices enumerated from PCI bus instead and _CRS method
> returns only an interrupt number (but the device has _HID set that causes
> the scan handler to match it).
> 
> The current ACPI / LPSS code sets pdata->dev_desc only when MMIO resource
> is found for the device and in case of Macbook Air it is never found. That
> leads to a NULL pointer dereference in register_device_clock().
> 
> Correct this by always setting the pdata->dev_desc.
> 
> Reported-and-tested-by: Imre Kaloz <kaloz@openwrt.org>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: stable@vger.kernel.org # 3.10+

Queued up for 3.12, thanks for taking care of this Mika!

> ---
>  drivers/acpi/acpi_lpss.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 6a38218..fb78bb9 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -257,12 +257,13 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>  				pdata->mmio_size = resource_size(&rentry->res);
>  			pdata->mmio_base = ioremap(rentry->res.start,
>  						   pdata->mmio_size);
> -			pdata->dev_desc = dev_desc;
>  			break;
>  		}
>  
>  	acpi_dev_free_resource_list(&resource_list);
>  
> +	pdata->dev_desc = dev_desc;
> +
>  	if (dev_desc->clk_required) {
>  		ret = register_device_clock(adev, pdata);
>  		if (ret) {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

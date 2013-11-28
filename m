Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab3K1OC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:02:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62064 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754912Ab3K1OCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:02:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: bhelgaas@google.com, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / PCI / hotplug: Avoid warning when _ADR not present
Date: Thu, 28 Nov 2013 15:15:45 +0100
Message-ID: <2967007.tqmdbM4ZBo@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385584389-22461-1-git-send-email-toshi.kani@hp.com>
References: <1385584389-22461-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 01:33:09 PM Toshi Kani wrote:
> acpiphp_enumerate_slots() walks ACPI namenamespace under
> a PCI host bridge with callback register_slot().
> register_slot() evaluates _ADR for all the device objects
> and emits a warning message for any error.  Some platforms
> have _HID device objects (such as HPET and IPMI), which
> trigger unnecessary warning messages.
> 
> This patch avoids emitting a warning message when a target
> device object does not have _ADR.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
> Patch is based on Linus's tree (3.13-rc1).

Queued up as a fix for 3.13, thanks!

> ---
>  drivers/pci/hotplug/acpiphp_glue.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 1cf605f..438a4d0 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -279,7 +279,9 @@ static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
>  
>  	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
>  	if (ACPI_FAILURE(status)) {
> -		acpi_handle_warn(handle, "can't evaluate _ADR (%#x)\n", status);
> +		if (status != AE_NOT_FOUND)
> +			acpi_handle_warn(handle,
> +				"can't evaluate _ADR (%#x)\n", status);
>  		return AE_OK;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

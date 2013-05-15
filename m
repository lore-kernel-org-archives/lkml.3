Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab3EOSVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:21:16 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:5761 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab3EOSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:21:14 -0400
Message-ID: <1368642071.5673.37.camel@misato.fc.hp.com>
Subject: Re: [PATCH] acpi: Fix memory leak on acpi_scan_init_hotplug() error
 path
From: Toshi Kani <toshi.kani@hp.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 15 May 2013 12:21:11 -0600
In-Reply-To: <1368636575-5480-1-git-send-email-catalin.marinas@arm.com>
References: <1368636575-5480-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 17:49 +0100, Catalin Marinas wrote:
> Following commit 6b772e8f9 (ACPI: Update PNPID match handling for
> notify), the acpi_scan_init_hotplug() calls acpi_set_pnp_ids() which
> allocates acpi_hardware_id and copies a few strings (kstrdup). If the
> devices does not have hardware_id set, the function exits without
> freeing the previously allocated ids (and kmemleak complains). This
> patch calls simply changes 'return' on error to a 'goto out' which calls
> acpi_free_pnp_ids().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Toshi Kani <toshi.kani@hp.com>

Testing was performed by adding a fake ACPI object with _UID only.

Thanks,
-Toshi

> ---
>  drivers/acpi/scan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index fe158fd..c1bc608 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1785,7 +1785,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
>  	acpi_set_pnp_ids(handle, &pnp, type);
>  
>  	if (!pnp.type.hardware_id)
> -		return;
> +		goto out;
>  
>  	/*
>  	 * This relies on the fact that acpi_install_notify_handler() will not
> @@ -1800,6 +1800,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
>  		}
>  	}
>  
> +out:
>  	acpi_free_pnp_ids(&pnp);
>  }
>  



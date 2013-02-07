Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696Ab3BGWM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:12:26 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59754 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651Ab3BGWMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:12:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH] ACPI: Unbind ACPI drv when probe failed
Date: Thu, 07 Feb 2013 23:18:45 +0100
Message-ID: <1992165.bgMBd9nLM4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360271953-15643-1-git-send-email-toshi.kani@hp.com>
References: <1360271953-15643-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2013 02:19:13 PM Toshi Kani wrote:
> When acpi_device_install_notify_handler() failed in acpi_device_probe(),
> it calls acpi_drv->ops.remove() and fails the probe.  However, the ACPI
> driver is left bound to the acpi_device.  Fix it by clearing the driver
> and driver_data fields.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
> This patch is based on linux-pm.git/bleeding-edge.

Good catch, thanks.  I'm going to apply it.

Rafael


> ---
>  drivers/acpi/scan.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d6caf1d..39659bb 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -627,6 +627,8 @@ static int acpi_device_probe(struct device * dev)
>  			if (ret) {
>  				if (acpi_drv->ops.remove)
>  					acpi_drv->ops.remove(acpi_dev);
> +				acpi_dev->driver = NULL;
> +				acpi_dev->driver_data = NULL;
>  				return ret;
>  			}
>  		}
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

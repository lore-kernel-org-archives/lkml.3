Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3AaDmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:42:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52002 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3AaDmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:42:05 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5109E7EA.5010507@jp.fujitsu.com>
Date: Thu, 31 Jan 2013 12:41:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 2/2] ACPI / scan: Clean up acpi_bus_get_parent()
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <7667918.svVNymu9rt@vostro.rjw.lan>
In-Reply-To: <7667918.svVNymu9rt@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/31 7:04, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Make acpi_bus_get_parent() more straightforward and remove an
> unnecessary local variable ret from it.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

>   drivers/acpi/scan.c |   16 +++++-----------
>   1 file changed, 5 insertions(+), 11 deletions(-)
>
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -871,29 +871,23 @@ EXPORT_SYMBOL(acpi_bus_unregister_driver
>      -------------------------------------------------------------------------- */
>   static struct acpi_device *acpi_bus_get_parent(acpi_handle handle)
>   {
> +	struct acpi_device *device = NULL;
>   	acpi_status status;
> -	int ret;
> -	struct acpi_device *device;
>
>   	/*
>   	 * Fixed hardware devices do not appear in the namespace and do not
>   	 * have handles, but we fabricate acpi_devices for them, so we have
>   	 * to deal with them specially.
>   	 */
> -	if (handle == NULL)
> +	if (!handle)
>   		return acpi_root;
>
>   	do {
>   		status = acpi_get_parent(handle, &handle);
> -		if (status == AE_NULL_ENTRY)
> -			return NULL;
>   		if (ACPI_FAILURE(status))
> -			return acpi_root;
> -
> -		ret = acpi_bus_get_device(handle, &device);
> -		if (ret == 0)
> -			return device;
> -	} while (1);
> +			return status == AE_NULL_ENTRY ? NULL : acpi_root;
> +	} while (acpi_bus_get_device(handle, &device));
> +	return device;
>   }
>
>   acpi_status
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



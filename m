Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3FSEpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:45:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46162 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3FSEpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:45:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51C13768.30000@jp.fujitsu.com>
Date: Wed, 19 Jun 2013 13:45:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] ACPI / PM: Fix error code path for power resources initialization
References: <8547354.D2OPcUytEB@vostro.rjw.lan>
In-Reply-To: <8547354.D2OPcUytEB@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/06/18 7:37, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Commit 781d737 (ACPI: Drop power resources driver) introduced a
> bug in the power resources initialization error code path causing
> a NULL pointer to be referenced in acpi_release_power_resource()
> if there's an error triggering a jump to the 'err' label in
> acpi_add_power_resource().  This happens because the list_node
> field of struct acpi_power_resource has not been initialized yet
> at this point and doing a list_del() on it is a bad idea.
>
> To prevent this problem from occuring, initialize the list_node
> field of struct acpi_power_resource upfront.
>
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: 3.9+ <stable@vger.kernel.org>

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>   drivers/acpi/power.c |    1 +
>   1 file changed, 1 insertion(+)
>
> Index: linux-pm/drivers/acpi/power.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/power.c
> +++ linux-pm/drivers/acpi/power.c
> @@ -882,6 +882,7 @@ int acpi_add_power_resource(acpi_handle
>   				ACPI_STA_DEFAULT);
>   	mutex_init(&resource->resource_lock);
>   	INIT_LIST_HEAD(&resource->dependent);
> +	INIT_LIST_HEAD(&resource->list_node);
>   	resource->name = device->pnp.bus_id;
>   	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
>   	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



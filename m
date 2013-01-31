Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3AaDM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:12:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57840 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3AaDMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:12:54 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5109E11A.5030400@jp.fujitsu.com>
Date: Thu, 31 Jan 2013 12:12:26 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/4] Fix acpi_bus_get_device() check
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <6099377.PFvsxPeyib@vostro.rjw.lan>
In-Reply-To: <6099377.PFvsxPeyib@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions use ACPI_SUCCESS/FAILURE for checking return value of
acpi_bus_get_device().

Following patches change not to apply ACPI_SUCCESS/FAILURE to the
return value of acpi_bus_get_device().

[PATCH 1/4] ACPI/PM: Fix acpi_bus_get_device() check in drivers/acpi/device_pm.c
[PATCH 2/4] ACPI/dock: Fix acpi_bus_get_device() check in drivers/acpi/ddock.c
[PATCH 3/4] PNPACPI: Fix acpi_bus_get_device() check in drivers/pnp/pnpacpi/core.c
[PATCH 4/4] GPU/i915: Fix acpi_bus_get_device() check in drivers/gpu/drm/i915/intel_opregion.c

2013/01/31 7:03, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Since acpi_bus_get_device() returns int and not acpi_status, change
> acpi_match_device() so that it doesn't apply ACPI_FAILURE() to the
> return value of acpi_bus_get_device().
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/acpi/scan.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -491,9 +491,9 @@ const struct acpi_device_id *acpi_match_
>   					       const struct device *dev)
>   {
>   	struct acpi_device *adev;
> +	acpi_handle handle = ACPI_HANDLE(dev);
>
> -	if (!ids || !ACPI_HANDLE(dev)
> -	    || ACPI_FAILURE(acpi_bus_get_device(ACPI_HANDLE(dev), &adev)))
> +	if (!ids || !handle || acpi_bus_get_device(handle, &adev))
>   		return NULL;
>
>   	return __acpi_match_device(adev, ids);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



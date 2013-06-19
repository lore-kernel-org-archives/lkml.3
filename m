Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3FSHZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:25:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:45529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab3FSHZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:25:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="331980294"
Date: Wed, 19 Jun 2013 10:29:56 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Fix error code path for power resources
 initialization
Message-ID: <20130619072956.GE11878@intel.com>
References: <8547354.D2OPcUytEB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8547354.D2OPcUytEB@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:37:45AM +0200, Rafael J. Wysocki wrote:
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

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: 3.9+ <stable@vger.kernel.org>
> ---
>  drivers/acpi/power.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-pm/drivers/acpi/power.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/power.c
> +++ linux-pm/drivers/acpi/power.c
> @@ -882,6 +882,7 @@ int acpi_add_power_resource(acpi_handle
>  				ACPI_STA_DEFAULT);
>  	mutex_init(&resource->resource_lock);
>  	INIT_LIST_HEAD(&resource->dependent);
> +	INIT_LIST_HEAD(&resource->list_node);
>  	resource->name = device->pnp.bus_id;
>  	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
>  	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);

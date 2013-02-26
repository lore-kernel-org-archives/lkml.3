Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781Ab3BZXYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:24:05 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:42601 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3BZXYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:24:02 -0500
Message-ID: <1361920386.12845.99.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2, 3/7] ACPI / container: Use common hotplug code
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Date: Tue, 26 Feb 2013 16:13:06 -0700
In-Reply-To: <2961608.xElddy7TSk@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
	 <3171747.TOMjvVkWL1@vostro.rjw.lan> <2961608.xElddy7TSk@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 23:46 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Switch the ACPI container driver to using common device hotplug code
> introduced previously.  This reduces the driver down to a trivial
> definition and registration of a struct acpi_scan_handler object.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/container.c |  146 +++--------------------------------------------
>  1 file changed, 10 insertions(+), 136 deletions(-)
> 
> Index: test/drivers/acpi/container.c
> ===================================================================
> --- test.orig/drivers/acpi/container.c
> +++ test/drivers/acpi/container.c
> @@ -1,12 +1,12 @@
>  /*
> - * acpi_container.c  - ACPI Generic Container Driver
> - * ($Revision: )
> + * container.c  - ACPI Generic Container Driver
>   *
>   * Copyright (C) 2004 Anil S Keshavamurthy (anil.s.keshavamurthy@intel.com)
>   * Copyright (C) 2004 Keiichiro Tokunaga (tokunaga.keiich@jp.fujitsu.com)
>   * Copyright (C) 2004 Motoyuki Ito (motoyuki@soft.fujitsu.com)
> - * Copyright (C) 2004 Intel Corp.
>   * Copyright (C) 2004 FUJITSU LIMITED
> + * Copyright (C) 2004, 2013 Intel Corp.
> + * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   *
> @@ -26,14 +26,9 @@
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/slab.h>
> -#include <linux/types.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
> +
> +#include "internal.h"
>  
>  #define PREFIX "ACPI: "
>  
> @@ -50,141 +45,20 @@ static const struct acpi_device_id conta
>  static int container_device_attach(struct acpi_device *device,
>  				   const struct acpi_device_id *not_used)
>  {
> -	/*
> -	 * FIXME: This is necessary, so that acpi_eject_store() doesn't return
> -	 * -ENODEV for containers.
> -	 */
> +	/* This is necessary for container hotplug to work. */
>  	return 1;
>  }
>  
>  static struct acpi_scan_handler container_device_handler = {
>  	.ids = container_device_ids,
>  	.attach = container_device_attach,
> +	.hotplug = {
> +		.enabled = true,
> +		.user_eject = true,

I am not able to compile this patch 3/7...  user_eject is not defined in
patch 2/7.

  CC      drivers/acpi/container.o
drivers/acpi/container.c:57:3: error: unknown field ‘user_eject’
specified in initializer

-Toshi


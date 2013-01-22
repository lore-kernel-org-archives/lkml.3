Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3AVXti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:49:38 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:58295 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AVXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:49:32 -0500
Date: Tue, 22 Jan 2013 15:49:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/4] ACPI / PM: Expose current status of ACPI power
 resources
Message-ID: <20130122234928.GD694@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <4247313.2G7Z3nCgM0@vostro.rjw.lan>
 <2760421.6nE3tkh92K@vostro.rjw.lan>
 <4550268.C8GqG2xqOO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4550268.C8GqG2xqOO@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:26:29AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since ACPI power resources are going to be used more extensively on
> new hardware platforms, it becomes necessary for user space (powertop
> in particular) to observe some properties of those resources for
> diagnostics purposes.
> 
> For this reason, expose the current status of each ACPI power
> resource to user space via sysfs by adding a new resource_in_use
> attribute to the sysfs directory representing the given power
> resource.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

But, as with patch 1/4, this is racy:

> @@ -723,6 +744,9 @@ int acpi_add_power_resource(acpi_handle
>  	if (result)
>  		goto err;
>  
> +	if (!device_create_file(&device->dev, &dev_attr_resource_in_use))
> +		device->remove = acpi_power_sysfs_remove;
> +

You are creating the file after userspace has been told that the device
is present.

As this looks like the first file this type of device has, maybe you
should just fix this up "properly" here, and not wait to do it later?

Your choice,

greg k-h

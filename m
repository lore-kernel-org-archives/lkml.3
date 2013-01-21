Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3AUUxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:53:13 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58601 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3AUUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:53:09 -0500
Date: Mon, 21 Jan 2013 12:53:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][Update 2][PATCH 1/4] ACPI / PM: Export power states of
 ACPI devices via sysfs
Message-ID: <20130121205305.GA17006@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <2096792.ELJ8WGVaaz@vostro.rjw.lan>
 <4247313.2G7Z3nCgM0@vostro.rjw.lan>
 <1783611.vYsnfNDZr6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1783611.vYsnfNDZr6@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:04:32PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Make it possible to retrieve the current power state of a device with
> ACPI power management from user space via sysfs by adding a new
> attribute power_state to the sysfs directory associated with the
> struct acpi_device object representing the device's ACPI node.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-power_state |   21 ++++++++++++++
>  drivers/acpi/scan.c                                 |   29 +++++++++++++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -178,6 +178,23 @@ err_out:
>  }
>  EXPORT_SYMBOL(acpi_bus_hot_remove_device);
>  
> +static ssize_t power_state_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct acpi_device *adev = to_acpi_device(dev);
> +	int state;
> +	int ret;
> +
> +	ret = acpi_device_get_power(adev, &state);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%s %s\n", acpi_power_state_string(state),
> +		       acpi_power_state_string(adev->power.state));
> +}

You are showing 2 different things here in a single sysfs file, which is
really frowned apon.  Any chance to split this up into two different
sysfs files instead?

thanks,

greg k-h

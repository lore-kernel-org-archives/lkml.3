Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaD1BlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:41:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:47019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaD1BlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:41:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,940,1389772800"; 
   d="scan'208";a="530650452"
Message-ID: <1398649251.2443.2.camel@rzhang1-mobl4>
Subject: Re: [PATCH V5 02/12] PNPACPI: use whilte list for pnpacpi device
 enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 28 Apr 2014 09:40:51 +0800
In-Reply-To: <34978551.c1lKBcQLqc@vostro.rjw.lan>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>
	 <1396886819-2637-3-git-send-email-rui.zhang@intel.com>
	 <34978551.c1lKBcQLqc@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 00:01 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 08, 2014 12:06:49 AM Zhang Rui wrote:
> 
> [...]
> 
> > +
> > +static int acpi_pnp_scan_handler_attach(struct acpi_device *adev,
> > +					const struct acpi_device_id *id)
> > +{
> > +	return 1;
> > +}
> > +
> > +static int acpi_pnp_scan_handler_match(char *devid, char *handlerid)
> > +{
> > +	int i;
> > +
> > +	if (memcmp(devid, handlerid, 3))
> > +		return 0;
> > +
> > +	for (i = 3; i < 7; i++) {
> > +		/* Not a HEX value */
> > +		if (!((devid[i] >= '0' && devid[i] <= '9') ||
> > +		      (devid[i] > 'A' && devid[i] <= 'F')))
> > +			return 0;
> > +
> > +		if ((handlerid[i] != 'X') &&
> 
> Hmm.  What exactly is the above check for?
> 
PNP bus supports wildcard in the drivers' id list.
say, drivers/tty/serial/8250/8250_pnp.c
      {"WACFXXX"},            /* Wacom tablets */
means the driver wants to try to probe all the PNP devices start with
"WACF".

thanks,
rui
> > +		    toupper(devid[i]) != toupper(handlerid[i]))
> > +			return 0;
> > +	}
> > +	return 1;
> > +}
> > +
> > +static struct acpi_scan_handler acpi_pnp_handler = {
> > +	.ids = acpi_pnp_device_ids,
> > +	.match = acpi_pnp_scan_handler_match,
> > +	.attach = acpi_pnp_scan_handler_attach,
> > +};
> > +
> > +bool acpi_is_pnp_device(struct acpi_device *device)
> > +{
> > +	return device->handler == &acpi_pnp_handler;
> > +}
> > +EXPORT_SYMBOL_GPL(acpi_is_pnp_device);
> > +
> > +void __init acpi_pnp_init(void)
> > +{
> > +	acpi_scan_add_handler(&acpi_pnp_handler);
> > +}
> > diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> 
> 



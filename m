Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3A2IB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:01:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:51140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3A2IBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:01:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,557,1355126400"; 
   d="scan'208";a="254025766"
Date: Tue, 29 Jan 2013 10:05:09 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ACPI / platform: Use struct acpi_scan_handler for
 creating devices
Message-ID: <20130129080509.GK2239@intel.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
 <4311642.nDd2RCVeDc@vostro.rjw.lan>
 <1540645.4oLGJ3spZ3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540645.4oLGJ3spZ3@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 02:01:14PM +0100, Rafael J. Wysocki wrote:
> +/* Flags for acpi_create_platform_device */
> +#define ACPI_PLATFORM_CLK	BIT(0)
> +
> +/*
> + * The following ACPI IDs are known to be suitable for representing as
> + * platform devices.
> + */
> +static const struct acpi_device_id acpi_platform_device_ids[] = {
> +
> +	{ "PNP0D40" },
> +
> +	/* Haswell LPSS devices */
> +	{ "INT33C0", ACPI_PLATFORM_CLK },
> +	{ "INT33C1", ACPI_PLATFORM_CLK },
> +	{ "INT33C2", ACPI_PLATFORM_CLK },
> +	{ "INT33C3", ACPI_PLATFORM_CLK },
> +	{ "INT33C4", ACPI_PLATFORM_CLK },
> +	{ "INT33C5", ACPI_PLATFORM_CLK },
> +	{ "INT33C6", ACPI_PLATFORM_CLK },
> +	{ "INT33C7", ACPI_PLATFORM_CLK },
> +
> +	{ }
> +};

Now that we have everything the platform support code needs in a single
file, should we instead of setting flags and comparing strings like
"INT33C" to find out are we running on Lynxpoint, pass function pointer
that gets called when corresponding device gets created? Something like:

	{ "INT33C0", lpt_clks_init },
	...

Or do you think we need to keep the flags still?

I can prepare a patch if this turns out to be sensible thing to do.

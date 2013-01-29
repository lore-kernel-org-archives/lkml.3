Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3A2L4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:56:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58502 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab3A2L40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:56:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ACPI / platform: Use struct acpi_scan_handler for creating devices
Date: Tue, 29 Jan 2013 13:02:37 +0100
Message-ID: <10318344.MgarAUWL0a@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130129080509.GK2239@intel.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1540645.4oLGJ3spZ3@vostro.rjw.lan> <20130129080509.GK2239@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 10:05:09 AM Mika Westerberg wrote:
> On Mon, Jan 28, 2013 at 02:01:14PM +0100, Rafael J. Wysocki wrote:
> > +/* Flags for acpi_create_platform_device */
> > +#define ACPI_PLATFORM_CLK	BIT(0)
> > +
> > +/*
> > + * The following ACPI IDs are known to be suitable for representing as
> > + * platform devices.
> > + */
> > +static const struct acpi_device_id acpi_platform_device_ids[] = {
> > +
> > +	{ "PNP0D40" },
> > +
> > +	/* Haswell LPSS devices */
> > +	{ "INT33C0", ACPI_PLATFORM_CLK },
> > +	{ "INT33C1", ACPI_PLATFORM_CLK },
> > +	{ "INT33C2", ACPI_PLATFORM_CLK },
> > +	{ "INT33C3", ACPI_PLATFORM_CLK },
> > +	{ "INT33C4", ACPI_PLATFORM_CLK },
> > +	{ "INT33C5", ACPI_PLATFORM_CLK },
> > +	{ "INT33C6", ACPI_PLATFORM_CLK },
> > +	{ "INT33C7", ACPI_PLATFORM_CLK },
> > +
> > +	{ }
> > +};
> 
> Now that we have everything the platform support code needs in a single
> file, should we instead of setting flags and comparing strings like
> "INT33C" to find out are we running on Lynxpoint, pass function pointer
> that gets called when corresponding device gets created? Something like:
> 
> 	{ "INT33C0", lpt_clks_init },
> 	...
> 
> Or do you think we need to keep the flags still?
> 
> I can prepare a patch if this turns out to be sensible thing to do.

Well, if we can reduce the code size this way, please send a patch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

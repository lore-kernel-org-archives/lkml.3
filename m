Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3IJLTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:19:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40645 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3IJLTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:19:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Callen <jcallen@gentoo.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Move acpi_bus_get_device() from bus.c to scan.c
Date: Tue, 10 Sep 2013 13:30:44 +0200
Message-ID: <1625559.QHokRTMI6X@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <522E978C.6040506@gentoo.org>
References: <3314440.iryh4ZRtRb@vostro.rjw.lan> <522E978C.6040506@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 09, 2013 11:52:44 PM Jonathan Callen wrote:
> On 07/27/2013 09:24 AM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com> Subject: ACPI: Move acpi_bus_get_device()
> > from bus.c to scan.c
> >
> > Move acpi_bus_get_device() from bus.c to scan.c which allows acpi_bus_data_handler() to become
> > static and clean up the latter.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com> --- drivers/acpi/bus.c      |
> > 21 --------------------- drivers/acpi/scan.c     |   30 ++++++++++++++++++++++--------
> > include/acpi/acpi_bus.h |    1 - 3 files changed, 22 insertions(+), 30 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/bus.c
> > =================================================================== ---
> > linux-pm.orig/drivers/acpi/bus.c +++ linux-pm/drivers/acpi/bus.c @@ -89,27 +89,6 @@ static
> > struct dmi_system_id dsdt_dmi_tab Device Management
> [cut]
> > - -EXPORT_SYMBOL(acpi_bus_get_device); - acpi_status acpi_bus_get_status_handle(acpi_handle
> > handle, unsigned long long *sta) { Index: linux-pm/drivers/acpi/scan.c
> > =================================================================== ---
> > linux-pm.orig/drivers/acpi/scan.c +++ linux-pm/drivers/acpi/scan.c @@ -970,6 +970,28 @@ struct
> > bus_type acpi_bus_type = { .uevent		= acpi_device_uevent, };
> >
> [cut]
> > +} +EXPORT_SYMBOL_GPL(acpi_bus_get_device); +
> 
> Was it intentional to change the EXPORT_SYMBOL to EXPORT_SYMBOL_GPL here?

Yes, it was.

> While I understand that it is completely unsupported anyway, this change does
> break at least the latest version of the proprietary nvidia graphics driver.

This commit has been in linux-next for over a month and no one has spoken
a word about this problem.  I'm not going to revert that change now, sorry.

Thanks,
Rafael


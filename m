Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3ARW7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:59:08 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44766 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARW7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <3264138.cPdAZaaUCO@vostro.rjw.lan>
References: <6681740.NxX6Su8EKC@vostro.rjw.lan>
	<CAE9FiQXU_KQfoND=rQDczB65jxKYxWpnnQT4pSW296sUscG8HA@mail.gmail.com>
	<3264138.cPdAZaaUCO@vostro.rjw.lan>
Date: Fri, 18 Jan 2013 14:59:06 -0800
X-Google-Sender-Auth: 5ERBa8HInVTcimAJckQ4NBhJk7U
Message-ID: <CAE9FiQW6+W99nqfsYokU0eVe57zLbiKYojVYNSs7Yvke8PnpRw@mail.gmail.com>
Subject: Re: [PATCH] ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan()
 instead (was: Re: [PATCH] ACPI / scan: Fold acpi_bus_scan() into acpi_bus_add())
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 1:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan() instead
>
> The only difference between acpi_bus_scan() and acpi_bus_add() is the
> invocation of acpi_update_all_gpes() in the latter which in fact is
> unnecessary, because acpi_update_all_gpes() has already been called
> by acpi_scan_init() and the way it is implemented guarantees the next
> invocations of it to do nothing.
>
> For this reason, drop acpi_bus_add() and make all its callers use
> acpi_bus_scan() directly instead of it.  Additionally, rearrange the
> code in acpi_scan_init() slightly to improve the visibility of the
> acpi_update_all_gpes() call in there.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/acpi_memhotplug.c     |    2 -
>  drivers/acpi/container.c           |    2 -
>  drivers/acpi/dock.c                |    2 -
>  drivers/acpi/processor_driver.c    |    2 -
>  drivers/acpi/scan.c                |   54 +++++++++++++++----------------------
>  drivers/pci/hotplug/acpiphp_glue.c |    4 +-
>  drivers/pci/hotplug/sgi_hotplug.c  |    4 +-
>  include/acpi/acpi_bus.h            |    2 -
>  8 files changed, 31 insertions(+), 41 deletions(-)

Acked-by: Yinghai Lu <yinghai@kernel.org>

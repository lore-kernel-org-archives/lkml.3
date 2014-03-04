Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaCDUA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:00:27 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30754 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbaCDUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:00:23 -0500
Message-ID: <1393962785.6784.110.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / hotplug: Rework deferred execution of
 acpi_device_hotplug()
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 12:53:05 -0700
In-Reply-To: <1573287.V189PcUPxA@vostro.rjw.lan>
References: <1573287.V189PcUPxA@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-01 at 20:57 +0000, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since the only function executed by acpi_hotplug_execute() is
> acpi_device_hotplug() and it only is called by the ACPI core,
> simplify its definition so that it only takes two arguments, the
> ACPI device object pointer and event code, rename it to
> acpi_hotplug_schedule() and move its header from acpi_bus.h to
> the ACPI core's internal header file internal.h.  Modify the
> definition of acpi_device_hotplug() so that its first argument is
> an ACPI device object pointer and modify the definition of
> struct acpi_hp_work accordingly.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The change looks good to me.  I wonder if acpi_hotplug_schedule() should
still be in acpi/osl.c after this change, though.

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



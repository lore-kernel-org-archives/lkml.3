Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaCEATj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:19:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51018 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754375AbaCEATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:19:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / hotplug: Rework deferred execution of acpi_device_hotplug()
Date: Wed, 05 Mar 2014 01:34:14 +0100
Message-ID: <2382825.8vXuxFofoh@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393962785.6784.110.camel@misato.fc.hp.com>
References: <1573287.V189PcUPxA@vostro.rjw.lan> <1393962785.6784.110.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 04, 2014 12:53:05 PM Toshi Kani wrote:
> On Sat, 2014-03-01 at 20:57 +0000, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Since the only function executed by acpi_hotplug_execute() is
> > acpi_device_hotplug() and it only is called by the ACPI core,
> > simplify its definition so that it only takes two arguments, the
> > ACPI device object pointer and event code, rename it to
> > acpi_hotplug_schedule() and move its header from acpi_bus.h to
> > the ACPI core's internal header file internal.h.  Modify the
> > definition of acpi_device_hotplug() so that its first argument is
> > an ACPI device object pointer and modify the definition of
> > struct acpi_hp_work accordingly.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The change looks good to me.  I wonder if acpi_hotplug_schedule() should
> still be in acpi/osl.c after this change, though.

Well, not necessarily. :-)

Still, that'd be a separate patch anyway.

> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3BGBB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:01:59 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:32114 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BGBBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:01:55 -0500
Message-ID: <1360198302.23410.283.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] ACPI / scan: Simplify container driver
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 06 Feb 2013 17:51:42 -0700
In-Reply-To: <6374398.88OyYZxaMu@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
	 <5090866.2BHgpRnuEZ@vostro.rjw.lan>
	 <1360189938.23410.276.camel@misato.fc.hp.com>
	 <6374398.88OyYZxaMu@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 01:55 +0100, Rafael J. Wysocki wrote:
> On Wednesday, February 06, 2013 03:32:18 PM Toshi Kani wrote:
> > On Mon, 2013-02-04 at 00:47 +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > The only useful thing that the ACPI container driver does is to
> > > install system notify handlers for all container and module device
> > > objects it finds in the namespace.  The driver structure,
> > > acpi_container_driver, and the data structures created by its
> > > .add() callback are in fact not used by the driver, so remove
> > > them entirely.
> > > 
> > > It also makes a little sense to build that driver as a module,
> > > so make it non-modular and add its initialization to the
> > > namespace scanning code.
> > > 
> > > In addition to that, make the namespace walk callback used for
> > > installing the notify handlers more straightforward.
> > 
> > I think the container driver needs to be registered as an ACPI scan
> > driver so that sysfs eject will continue to work for container devices,
> > such as ACPI0004:XX/eject.  Since the container driver does not support
> > ACPI eject notification (and we have been discussing how system device
> > hot-plug should work), this sysfs eject is the only way to eject a
> > container device at this point.  I will send an update patchset that
> > applies on top of this patch.
> > 
> > With the update in my patchset:
> > Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> 
> Thanks, but I'd like to (1) apply your patch from
> https://patchwork.kernel.org/patch/2108851/ first and then (2) fold your [2/2]
> into my [2/2], if you don't mind, and apply that next.

That's fine by me.

> Moreover, I'm wondering if the #ifndef FORCE_EJECT thing in acpi_eject_store()
> actually makes sense after the recent changes to acpi_bus_trim(), because that
> can't fail now, so the eject will always be carried out.  So perhaps we can
> simply remove the acpi_device->driver check from there entirely in the first
> place?
>
> If we really want to be able to prevent ejects from happening in some cases,
> we need to implement something along the lines discussed with Greg.

acpi_bus_trim() cannot fail, but sysfs eject can fail.  So, I think it
makes sense to do some validation before calling acpi_bus_trim().  If we
are to implement the no_eject flag thing, that check needs to be made
before calling acpi_bus_trim().

Thanks,
-Toshi





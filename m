Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3B1BMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:12:20 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46985 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab3B1BMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:12:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Resend][PATCH] ACPI / glue: Drop .find_bridge() callback from struct acpi_bus_type
Date: Thu, 28 Feb 2013 02:19:04 +0100
Message-ID: <2484591.Kj0StbXZkK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVEBZy+HP+tthD_C_gJ_6v2be-pGCD0A4TE0z+c8MHXtA@mail.gmail.com>
References: <2612891.I2roH54cPk@vostro.rjw.lan> <20130227222032.GA28616@kroah.com> <CAE9FiQVEBZy+HP+tthD_C_gJ_6v2be-pGCD0A4TE0z+c8MHXtA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 27, 2013 03:31:08 PM Yinghai Lu wrote:
> On Wed, Feb 27, 2013 at 2:20 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Feb 27, 2013 at 11:06:52PM +0100, Rafael J. Wysocki wrote:
> >> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> After PCI has stopped using the .find_bridge() callback in
> >> struct acpi_bus_type, the only remaining users of it are SATA and
> >> USB.  However, SATA only pretends to be a user, because it points
> >> that callback to a stub always returning -ENODEV, and USB uses it
> >> incorrectly, because as a result of the way it is used by USB every
> >> device in the system that doesn't have a bus type or parent is
> >> passed to usb_acpi_find_device() for inspection.
> >>
> >> What USB actually needs, though, is to call usb_acpi_find_device()
> >> for USB ports that don't have a bus type defined, but have
> >> usb_port_device_type as their device type.
> >
> > Ick, that's not good.  Can you have the original creator of that code
> > (someone else from Intel, I can't remember at the moment), fix that up
> > properly and send me patches?
> 
> [Add To: Lan Tianyu <tianyu.lan@intel.com>]
> 
> >
> >> Please let me know if there are any objections.
> 
> I still prefer to ask USB to add bus_type instead at first.

IIRC, You want USB to register an *additional* ACPI bus type for
usb_port_device_type, which quite frankly will be very confusing and I don't
see any actual benefits from doing that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

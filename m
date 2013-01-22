Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3AVV55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:57:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50665 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab3AVV5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:57:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] ACPI: Remove useless type argument of driver .remove() operation
Date: Tue, 22 Jan 2013 23:03:51 +0100
Message-ID: <4046863.eHD8RPonGC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQV1N0hrUui1rGrs1=kFJFiuOhZ6tT-wGfK-B25it5feLQ@mail.gmail.com>
References: <1518653.CUpDmbmCI3@vostro.rjw.lan> <6850002.DtnUIhsRE7@vostro.rjw.lan> <CAE9FiQV1N0hrUui1rGrs1=kFJFiuOhZ6tT-wGfK-B25it5feLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 01:54:47 PM Yinghai Lu wrote:
> On Sun, Jan 20, 2013 at 2:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, January 20, 2013 11:04:47 PM Rafael J. Wysocki wrote:
> >> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> The second argument of ACPI driver .remove() operation is only used
> >> by the ACPI processor driver and the value passed to that driver
> >> through it is always available from the given struct acpi_device
> >> object's removal_type field.  For this reason, the second ACPI driver
> >> .remove() argument is in fact useless, so drop it.
> >>
> >> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Forgot to say: This is on top of the linux-next branch of the linux-pm.git tree.
> >
> > Thanks,
> > Rafael
> >
> >
> >> ---
> >>  drivers/acpi/ac.c                        |    4 ++--
> >>  drivers/acpi/acpi_memhotplug.c           |    4 ++--
> >>  drivers/acpi/acpi_pad.c                  |    3 +--
> >>  drivers/acpi/battery.c                   |    2 +-
> >>  drivers/acpi/button.c                    |    4 ++--
> >>  drivers/acpi/container.c                 |    4 ++--
> >>  drivers/acpi/ec.c                        |    2 +-
> >>  drivers/acpi/fan.c                       |    4 ++--
> >>  drivers/acpi/hed.c                       |    2 +-
> >>  drivers/acpi/pci_link.c                  |    4 ++--
> >>  drivers/acpi/pci_root.c                  |    4 ++--
> >>  drivers/acpi/processor_driver.c          |    6 +++---
> >>  drivers/acpi/sbs.c                       |    6 +++---
> >>  drivers/acpi/sbshc.c                     |    4 ++--
> >>  drivers/acpi/scan.c                      |    5 ++---
> >>  drivers/acpi/thermal.c                   |    4 ++--
> >>  drivers/acpi/video.c                     |    4 ++--
> >>  drivers/char/hpet.c                      |    2 +-
> >>  drivers/char/sonypi.c                    |    2 +-
> >>  drivers/hwmon/acpi_power_meter.c         |    2 +-
> >>  drivers/hwmon/asus_atk0110.c             |    4 ++--
> >>  drivers/i2c/busses/i2c-scmi.c            |    2 +-
> >>  drivers/input/misc/atlas_btns.c          |    2 +-
> >>  drivers/platform/x86/asus-laptop.c       |    2 +-
> >>  drivers/platform/x86/classmate-laptop.c  |    8 ++++----
> >>  drivers/platform/x86/eeepc-laptop.c      |    2 +-
> >>  drivers/platform/x86/fujitsu-laptop.c    |    4 ++--
> >>  drivers/platform/x86/fujitsu-tablet.c    |    2 +-
> >>  drivers/platform/x86/hp_accel.c          |    2 +-
> >>  drivers/platform/x86/ideapad-laptop.c    |    2 +-
> >>  drivers/platform/x86/intel_menlow.c      |    2 +-
> >>  drivers/platform/x86/panasonic-laptop.c  |    4 ++--
> >>  drivers/platform/x86/sony-laptop.c       |    4 ++--
> >>  drivers/platform/x86/topstar-laptop.c    |    2 +-
> >>  drivers/platform/x86/toshiba_acpi.c      |    4 ++--
> >>  drivers/platform/x86/toshiba_bluetooth.c |    4 ++--
> >>  drivers/platform/x86/wmi.c               |    4 ++--
> >>  drivers/platform/x86/xo15-ebook.c        |    2 +-
> >>  drivers/staging/quickstart/quickstart.c  |    2 +-
> >>  drivers/video/backlight/apple_bl.c       |    2 +-
> >>  drivers/xen/xen-acpi-pad.c               |    3 +--
> >>  include/acpi/acpi_bus.h                  |    2 +-
> >>  42 files changed, 67 insertions(+), 70 deletions(-)
> >>
> >> Index: linux-pm/include/acpi/acpi_bus.h
> >> ===================================================================
> >> --- linux-pm.orig/include/acpi/acpi_bus.h
> >> +++ linux-pm/include/acpi/acpi_bus.h
> >> @@ -89,7 +89,7 @@ struct acpi_device;
> >>   */
> >>
> >>  typedef int (*acpi_op_add) (struct acpi_device * device);
> >> -typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
> >> +typedef int (*acpi_op_remove) (struct acpi_device * device);
> >>  typedef int (*acpi_op_start) (struct acpi_device * device);
> >>  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks!

> Also can you remove acpi_op_start ? there is no user with it.

Sure, I will.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

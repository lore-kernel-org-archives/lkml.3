Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3BWLtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 06:49:32 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33290 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3BWLt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 06:49:26 -0500
Date: Sat, 23 Feb 2013 12:49:14 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130223114914.GA1786@balto.lan>
References: <20130222085954.GA4352@redhat.com>
 <8156425.nbPzS18WCu@vostro.rjw.lan>
 <20130223014427.GA1709@balto.lan>
 <1522889.3cbJt7lHsB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1522889.3cbJt7lHsB@vostro.rjw.lan>
X-Operating-System: Linux balto 3.8.0-06472-g10d350f x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Sat, Feb 23, 2013 at 05:33:39AM +0100, Rafael J. Wysocki wrote:
> On Saturday, February 23, 2013 02:44:27 AM Fabio Baltieri wrote:
> > On Sat, Feb 23, 2013 at 01:35:26AM +0100, Rafael J. Wysocki wrote:
> > > The new sysfs interface for power resources control may be helpful here.  You
> > > need to use the Linus' current for it to work, though.
> > > 
> > > Can you please do
> > > 
> > > $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> > > $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> > > $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> > > $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> > > and send the output?
> > 
> > With the acpi_add_power_resource disabled all power_state read "D0",
> > other attributes are not generated.
> 
> Yup.  That's how it should be.
> 
> > With a plain kernel that's the output:
> > 
> > $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/LNXVIDEO:01/power_state
> > D0
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_state
> > D0
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_state
> > D0
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_state
> > D0
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/power_state
> > D0
> > 
> > $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/real_power_state
> > D3cold
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/real_power_state
> > D3cold
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/real_power_state
> > D3cold
> 
> This is obviously wrong.  We expect the devices to be in D0, while they really
> are in D3cold.  Let's look deeper.
> 
> > $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D0
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D1
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D2
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D0
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D1
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D2
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D0
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D1
> > LNXPOWER:00
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D2
> > LNXPOWER:00
> 
> PNP0A08 is the PCI root bridge and device:29, device:34, device:1f are the USB
> controllers.  All of them have ACPI power states D0, D1, D2 and D3cold, where
> D0-D2 depend on the same power resource, so in fact they all are the same state
> (what sense does this make?).
> 
> I suspect that the power resource being shared (and it being shared in such a
> broken way) has to do something with the breakage.
> 
> > $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/PNP0C09:00/LNXPOWER:00/resource_in_use
> > 0
> 
> There's one power resource in the system and it's usage count is 0, so it is
> "off" (which is consistent with the real power states of the USB controllers).
> 
> Now, the boot log shows that the power resource was "on" when it was found,
> so the initial states of the USB controllers should have been D0.

Sounds reasonable, I see that the ports are active until the kernel
starts.

> However, the DSDT source shows that the very same power resource that the D0-D2
> power states of the devices depend on is listed for them as a wakeup power
> resource by _PRW.  [Is that even valid?  It doesn't seem to make sense anyway.]
> Thus when pci_acpi_setup() does acpi_pci_sleep_wake(pci_dev, false), which
> calls acpi_pm_device_sleep_wake(&dev->dev, false), eventually
> acpi_disable_wakeup_device_power() will be called for the device.  This leads
> to calling acpi_power_off_list() for wakeup resources and that list includes
> our single power resource, so its refcount will be dropped and it will be
> turned off silently without updating the current power state of the device.
> 
> So first, the commit that broke things for you was probably
> d2e5f0c (ACPI / PCI: Rework the setup and cleanup of device wakeup) which moved
> the wakeup initialization, but didn't show up in the bisection, because the
> power resources handling didn't work at that point.  And if I'm not mistaken,
> it only broke things because we've never assumed that a wakeup power resource
> may be the same as a power resource the device's power states depend on (which
> we should).
> 
> Now, how to fix this is an interesting problem.
> 
> After some consideration I got the appended patch, but I'm really tired now
> and couldn't really test it, so caveat emptor.  I'll look at it once again
> tomorrow and see if it still makes sense to me then.
[snip]
> ---
>  drivers/acpi/internal.h |    2 
>  drivers/acpi/power.c    |  106 ++++++++++++++++++++++++++++++++++++------------
>  drivers/acpi/scan.c     |    2 
>  3 files changed, 82 insertions(+), 28 deletions(-)

Well, this works fine on my system.  The power is back and from sysfs I
got all three real_power_state to D0 and resource_in_use to 1.

Anything else I should check?

I'll re-test again when you submit the patch formally!

Thanks,
Fabio

-- 
Fabio Baltieri

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaBLNtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:49:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63874 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751129AbaBLNts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:49:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Peter Wu <lekensteyn@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Wed, 12 Feb 2014 15:04:28 +0100
Message-ID: <1717405.VfecqV3UgO@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <52FB264D.30809@gmail.com>
References: <52F2CC7B.80406@gmail.com> <1835578.EmLUpvTMQe@vostro.rjw.lan> <52FB264D.30809@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 12, 2014 08:44:13 AM Francis Moreau wrote:
> On 02/12/2014 12:58 AM, Rafael J. Wysocki wrote:
> > On Tuesday, February 11, 2014 07:17:37 PM Peter Wu wrote:
> >> On Tuesday 11 February 2014 12:42:37 Mika Westerberg wrote:
> >>> On Mon, Feb 10, 2014 at 11:39:29PM +0100, Rafael J. Wysocki wrote:
> >>>>> _STA() returns 0x0A instead of 0x0F. Could there be something missing in
> >>>>> the ACPI hotplug code that overlooks this and removes the device on
> >>>>> resume?
> >>>>
> >>>> That is possible.  Actually even quite likely, but let's wait for the
> >>>> response from Peter.
> >>>
> >>> Here's a hack that should take the 0xa return value into consideration. It
> >>> turned out that this case is even mentioned in the ACPI spec.
> >>
> >> Tested-by: Peter Wu <lekensteyn@gmail.com>
> >>
> >> This works, the devices are not lost anymore after resume. dmesg
> >> mentions the 04:00.* devices at resume compared to the unpatched kernel:
> >>
> >> [   42.650721] PM: Finishing wakeup.
> >> [   42.650768] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
> >> [   42.650772] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
> >> [   42.650874] iwlwifi 0000:05:00.0: no hotplug settings from platform
> >> [   42.650722] Restarting tasks ... done.
> >> [   42.650985] video LNXVIDEO:00: Restoring backlight state
> >> [   42.650988] video LNXVIDEO:01: Restoring backlight state
> >> [   43.124208] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
> >> [   43.128401] jme 0000:04:00.5: irq 50 for MSI/MSI-X
> >> [   43.153005] jme 0000:04:00.5 eth0: Link is down
> >> [   43.153030] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> >> [   43.154364] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
> >> [   43.162307] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
> >> [   43.276220] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP01
> >> [   43.276223] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP01
> >> [   43.276257] xhci_hcd 0000:02:00.0: no hotplug settings from platform
> >> [   43.276267] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP02
> >> [   43.276268] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP02
> >> [   43.276355] sdhci-pci 0000:04:00.0: no hotplug settings from platform
> >> [   43.276368] pci 0000:04:00.2: no hotplug settings from platform
> >> [   43.276381] jmb38x_ms 0000:04:00.3: no hotplug settings from platform
> >> [   43.276393] jme 0000:04:00.5: no hotplug settings from platform
> >> [   43.276398] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
> >> [   43.276399] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
> >> [   43.276491] iwlwifi 0000:05:00.0: no hotplug settings from platform
> >> [   43.277214] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >>
> >> Rafael, do you want me to test the other patch as well?
> > 
> > No, thanks!
> > 
> > Mika, I'll add a changelog to your patch and queue it up as a fix for 3.14.
> > 
> 
> Thanks guys for solving this issue !
> 
> Rafael, could this be submitted to stable trees (at least 3.12, 3.13) as
> well ?

Yes, I have marked it for stable.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

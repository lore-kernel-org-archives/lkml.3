Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaICLfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:35:44 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35444 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaICLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:35:41 -0400
Date: Wed, 3 Sep 2014 12:35:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Message-ID: <20140903113535.GE28985@lee--X1>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com>
 <20140903074315.GB28985@lee--X1>
 <5406E9B0.101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5406E9B0.101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014, Prarit Bhargava wrote:
> On 09/03/2014 03:43 AM, Lee Jones wrote:
> > [PATCH] x86, lpc, Allow only one load of lpc_ich
> > 
> > Please use $SUBJECT format corresponding to the subsystem.
> > 
> > This is not an X86 patch, it's an MFD one.
> > 
> > I would expecte to see something along the lines of:
> > 
> >   mfd: lpc_ich: Prevent LCP devices from probing twice
> 
> Sure, okay ... I was unsure as this relates only to x86 IIUC.

It doesn't matter if the driver is pinned to a particular
architecture, your patch is fixing an MFD driver which resides only in
the MFD subsystem, thus it is an MFD patch.

> > On Tue, 02 Sep 2014, Prarit Bhargava wrote:
> >> On multi-socket systems the following confusing splats are seen:
> >>
> >>  ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> >>  lpc_ich: Resource conflict(s) found affecting gpio_ich
> >>  ------------[ cut here ]------------
> >>  WARNING: CPU: 7 PID: 1813 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
> >>  sysfs: cannot create duplicate filename '/bus/platform/devices/iTCO_wdt'
> > 
> > All this from here
> > 
> > ------------------8<--------------------
> > 
> >>  Modules linked in: lpc_ich(+) crc32c_intel shpchp mfd_core acpi_cpufreq i2c_i801 dca xfs libcrc32c sd_mod crc_t10dif crct10dif_common ata_generic pata_acpi mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm mptsas drm scsi_transport_sas ata_piix mptscsih i2ccore libata mptbase dm_mirror dm_region_hash dm_log dm_mod
> >>  CPU: 7 PID: 1813 Comm: systemd-udevd Not tainted 3.17.0-rc3+ #1
> >>  Hardware name: IBM System x3950 M3 -[7145AC1]-/Node 1, Processor Card, BIOS -[G0E130WUS-1.31]- 07/23/2010
> >>   0000000000000000 00000000f205abcf ffff88066bb7b8d0 ffffffff81647056
> >>   ffff88066bb7b918 ffff88066bb7b908 ffffffff81072c9d ffff880273d05000
> >>   ffff88027349d110 ffff880874c5cc30 0000000000000001 ffffffffffffffef
> >>  Call Trace:
> >>   [<ffffffff81647056>] dump_stack+0x45/0x56
> >>   [<ffffffff81072c9d>] warn_slowpath_common+0x7d/0xa0
> >>   [<ffffffff81072d1c>] warn_slowpath_fmt+0x5c/0x80
> >>   [<ffffffff81256598>] ? kernfs_path+0x48/0x60
> >>   [<ffffffff81259e34>] sysfs_warn_dup+0x64/0x80
> >>   [<ffffffff8125a1b1>] sysfs_do_create_link_sd.isra.2+0xc1/0xd0
> >>   [<ffffffff8125a1e5>] sysfs_create_link+0x25/0x50
> >>   [<ffffffff81401689>] bus_add_device+0x119/0x200
> >>   [<ffffffff813ff4b8>] device_add+0x498/0x630
> >>   [<ffffffff810778f6>] ? __insert_resource+0x26/0x150
> >>   [<ffffffff81404391>] platform_device_add+0xd1/0x2d0
> >>   [<ffffffffa050b3f5>] mfd_add_device+0x285/0x320 [mfd_core]
> >>   [<ffffffffa050b705>] mfd_add_devices+0xb5/0x9b0 [mfd_core]
> >>   [<ffffffffa0abf55b>] lpc_ich_probe+0x3cb/0x600 [lpc_ich]
> >>   [<ffffffff8132eb55>] local_pci_probe+0x45/0xa0
> >>   [<ffffffff8132fd45>] ? pci_match_device+0xe5/0x110
> >>   [<ffffffff8132fea9>] pci_device_probe+0xf9/0x150
> >>   [<ffffffff814024b0>] driver_probe_device+0x90/0x3c0
> >>   [<ffffffff814028b3>] __driver_attach+0x93/0xa0
> >>   [<ffffffff81402820>] ? __device_attach+0x40/0x40
> >>   [<ffffffff814003f3>] bus_for_each_dev+0x73/0xc0
> >>   [<ffffffff81401f4e>] driver_attach+0x1e/0x20
> >>   [<ffffffff81401b30>] bus_add_driver+0x180/0x250
> >>   [<ffffffffa0acb000>] ? 0xffffffffa0acb000
> >>   [<ffffffff81403094>] driver_register+0x64/0xf0
> >>   [<ffffffff8132e4ec>] __pci_register_driver+0x4c/0x50
> >>   [<ffffffffa0acb01e>] lpc_ich_driver_init+0x1e/0x1000 [lpc_ich]
> >>   [<ffffffff81002144>] do_one_initcall+0xd4/0x210
> >>   [<ffffffff811c2fed>] ? kfree+0xfd/0x140
> >>   [<ffffffff811a8b42>] ? __vunmap+0xb2/0x100
> >>   [<ffffffff810f2839>] load_module+0x1619/0x1a70
> >>   [<ffffffff810edde0>] ? store_uevent+0x70/0x70
> >>   [<ffffffff810eea39>] ? copy_module_from_fd.isra.44+0x129/0x180
> >>   [<ffffffff810f2e46>] SyS_finit_module+0xa6/0xd0
> >>   [<ffffffff8164f069>] system_call_fastpath+0x16/0x1b
> >>  ---[ end trace 1429eb73c1995841 ]---
> >>  ------------[ cut here ]------------
> > 
> > ------------------8<--------------------
> > 
> > To here.
> > 
> >>  WARNING: CPU: 71 PID: 1813 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
> >>  sysfs: cannot create duplicate filename '/bus/platform/devices/gpio_ich'
> > 
> > And from here:
> > 
> > ------------------8<--------------------
> > 
> >>  Modules linked in: serio_raw lpc_ich(+) crc32c_intel shpchp mfd_core acpi_cpufreq i2c_i801 dca xfs libcrc32c sd_mod crc_t10dif crct10dif_common ata_generic pata_acpi mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm mptsas drm scsi_transport_sas ata_piix mptscsih i2ccore libata mptbase dm_mirror dm_region_hash dm_log dm_mod
> >>  CPU: 71 PID: 1813 Comm: systemd-udevd Tainted: G        W      3.17.0-rc3+ #1
> >>  Hardware name: IBM System x3950 M3 -[7145AC1]-/Node 1, Processor Card, BIOS -[G0E130WUS-1.31]- 07/23/2010
> >>   0000000000000000 00000000f205abcf ffff88066bb7b8d0 ffffffff81647056
> >>   ffff88066bb7b918 ffff88066bb7b908 ffffffff81072c9d ffff88027382d000
> >>   ffff880273640030 ffff880874c5cc30 0000000000000001 ffffffffffffffef
> >>  Call Trace:
> >>   [<ffffffff81647056>] dump_stack+0x45/0x56
> >>   [<ffffffff81072c9d>] warn_slowpath_common+0x7d/0xa0
> >>   [<ffffffff81072d1c>] warn_slowpath_fmt+0x5c/0x80
> >>   [<ffffffff81256598>] ? kernfs_path+0x48/0x60
> >>   [<ffffffff81259e34>] sysfs_warn_dup+0x64/0x80
> >>   [<ffffffff8125a1b1>] sysfs_do_create_link_sd.isra.2+0xc1/0xd0
> >>   [<ffffffff8125a1e5>] sysfs_create_link+0x25/0x50
> >>   [<ffffffff81401689>] bus_add_device+0x119/0x200
> >>   [<ffffffff813ff4b8>] device_add+0x498/0x630
> >>   [<ffffffff810778f6>] ? __insert_resource+0x26/0x150
> >>   [<ffffffff81404391>] platform_device_add+0xd1/0x2d0
> >>   [<ffffffffa050b3f5>] mfd_add_device+0x285/0x320 [mfd_core]
> >>   [<ffffffffa050b705>] mfd_add_devices+0xb5/0x9b0 [mfd_core]
> >>   [<ffffffffa0abf464>] lpc_ich_probe+0x2d4/0x600 [lpc_ich]
> >>   [<ffffffff8132eb55>] local_pci_probe+0x45/0xa0
> >>   [<ffffffff8132fd45>] ? pci_match_device+0xe5/0x110
> >>   [<ffffffff8132fea9>] pci_device_probe+0xf9/0x150
> >>   [<ffffffff814024b0>] driver_probe_device+0x90/0x3c0
> >>   [<ffffffff814028b3>] __driver_attach+0x93/0xa0
> >>   [<ffffffff81402820>] ? __device_attach+0x40/0x40
> >>   [<ffffffff814003f3>] bus_for_each_dev+0x73/0xc0
> >>   [<ffffffff81401f4e>] driver_attach+0x1e/0x20
> >>   [<ffffffff81401b30>] bus_add_driver+0x180/0x250
> >>   [<ffffffffa0acb000>] ? 0xffffffffa0acb000
> >>   [<ffffffff81403094>] driver_register+0x64/0xf0
> >>   [<ffffffff8132e4ec>] __pci_register_driver+0x4c/0x50
> >>   [<ffffffffa0acb01e>] lpc_ich_driver_init+0x1e/0x1000 [lpc_ich]
> >>   [<ffffffff81002144>] do_one_initcall+0xd4/0x210
> >>   [<ffffffff811c2fed>] ? kfree+0xfd/0x140
> >>   [<ffffffff811a8b42>] ? __vunmap+0xb2/0x100
> >>   [<ffffffff810f2839>] load_module+0x1619/0x1a70
> >>   [<ffffffff810edde0>] ? store_uevent+0x70/0x70
> >>   [<ffffffff810eea39>] ? copy_module_from_fd.isra.44+0x129/0x180
> >>   [<ffffffff810f2e46>] SyS_finit_module+0xa6/0xd0
> >>   [<ffffffff8164f069>] system_call_fastpath+0x16/0x1b
> >>  ---[ end trace 1429eb73c1995842 ]---
> >>  lpc_ich 0000:80:1f.0: No MFD cells added
> > 
> > ------------------8<--------------------
> > 
> > To here - should be removed from the commit log.
> 
> No, that's not the right thing to do.  A lot of other commit log messages
> contain backtraces.  If I do it your way we lose the log of exactly what the bug
> was and how it appeared.
> 
> See recent commits 39b5552cd5090d4c210d278cd2732f493075f033, and
> 5e3c516b512c0f8f18359413b04918f6347f67e7 for examples.

I don't want this kind depth of information in the commit log for such
a simple bug - most of it is useless cruft.  I can understand if the
stack-trace was unusual or would aid in debugging, but providing full
back-trace comprising mostly of a standard driver bind is not helpful
and its over-complicated nature actually detracts from the issue.
Keep it succinct.  The driver was bound twice and some mechanisms
which are designed to only run once were repeated causing a warning.

> >> This occurs because there are two LPC devices on the system:
> >>
> >> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Controller
> >> 80:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Controller
> >>
> >> which AFAICT is a hardware configuration error that can be resolved in
> >> firmware by hiding the second LPC device.  Having two of these results in
> >> two GPIO mappings and two Watchdog Timers which doesn't make much sense.
> >>
> >> An end user has no idea what the splats mean.  We should inform the user that
> >> the issue lies with the hardware and that they should contact their vendor
> >> for resolution.
> > 
> > Why is it a problem for 2 of these devices to exist on a single system?
> > 
> > Shouldn't the driver just be able to handle 2 devices?
> > 
> 
> You end up with two watchdogs on the same system (and more confusingly they use
> the same global interface).  Additionally you end up with two sets of GPIOs
> which also use the same global interface ... not good.

I understand the problem with the _driver_, but why is it a problem
that two of these _devices_ exist on one system?  Bailing out of the
second .probe() sounds hacky to me.  The driver should know that this
is possible and act accordingly, or the second devices shouldn't be
registered.

Can these devices be controlled seperately?  Perhaps some more
background on what these devices to and how they are used might help
to lift the fog a little.

> I asked Intel about this
> earlier and they said it was an error on FW/HW; a suggestion was made that the
> vendor hide the second devices in FW.

Well until they do that we have to handle these cases gracefully.
Once I get a handle on what's really going on here, I can help to
suggest something a little less hacky.

> >> After the patch, the following warning is displayed:
> >>
> >>  lpc_ich 0000:80:1f.0: [Firmware Bug]: This system has two LPC devices.  Additional driver loads would result in multiple GPIO and Watchdog Devices being initialized.  Please report this problem to your hardware vendor.
> > 
> > Your commit log goes way over 72 chars here.
> 
> For *years* we haven't conformed to this style requirement.  Please don't do it
> here.

Who's we?

Please read and adhere to Documentation/SubmittingPatches:

"For these reasons, the "summary" must be no more than 70-75
 characters, and it must describe both what the patch changes, as well
 as why the patch might be necessary.  It is challenging to be both
 succinct and descriptive, but that is what a well-written summary
 should do."

... failure to do so will result in non-acceptance of your patch.

> >> Cc: Peter Tyser <ptyser@xes-inc.com>
> >> Cc: Samuel Ortiz <sameo@linux.intel.com>
> >> Cc: Lee Jones <lee.jones@linaro.org>
> >> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> >> ---
> >>  drivers/mfd/lpc_ich.c |    7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> >> index 7d8482f..eba66bc 100644
> >> --- a/drivers/mfd/lpc_ich.c
> >> +++ b/drivers/mfd/lpc_ich.c
> >> @@ -998,12 +998,17 @@ wdt_done:
> >>  	return ret;
> >>  }
> >>  
> >> +static bool cell_added;
> > 
> > Why have you globalised this?
> > 
> 
> See below.
> 
> >>  static int lpc_ich_probe(struct pci_dev *dev,
> >>  				const struct pci_device_id *id)
> >>  {
> >>  	struct lpc_ich_priv *priv;
> >>  	int ret;
> >> -	bool cell_added = false;
> 
> I thought about making this a 'static bool' here, but that violates CodingStyle
> IIUC.  Admittedly I've seen some exceptions over the years about the declaration
> of statics within functions so maybe this is one of them.  I'll leave it up to
> the maintainer to make a decision.

Can you show me where this violation is documented please?

> Peter -- any objection to making this a static here?
> 
> >> +
> >> +	if (cell_added) {
> >> +		dev_warn(&dev->dev, FW_BUG "This system has two LPC devices.  Additional driver loads would result in multiple GPIO and Watchdog Devices being initialized.  Please report this problem to your hardware vendor.\n");
> > 
> > Did you run this patch through checkpatch.pl?
> 
> Yes, and output messages are okay as we search for these in the code.  Breaks
> result in not finding error messages easily.

This is true, split lines will also not be accepted.  That's why you
have to split the line and display it on separate lines in the
bootlog.  However, I am having trouble with this print anyway.  I'd
prefer to get this fixed properly.  Worrying users and getting them to
call Intel/PC World/Fry's for help whenever this happens sounds like
the wrong thing to do.

> >> +		return -EBUSY;
> > 
> > You print a warning, but return an error here.  One of them is wrong.
> > 
> 
> I suppose dev_bug() might be more appropriate, but bug implies an absolute
> failure of the driver which hasn't happened here.  The first device has loaded
> the driver.

No, if you are returning an error, you should use dev_err().

> > But why is it a problem for two of these devices to exist anyway?
> > 
> 
> The big issue is that we initialize two iTCO_wdt's and two sets of GPIOs -- the
> system should only have one o/w we'll end up in a bizarre state of two watchdog
> timers and GPIOs.

That's fine, we can make checks to see if these have already been
registered.  But what I'm confused about is; if there are two devices
that exist on one platform why can't they exist as separate entities,
with their own resources and act independently from one another?

> I asked Intel about this previously and they said that it is
> not expected that two exist on the same platform.

Then why do they?

> >> +	}
> >>  
> >>  	priv = devm_kzalloc(&dev->dev,
> >>  			    sizeof(struct lpc_ich_priv), GFP_KERNEL);
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3J3LJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:09:07 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:49664 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3J3LJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:09:03 -0400
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v3)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <526DB557.70207@gmail.com>
References: <20131024100942.GA13614@kroah.com>
	 <1382695784-10127-2-git-send-email-haver@linux.vnet.ibm.com>
	 <526DB557.70207@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 30 Oct 2013 12:08:52 +0100
Message-ID: <1383131332.16560.96.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103011-0542-0000-0000-000006E847D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

thanks for reviewing our code and your proposals how to improve it. I
just resent a new version out in a new mail-thread: Generic WorkQueue
Engine (GenWQE) device driver (v4).

Am Montag, den 28.10.2013, 11:52 +1100 schrieb Ryan Mallon:
> On 25/10/13 21:09, Frank Haverkamp wrote:
> > From: Frank Haverkamp <haver@vnet.ibm.com>
> 
> Hi Frank,
> 
> I don't know the hardware, so I won't comment on the design etc, but a
> few comments inline on things that checkpatch might not necessarily catch.
> 
> I would really consider breaking this up into a series of patches, I
> didn't make it the whole way through this.
> 
> ~Ryan
> 
> > The GenWQE card itself provides access to a generic work queue into
> > which the work can be put, which should be executed, e.g. compression
> > or decompression request, or whatever the card was configured to do.
> > 
> > Each request comes with a set of input data (ASV) and will produce some
> > output data (ASIV). The request will also contain a sequence number,
> > some timestamps and a command code/subcode plus some fields for hardware-/
> > software-interaction.
> > 
> > A request can contain references to blocks of memory. Since the card
> > requires DMA-addresses of that memory, the driver provides two ways to
> > solve that task:
> >   1) The drivers mmap() will allocate some DMAable memory for the user.
> >      The driver has a lookup table such that the virtual userspace
> >      address can properly be replaced and checked.
> >   2) The user allocates memory and the driver will pin/unpin that
> >      memory and setup a scatter gatherlist with matching DMA addresses.
> > 
> > Currently work requests are synchronous.
> > 
> > The genwqe driver has a user-space interface described in
> > linux/include/genwqe/genwqe_card.h. There are several ioctls which can
> > be used to talk to the driver. In addition there are some sysfs
> > entries where information can be exchanged with user-space. The sysfs
> > interface is described in
> > Documentation/ABI/testing/sysfs-driver-genwqe.
> > 
> > Signed-off-by: Frank Haverkamp <haver@vnet.ibm.com>
> > Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
> >             Michael Jung <MIJUNG@de.ibm.com>,
> >             Michael Ruettger <michael@ibmra.de>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-genwqe |  108 ++
> >  drivers/misc/Kconfig                          |    1 +
> >  drivers/misc/Makefile                         |    1 +
> >  drivers/misc/genwqe/Kconfig                   |   23 +
> >  drivers/misc/genwqe/Makefile                  |    8 +
> >  drivers/misc/genwqe/card_base.c               | 1305 ++++++++++++++++++++
> >  drivers/misc/genwqe/card_base.h               |  515 ++++++++
> >  drivers/misc/genwqe/card_ddcb.c               | 1377 +++++++++++++++++++++
> >  drivers/misc/genwqe/card_ddcb.h               |  159 +++
> >  drivers/misc/genwqe/card_dev.c                | 1614 +++++++++++++++++++++++++
> >  drivers/misc/genwqe/card_sysfs.c              |  645 ++++++++++
> >  drivers/misc/genwqe/card_utils.c              | 1032 ++++++++++++++++
> >  drivers/misc/genwqe/genwqe_driver.h           |   83 ++
> >  include/linux/genwqe/genwqe_card.h            |  697 +++++++++++
> >  14 files changed, 7568 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
> >  create mode 100644 drivers/misc/genwqe/Kconfig
> >  create mode 100644 drivers/misc/genwqe/Makefile
> >  create mode 100644 drivers/misc/genwqe/card_base.c
> >  create mode 100644 drivers/misc/genwqe/card_base.h
> >  create mode 100644 drivers/misc/genwqe/card_ddcb.c
> >  create mode 100644 drivers/misc/genwqe/card_ddcb.h
> >  create mode 100644 drivers/misc/genwqe/card_dev.c
> >  create mode 100644 drivers/misc/genwqe/card_sysfs.c
> >  create mode 100644 drivers/misc/genwqe/card_utils.c
> >  create mode 100644 drivers/misc/genwqe/genwqe_driver.h
> >  create mode 100644 include/linux/genwqe/genwqe_card.h
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
> > new file mode 100644
> > index 0000000..d1dab10
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-driver-genwqe
> > @@ -0,0 +1,108 @@
> > +What:           /sys/class/genwqe/genwqe<n>_card/version
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Unique bitstream identification e.g.
> > +                '0000000330336283.00000000475a4950'
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/appid
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Identifies the currently active card application e.g. 'GZIP'
> > +                for compression/decompression.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/type
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Type of the card e.g. 'GenWQE5-A7'.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/cpld_version
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Version id of the cards CPLD.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/curr_bitstream
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Currently active bitstream. 1 is default, 0 is backup.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/next_bitstream
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to set the next bitstream to be used.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/curr_fault
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Dump of the current error registers.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/prev_fault
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Dump of the error registers before the last reset of
> > +                the card occured.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/ddcb_info
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    DDCB queue dump used for debugging queueing problems.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/err_inject
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Possibility to inject error cases to ensure that the drivers
> > +                error handling code works well.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/info
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Comprehensive summary of bitstream version and software
> > +                version. Used bitstream and bitstream clocking information.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/tempsens
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to read the cards temperature sense register.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/ledcontrol
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to write to the cards LED control register.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/pf_jobtimer
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to adjust the job timeout register of the physical
> > +                function.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/vf<0..14>_jobtimer
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to adjust the job timeout register of the virtual
> > +                function.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/pf_jobtimer
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to adjust the job timeout register of the physical
> > +                function.
> > +
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/state
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    State of the card: "unused", "used", "error".
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 8dacd4c..92142cf 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -537,4 +537,5 @@ source "drivers/misc/carma/Kconfig"
> >  source "drivers/misc/altera-stapl/Kconfig"
> >  source "drivers/misc/mei/Kconfig"
> >  source "drivers/misc/vmw_vmci/Kconfig"
> > +source "drivers/misc/genwqe/Kconfig"
> >  endmenu
> > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > index c235d5b..62a3dfb 100644
> > --- a/drivers/misc/Makefile
> > +++ b/drivers/misc/Makefile
> > @@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
> >  obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
> >  obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
> >  obj-$(CONFIG_SRAM)		+= sram.o
> > +obj-$(CONFIG_GENWQE)		+= genwqe/
> > diff --git a/drivers/misc/genwqe/Kconfig b/drivers/misc/genwqe/Kconfig
> > new file mode 100644
> > index 0000000..bbf137d
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/Kconfig
> > @@ -0,0 +1,23 @@
> > +#
> > +# IBM Accelerator Family 'GenWQE'
> > +#
> > +
> > +menuconfig GENWQE
> > +	tristate "GenWQE PCIe Accelerator"
> > +	depends on PCI && 64BIT
> > +	select CRC_ITU_T
> > +	default n
> > +	help
> > +	  Enables PCIe card driver for IBM GenWQE accelerators.
> > +          The user-space interface is described in
> > +          include/linux/genwqe/genwqe_card.h.
> > +
> > +if GENWQE
> > +
> > +config GENWQE_DEVNAME
> > +        string "Name for sysfs and device nodes"
> > +	default "genwqe"
> > +        help
> > +          Select alternate name for sysfs and device nodes.
> > +
> > +endif
> > diff --git a/drivers/misc/genwqe/Makefile b/drivers/misc/genwqe/Makefile
> > new file mode 100644
> > index 0000000..880f3f4
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/Makefile
> > @@ -0,0 +1,8 @@
> > +#
> > +# Makefile for GenWQE driver
> > +#
> > +
> > +# card driver
> > +obj-$(CONFIG_GENWQE) := genwqe_card.o
> > +genwqe_card-objs := card_base.o card_dev.o card_ddcb.o card_sysfs.o \
> > +	card_utils.o
> > diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
> > new file mode 100644
> > index 0000000..0aac769
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/card_base.c
> > @@ -0,0 +1,1305 @@
> > +/**
> > + * IBM Accelerator Family 'GenWQE'
> > + *
> > + * (C) Copyright IBM Corp. 2013
> > + *
> > + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> > + * Author: Michael Jung <mijung@de.ibm.com>
> > + * Author: Michael Ruettger <michael@ibmra.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2, or (at your option)
> > + * any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +/**
> > + * Module initialization and PCIe setup. Card health monitoring and
> > + * recovery functionality. Character device creation and deletion are
> > + * controlled from here.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/types.h>
> > +#include <linux/pci.h>
> > +#include <linux/aer.h>
> > +#include <linux/string.h>
> > +#include <linux/sched.h>
> > +#include <linux/wait.h>
> > +#include <linux/delay.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/module.h>
> > +#include <linux/notifier.h>
> > +#include <linux/device.h>
> > +#include <linux/log2.h>
> > +#include <linux/genwqe/genwqe_card.h>
> > +
> > +#include "card_base.h"
> > +#include "card_ddcb.h"
> > +
> > +MODULE_AUTHOR("Frank Haverkamp <haver@linux.vnet.ibm.com>");
> > +MODULE_AUTHOR("Michael Ruettger");
> > +MODULE_AUTHOR("Joerg-Stephan Vogt <jsvogt@de.ibm.com>");
> > +MODULE_AUTHOR("Michal Jung <mijung@de.ibm.com>");
> > +
> > +MODULE_DESCRIPTION("GenWQE Card");
> > +MODULE_VERSION(DRV_VERS_STRING);
> > +MODULE_LICENSE("GPL");
> > +
> > +/* module parameter */
> > +int genwqe_debug;
> > +module_param(genwqe_debug, int, 0644);	/* read/writeable */
> > +MODULE_PARM_DESC(genwqe_debug,
> > +		 "debug mode for extended outputs");
> > +
> > +int genwqe_ddcb_software_timeout = 10; /* new val requested by chief tester */
> > +module_param(genwqe_ddcb_software_timeout, int, 0644);	/* read/writeable */
> > +MODULE_PARM_DESC(genwqe_ddcb_software_timeout,
> > +		 "ddcb_software_timeout in seconds");
> > +
> > +int genwqe_skip_reset;
> > +module_param(genwqe_skip_reset, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_skip_reset,
> > +		 "skip reset of the card");
> > +
> > +int genwqe_skip_recovery;
> > +module_param(genwqe_skip_recovery, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_skip_recovery,
> > +		 "skip recovery after GFIR");
> > +
> > +/**
> > + * Set this to enable the VFs immediately at startup. Alternatively
> > + * one can use the new sysfs interfaces to enable the VFs after PF
> > + * driver loading.
> > + *
> > + * Enable VFs:
> > + *   sudo sh -c 'echo 15 > /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
> > + * or
> > + *   sudo sh -c 'echo 15 > /sys/class/corsa/genwqe0_card/device/sriov_numvfs'
> > + *
> > + * Disable VFs:
> > + *   sudo sh -c 'echo 0 > /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
> > + * or
> > + *   sudo sh -c 'echo 0 > /sys/class/corsa/genwqe0_card/device/sriov_numvfs'
> > + */
> > +int genwqe_max_num_vfs;
> > +module_param(genwqe_max_num_vfs, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_max_num_vfs,
> > +		 "limit the number of possible VFs");
> > +
> > +int genwqe_ddcb_max = 32;
> > +module_param(genwqe_ddcb_max, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_ddcb_max,
> > +		 "number of DDCBs on the work-queue");
> > +
> > +int genwqe_polling_enabled;
> > +module_param(genwqe_polling_enabled, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_polling_enabled,
> > +		 "in case of irqs not properly working ...");
> > +
> > +int genwqe_health_check_interval = 4;	/* <= 0: disabled */
> > +module_param(genwqe_health_check_interval, int, 0644);	/* read/writeable */
> > +MODULE_PARM_DESC(genwqe_health_check_interval,
> > +		 "check card health every N seconds (0 = disabled)");
> > +
> > +#define GENWQE_COLLECT_UNITS (BIT(GENWQE_DBG_UNIT0) |	  \
> > +			      BIT(GENWQE_DBG_UNIT1) |	  \
> > +			      BIT(GENWQE_DBG_UNIT2) |	  \
> > +			      BIT(GENWQE_DBG_REGS))
> > +
> > +int genwqe_collect_ffdc_units = GENWQE_COLLECT_UNITS;
> > +module_param(genwqe_collect_ffdc_units, int, 0444);	/* readable */
> > +MODULE_PARM_DESC(genwqe_collect_ffdc_units,
> > +		 "bitmask for FFDC gathering during bootup");
> > +
> > +/**
> > + * GenWQE Driver: Need SLC timeout set to 250ms (temporary setting for
> > + * testing of 1000ms due to decompressor testcase failing)
> > + *
> > + * There is a requirement by the card users that the timeout must not
> > + * exceed the 250ms.
> > + */
> > +int genwqe_vf_jobtimeout_msec = 250;
> > +module_param(genwqe_vf_jobtimeout_msec, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_vf_jobtimeout_msec,
> > +		 "Job timeout for virtual functions");
> > +
> > +int genwqe_pf_jobtimeout_msec = 8000;	/* 8sec should be ok */
> > +module_param(genwqe_pf_jobtimeout_msec, int, 0444); /* readable */
> > +MODULE_PARM_DESC(genwqe_pf_jobtimeout_msec,
> > +		 "Job timeout for physical function");
> > +
> > +int genwqe_kill_timeout = 8;
> > +module_param(genwqe_kill_timeout, int, 0644);	/* read/writeable */
> > +MODULE_PARM_DESC(genwqe_kill_timeout,
> > +		 "time to wait after sending stop signals");
> > +
> > +static char genwqe_driver_name[] = GENWQE_DEVNAME;
> > +static struct class *class_genwqe;
> > +static struct genwqe_dev *genwqe_devices[GENWQE_CARD_NO_MAX] = { 0, };
> > +
> > +static const enum genwqe_dbg_type unitid_to_ffdcid[] = {
> > +	[0] = GENWQE_DBG_UNIT0, [1] = GENWQE_DBG_UNIT1, [2] = GENWQE_DBG_UNIT2,
> > +	[3] = GENWQE_DBG_UNIT3, [4] = GENWQE_DBG_UNIT4, [5] = GENWQE_DBG_UNIT5,
> > +	[6] = GENWQE_DBG_UNIT6, [7] = GENWQE_DBG_UNIT7,
> > +};
> > +
> > +/**
> > + * PCI structure for identifying device by PCI vendor and device ID
> > + *
> > + * FIXME Do not forget to remove the obsolete when development is done ;-)
> > +*/
> > +static DEFINE_PCI_DEVICE_TABLE(genwqe_device_table) = {
> > +	{ .vendor      = PCI_VENDOR_ID_IBM,
> > +	  .device      = PCI_DEVICE_GENWQE,
> > +	  .subvendor   = PCI_SUBVENDOR_ID_IBM,
> > +	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5,
> > +	  .class       = (PCI_CLASSCODE_GENWQE5 << 8),
> > +	  .class_mask  = ~0,
> > +	  .driver_data = 0 },
> > +
> > +	/* Initial SR-IOV bring-up image */
> > +	{ .vendor      = PCI_VENDOR_ID_IBM,
> > +	  .device      = PCI_DEVICE_GENWQE,
> > +	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
> > +	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5_SRIOV,
> > +	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
> > +	  .class_mask  = ~0,
> > +	  .driver_data = 0 },
> > +
> > +	{ .vendor      = PCI_VENDOR_ID_IBM,  /* VF Vendor ID */
> > +	  .device      = 0x0000,  /* VF Device ID */
> > +	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
> > +	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5_SRIOV,
> > +	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
> > +	  .class_mask  = ~0,
> > +	  .driver_data = 0 },
> > +
> > +	/* Fixed up image */
> > +	{ .vendor      = PCI_VENDOR_ID_IBM,
> > +	  .device      = PCI_DEVICE_GENWQE,
> > +	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
> > +	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5,
> > +	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
> > +	  .class_mask  = ~0,
> > +	  .driver_data = 0 },
> > +
> > +	{ .vendor      = PCI_VENDOR_ID_IBM,  /* VF Vendor ID */
> > +	  .device      = 0x0000,  /* VF Device ID */
> > +	  .subvendor   = PCI_SUBVENDOR_ID_IBM_SRIOV,
> > +	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5,
> > +	  .class       = (PCI_CLASSCODE_GENWQE5_SRIOV << 8),
> > +	  .class_mask  = ~0,
> > +	  .driver_data = 0 },
> > +
> > +	/* Even one more ... */
> > +	{ .vendor      = PCI_VENDOR_ID_IBM,
> > +	  .device      = PCI_DEVICE_GENWQE,
> > +	  .subvendor   = PCI_SUBVENDOR_ID_IBM,
> > +	  .subdevice   = PCI_SUBSYSTEM_ID_GENWQE5_NEW,
> > +	  .class       = (PCI_CLASSCODE_GENWQE5 << 8),
> > +	  .class_mask  = ~0,
> > +	  .driver_data = 0 },
> > +
> > +	{ 0, }			/* 0 terminated list. */
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, genwqe_device_table);
> > +
> > +/**
> > + * @brief	create and prepare a new card descriptor
> > + *
> > + * @param err	pointer to error indicator
> > + * @return	NULL if errors (and err is set)
> > + *		or pointer to card descriptor
> > + */
> > +struct genwqe_dev *genwqe_dev_alloc(int *err)
> > +{
> > +	int i = 0;
> > +	struct genwqe_dev *cd;
> > +
> > +	for (i = 0; i < GENWQE_CARD_NO_MAX; i++) {
> > +		if (genwqe_devices[i] == NULL)
> > +			break;
> > +	}
> > +	if (i >= GENWQE_CARD_NO_MAX) {
> > +		*err = -ENODEV;
> > +		return NULL;
> 
> Usually <linux/err.h> is used for returning errors for functions that
> return pointer values. e.g:
> 
> 	return ERR_PTR(-ENODEV);

I fixed that.

> 
> > +	}
> > +
> > +	cd = kzalloc(sizeof(struct genwqe_dev), GFP_KERNEL);
> > +	if (!cd) {
> > +		*err = -ENOMEM;
> > +		return NULL;
> > +	}
> > +
> > +	cd->card_idx = i;
> > +	cd->class_genwqe = class_genwqe;
> > +	init_waitqueue_head(&cd->queue_waitq);
> > +
> > +	spin_lock_init(&cd->file_lock);
> > +	INIT_LIST_HEAD(&cd->file_list);
> > +
> > +	cd->card_state = GENWQE_CARD_UNUSED;
> > +	spin_lock_init(&cd->print_lock);
> > +
> > +	genwqe_devices[i] = cd;	/* do this when everything is fine */
> > +	*err = 0;
> > +	return cd;
> > +}
> > +
> > +void genwqe_dev_free(struct genwqe_dev *cd)
> > +{
> > +	if (!cd)
> > +		return;
> > +
> > +	genwqe_devices[cd->card_idx] = NULL;
> > +	memset(cd, 0, sizeof(*cd)); /* make it unusable, just in case ... */
> > +	kfree(cd);
> 
> Don't do this. Slub at least has really good memory debugging and can
> optionally poison freed memory to detect allocation/free errors. Doing
> it yourself means everybody always carries this cost.

Ok, removed.

> > +}
> > +
> > +/**
> > + * pci_reset_function will recover the device and ensure that the
> > + * registers are accessible again when it completes with success. If
> > + * not, the card will stay dead and registers will be unaccessible
> > + * still.
> > + */
> > +static int genwqe_bus_reset(struct genwqe_dev *cd)
> > +{
> > +	int bars, rc = 0;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	void __iomem *mmio;
> > +
> > +	if (cd->err_inject & GENWQE_INJECT_BUS_RESET_FAILURE)
> > +		return -EIO;
> > +
> > +	mmio = cd->mmio;
> > +	cd->mmio = NULL;
> > +	pci_iounmap(pci_dev, mmio);
> > +
> > +	bars = pci_select_bars(pci_dev, IORESOURCE_MEM);
> > +	pci_release_selected_regions(pci_dev, bars);
> > +
> > +	/**
> > +	 * Firmware/BIOS might change memory mapping during bus reset.
> > +	 * Settings like enable bus-mastering, ... are backuped and
> > +	 * restored by the pci_reset_function().
> > +	 */
> > +	dev_dbg(&pci_dev->dev, "[%s] pci_reset function ...\n", __func__);
> > +	rc = pci_reset_function(pci_dev);
> > +	if (rc) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: failed reset func (rc %d)\n", __func__, rc);
> > +		return rc;
> > +	}
> > +	dev_dbg(&pci_dev->dev, "[%s] done with rc=%d\n", __func__, rc);
> > +
> > +	/**
> > +	 * Here is the right spot to clear the register read
> > +	 * failure. pci_bus_reset() does this job in real systems.
> > +	 */
> > +	if (cd->err_inject & GENWQE_INJECT_HARDWARE_FAILURE)
> > +		cd->err_inject &= ~GENWQE_INJECT_HARDWARE_FAILURE;
> > +
> > +	if (cd->err_inject & GENWQE_INJECT_GFIR_FATAL)
> > +		cd->err_inject &= ~GENWQE_INJECT_GFIR_FATAL;
> > +
> > +	if (cd->err_inject & GENWQE_INJECT_GFIR_INFO)
> > +		cd->err_inject &= ~GENWQE_INJECT_GFIR_INFO;
> 
> You could just write this as:
> 
> 	cd->err_inject &= ~(GENWQE_INJECT_HARDWARE_FAILURE |
> 			    GENWQE_INJECT_GFIR_FATAL |
> 			    GENWQE_INJECT_GFIR_INFO);

Your version looks a little nicer than mine. Changed.

> 
> > +
> > +	rc = pci_request_selected_regions(pci_dev, bars, genwqe_driver_name);
> > +	if (rc) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: request bars failed (%d)\n", __func__, rc);
> > +		return -EIO;
> > +	}
> > +
> > +	cd->mmio = pci_iomap(pci_dev, 0, 0);
> > +	if (cd->mmio == NULL) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: mapping BAR0 failed\n", __func__);
> > +		return -ENOMEM;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * Hardware circumvention section. Certain bitstreams in our test-lab
> > + * had different kinds of problems. Here is where we adjust those
> > + * bitstreams to function will with this version of our device driver.
> > + *
> > + * Thise circumventions are applied to the physical function only.
> > + *
> > + * Unfortunately image 3243 shows a FIR at boot time. This is fixed in
> > + * zcomp026f, SVN rev. #269, but this is not yet in the image.
> > + *
> > + * In order to still get all App Firs (except the "hot" one) after
> > + * driver load time, unmask most of the AppFIRs again:
> > + *   $ sudo tools/genwqe_poke 0x2000020 0x000300000000001f
> > + *   $ sudo tools/genwqe_poke 0x2000040 0x20
> > + */
> > +
> > +/* Turn off error reporting for old/manufacturing images */
> > +int genwqe_need_err_masking(struct genwqe_dev *cd)
> 
> Should really return bool.
> 
> > +{
> > +	return (cd->slu_unitcfg & 0xFFFF0ull) < 0x32170ull;
> > +}

Ok.

> 
> Where do these, and other magic numbers below come from. Is the ull
> suffix really necessary?

Those magic numbers are special versions of the bitstream which we use
in the lab. They require special treatement which is mentioned in the
comment above. I also removed the references to our internal
bug-tracking in my new version. I tried to make the ull/Ull/uLL ...
stuff consistent. I am not sure if it is needed, maybe not, but since it
works and hopefully does not hurt, I kept it.

> > +
> > +static void genwqe_tweak_hardware(struct genwqe_dev *cd)
> > +{
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	/* Mask FIRs for development images */
> > +	if (((cd->slu_unitcfg & 0xFFFF0ull) >= 0x32000ull) &&
> > +	    ((cd->slu_unitcfg & 0xFFFF0ull) <= 0x33250ull)) {
> > +		dev_warn(&pci_dev->dev,
> > +			 "FIRs masked due to bitstream %016llx.%016llx\n",
> > +			 cd->slu_unitcfg, cd->app_unitcfg);
> > +
> > +		__genwqe_writeq(cd, IO_APP_SEC_LEM_DEBUG_OVR,
> > +				0xFFFFFFFFFFFFFFFFull);
> > +
> > +		__genwqe_writeq(cd, IO_APP_ERR_ACT_MASK,
> > +				0x0000000000000000ull);
> > +	}
> > +}
> > +
> > +/**
> > + * @note Bitstreams older than 2013-02-17 have a bug where fatal GFIRs
> > + * must be ignored. This is e.g. true for the bitstream we gave to the
> > + * card manufacturer, but also for some old bitstreams we released to
> > + * our test-lab.
> > + */
> > +int genwqe_recovery_on_fatal_gfir_required(struct genwqe_dev *cd)
> > +{
> > +	return ((cd->slu_unitcfg & 0xFFFF0ull) >= 0x32170ull);
> > +}
> > +
> > +int genwqe_flash_readback_fails(struct genwqe_dev *cd)
> > +{
> > +	return ((cd->slu_unitcfg & 0xFFFF0ull) < 0x32170ull);
> > +}
> > +
> > +/**
> > + * Note: From a design perspective it turned out to be a bad idea to
> > + * use codes here to specifiy the frequency/speed values. An old
> > + * driver cannot understand new codes and is therefore always a
> > + * problem. Better is to measure out the value or put the
> > + * speed/frequency directly into a register which is always a valid
> > + * value for old as well as for new software.
> > + */
> > +/* T = 1/f */
> > +static int genwqe_T_psec(struct genwqe_dev *cd)
> > +{
> > +	u16 speed;	/* 1/f -> 250,  200,  166,  175 */
> > +	static const int T[] = { 4000, 5000, 6000, 5714 };
> > +
> > +	speed = (u16)((cd->slu_unitcfg >> 28) & 0x0fLLU);
> 
> Be consistent with hex constants. Above you had uppercase for the hex
> chars and lower case for the suffix, here you haev the opposite.

I adopted the spots I saw to small letters.

> 
> > +	if (speed >= ARRAY_SIZE(T))
> > +		return -1;	/* illegal value */
> > +
> > +	return T[speed];
> > +}
> > +
> > +/**
> > + * Do this _after_ card_reset() is called. Otherwise the values will
> > + * vanish.
> > + *
> > + * The max. timeout value is 2^(10+x) * T (6ns for 166MHz) * 15/16.
> > + * The min. timeout value is 2^(10+x) * T (6ns for 166MHz) * 14/16.
> > + */
> > +static int genwqe_setup_jtimer(struct genwqe_dev *cd)
> > +{
> > +	u16 totalvfs;
> > +	int vf, pos;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	u32 T = genwqe_T_psec(cd);
> > +	u64 x;
> > +
> > +	if (genwqe_pf_jobtimeout_msec != -1) {
> > +		/* PF: large value needed, due to flash update 2sec
> > +		   per block */
> > +		x = ilog2(genwqe_pf_jobtimeout_msec *
> > +			  16000000000uL/(T * 15)) - 10;
> > +		genwqe_write_jtimer(cd, 0, (0xff00 | (x & 0xff)));
> > +	}
> > +
> > +	if (genwqe_vf_jobtimeout_msec != -1) {
> > +		pos = pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV);
> > +		if (pos) {
> > +			pci_read_config_word(pci_dev, pos + PCI_SRIOV_TOTAL_VF,
> > +					     &totalvfs);
> > +			cd->num_vfs = totalvfs;
> > +		}
> > +		if (totalvfs < 0)
> > +			return totalvfs;
> > +
> > +		x = ilog2(genwqe_vf_jobtimeout_msec *
> > +			  16000000000uL/(T * 15)) - 10;
> > +		for (vf = 0; vf < totalvfs; vf++)
> > +			genwqe_write_jtimer(cd, vf + 1, (0xff00 | (x & 0xff)));
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int genwqe_ffdc_buffs_alloc(struct genwqe_dev *cd)
> > +{
> > +	unsigned int type, e = 0;
> > +
> > +	for (type = 0; type < GENWQE_DBG_UNITS; type++) {
> > +		switch (type) {
> > +		case GENWQE_DBG_UNIT0:
> > +			e = genwqe_ffdc_buff_size(cd, 0); break;
> 
> Nit - put the break on a newline. It is easy to misread this as being
> fall-through cases.
> 

Makes sense. There were other spots in the code doing it similar, I
fixed those as well.

> > +		case GENWQE_DBG_UNIT1:
> > +			e = genwqe_ffdc_buff_size(cd, 1); break;
> > +		case GENWQE_DBG_UNIT2:
> > +			e = genwqe_ffdc_buff_size(cd, 2); break;
> > +		case GENWQE_DBG_REGS:
> > +			e = GENWQE_FFDC_REGS; break;
> > +		}
> > +
> > +		/* currently support only the debug units mentioned here */
> > +		cd->ffdc[type].entries = e;
> > +		cd->ffdc[type].regs = kmalloc(e * sizeof(struct genwqe_reg),
> > +					      GFP_KERNEL);
> 
> 	if (!cd->ffdc[type].regs) {
> 		/* Error handling */
> 	}
> 
> If a NULL return is okay here, then pass __GFP_NOWARN in the flags (so
> you don't get a warning/stack-trace on failure), and put a comment above
> the malloc explaining why the failure is okay.

I added a comment. If only the first failure data capture code fails, I
like the driver to load anyways, since it is just an add on. The hint
with the __GFP_NOWARN is nice. But if this fails I like to see that in
the logs. I mean if we don't get the memory there is something else
wrong with the system and I am sure the code will fail elsewhere later
too.

> 
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void genwqe_ffdc_buffs_free(struct genwqe_dev *cd)
> > +{
> > +	unsigned int type;
> > +
> > +	for (type = 0; type < GENWQE_DBG_UNITS; type++) {
> > +		kfree(cd->ffdc[type].regs);
> > +		cd->ffdc[type].regs = NULL;
> > +	}
> > +}
> > +
> > +static int genwqe_read_ids(struct genwqe_dev *cd)
> > +{
> > +	int err = 0;
> > +	int slu_id;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	cd->slu_unitcfg = __genwqe_readq(cd, IO_SLU_UNITCFG);
> > +	if (cd->slu_unitcfg == IO_ILLEGAL_VALUE) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: SLUID=%016llx\n", cd->slu_unitcfg);
> > +		err = -EIO;
> > +		goto out_err;
> > +	}
> > +
> > +	slu_id = genwqe_get_slu_id(cd);
> > +	if (slu_id < GENWQE_SLU_ARCH_REQ || slu_id == 0xff) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: incompatible SLU Architecture %u\n", slu_id);
> > +		err = -ENOENT;
> > +		goto out_err;
> > +	}
> > +
> > +	cd->app_unitcfg = __genwqe_readq(cd, IO_APP_UNITCFG);
> > +	if (cd->app_unitcfg == IO_ILLEGAL_VALUE) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: APPID=%016llx\n", cd->app_unitcfg);
> > +		err = -EIO;
> > +		goto out_err;
> > +	}
> > +	genwqe_read_app_id(cd, cd->app_name, sizeof(cd->app_name));
> > +
> > +	/**
> > +	 * Is access to all registers possible? If we are a VF the
> > +	 * answer is obvious. If we run fully virtualized, we need to
> > +	 * check if we can access all registers. If we do not have
> > +	 * full access we will cause an UR and some informational FIRs
> > +	 * in the PF, but that should not harm.
> > +	 */
> > +	if (pci_dev->is_virtfn)
> > +		cd->is_privileged = 0;
> > +	else
> > +		cd->is_privileged = (__genwqe_readq(cd, IO_SLU_BITSTREAM)
> > +				     != IO_ILLEGAL_VALUE);
> > +
> > + out_err:
> > +	return err;
> > +}
> > +
> > +static int genwqe_start(struct genwqe_dev *cd)
> > +{
> > +	int err;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	err = genwqe_read_ids(cd);
> > +	if (err)
> > +		return err;
> > +
> > +	if (genwqe_is_privileged(cd)) {
> > +		unsigned int unit_id;
> > +		enum genwqe_dbg_type ffdcid;
> > +
> > +		genwqe_ffdc_buffs_alloc(cd);  /* do this after the tweaks */
> 
> Error handling? Nitpick - Put comments on their own line above the
> statement/block they refer to.

Ok.

> 
> > +		genwqe_stop_traps(cd);
> > +
> > +		/* Collect registers e.g. FIRs, UNITIDs, ... */
> > +		if (genwqe_collect_ffdc_units & BIT(GENWQE_DBG_REGS))
> > +			genwqe_read_ffdc_regs(cd,
> > +				cd->ffdc[GENWQE_DBG_REGS].regs,
> > +				cd->ffdc[GENWQE_DBG_REGS].entries, 0);
> > +
> > +		/* Collect traces by unit */
> > +		for (unit_id = 0; unit_id < GENWQE_MAX_UNITS; unit_id++) {
> > +			ffdcid = unitid_to_ffdcid[unit_id];
> > +
> > +			if (genwqe_collect_ffdc_units & BIT(ffdcid))
> > +				genwqe_ffdc_buff_read(cd, unit_id,
> > +					cd->ffdc[ffdcid].regs,
> > +					cd->ffdc[ffdcid].entries);
> > +		}
> > +
> > +		genwqe_start_traps(cd);
> > +
> > +		if (cd->card_state == GENWQE_CARD_FATAL_ERROR) {
> > +			dev_warn(&pci_dev->dev,
> > +				 "[%s] chip reload/recovery!\n", __func__);
> > +
> > +			/* Stealth Mode: Reload chip on either hot
> > +			   reset or PERST. */
> 
> /*
>  * Multi-line comment style looks like this.
>  * Fix elsewhere too.
>  */

I had to change a lot to fix this finding ;-).

> 
> > +			cd->softreset = 0x7Cull;
> > +			__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET,
> > +				       cd->softreset);
> > +
> > +			err = genwqe_bus_reset(cd);
> > +			if (err != 0) {
> > +				dev_err(&pci_dev->dev,
> > +					"[%s] err: bus reset failed!\n",
> > +					__func__);
> > +				goto out;
> > +			}
> > +
> > +			/* STG Defect 515099 re-read the IDs because

Internal bug-tracking system references (STG Defect 515099) do not help
much outside our company. I removed them wherever I saw them.

> > +			   it could happen that the bitstream load
> > +			   failed! */
> > +			err = genwqe_read_ids(cd);
> > +			if (err)
> > +				goto out;
> > +		}
> > +	}
> > +
> > +	err = genwqe_setup_service_layer(cd);  /* does a reset to the card */
> > +	if (err != 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: could not setup servicelayer!\n", __func__);
> > +		err = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	if (genwqe_is_privileged(cd)) {	 /* code is running _after_ reset */
> > +		genwqe_tweak_hardware(cd);
> > +		genwqe_setup_jtimer(cd);	 /* queues must not run */
> > +	}
> > +
> > +	err = genwqe_device_create(cd);
> > +	if (err < 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: chdev init failed! (err=%d)\n", err);
> > +		goto out_release_service_layer;
> > +	}
> > +
> > +	if (genwqe_is_privileged(cd)) {
> > +		err = genwqe_enable_sriov(cd);
> > +		if (err == -EPERM)
> > +			dev_warn(&pci_dev->dev,
> > +				 "  Cannot enable SR-IOV (-EPERM)\n");
> > +		else if (err < 0) {
> > +			dev_err(&pci_dev->dev,
> > +				"  Cannot enable SR-IOV (%d)\n", err);
> > +			goto out_remove_card_dev;
> > +		}
> > +	}
> > +	return 0;
> > +
> > + out_remove_card_dev:
> > +	genwqe_device_remove(cd);
> > + out_release_service_layer:
> > +	genwqe_release_service_layer(cd);
> > + out:
> > +	if (genwqe_is_privileged(cd))
> > +		genwqe_ffdc_buffs_free(cd);
> > +	return -EIO;
> > +}
> > +
> > +/**
> > + * Recovery notes:
> > + *   As long as genwqe_thread runs we might access registers during
> > + *   error data capture. Same is with the genwqe_health_thread.
> > + *   When genwqe_bus_reset() fails this function might called two times:
> > + *   first by the genwqe_health_thread() and later by genwqe_remove() to
> > + *   unbind the device. We must be able to survive that.
> > + *
> > + * @note This function must be robust enough to be called twice.
> 
> What does this mean? Twice in a row on the same device?

The drivers health checking thread tries to recover the card when it
detects a problem. Part of the recovery procedure is to take all
externally visible interfaces (e.g. /dev/genwqe0_card) down, reset the
logic and start all up again (or not start again if it is a fatal
error).

If at the same time the Linux PCI support decides that the card is
really unusable, it triggers a card removal in parallel. This causes
that the shutdown procedures might be called twice. In this case the
removal code takes care that the health thread is shutdown nicely.

Nevertheless it could be the cards external interfaces are already
removed. In this case the functions will be called a 2nd time. We have
taken care that in this case we don't try to free resources which are
already gone.

> 
> > + */
> > +static int genwqe_stop(struct genwqe_dev *cd)
> > +{
> > +	genwqe_finish_queue(cd);	    /* no register access */
> > +	genwqe_device_remove(cd);	    /* device removed, procs killed */
> > +	genwqe_release_service_layer(cd);   /* here genwqe_thread is stopped */
> > +
> > +	if (genwqe_is_privileged(cd)) {
> > +		genwqe_disable_sriov(cd);   /* access to pci config space */
> > +		genwqe_ffdc_buffs_free(cd);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * @brief Try to recover the card. If fatal_err is set no register
> > + * access is possible anymore. It is likely that genwqe_start fails in
> > + * that situation. Proper error handling is required in this case.
> > + *
> > + * genwqe_bus_reset() will cause the pci code to call genwqe_remove()
> > + * and later genwqe_probe() for all virtual functions.
> > + */
> > +static int genwqe_recover_card(struct genwqe_dev *cd, int fatal_err)
> > +{
> > +	int rc;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	genwqe_stop(cd);
> > +
> > +	/**
> > +	 * Make sure chip is not reloaded to maintain FFDC.  Write SLU
> > +	 * Reset Register, CPLDReset field to 0.
> > +	 * FIXME: Need GenWQE Spec update to confirm value!
> > +	 */
> > +	if (!fatal_err) {
> > +		cd->softreset = 0x70ull;
> > +		__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
> > +	}
> > +
> > +	rc = genwqe_bus_reset(cd);
> > +	if (rc != 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: card recovery impossible!\n", __func__);
> > +		return rc;
> > +	}
> > +
> > +	rc = genwqe_start(cd);
> > +	if (rc < 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: failed to launch device!\n", __func__);
> > +		return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int genwqe_health_check_cond(struct genwqe_dev *cd, u64 *gfir)
> > +{
> > +	*gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
> > +	return (*gfir & GFIR_ERR_TRIGGER) &&
> > +		genwqe_recovery_on_fatal_gfir_required(cd);
> > +}
> > +
> > +/**
> > + * If this code works ok, can be tried out with help of the genwqe_poke tool:
> > + *   sudo ./tools/genwqe_poke 0x8 0xfefefefefef
> > + *
> > + * Now the relevant FIRs/sFIRs should be printed out and the driver should
> > + * invoke recovery (devices are removed and readded).
> > + */
> > +static u64 genwqe_fir_checking(struct genwqe_dev *cd)
> > +{
> > +	int j, iterations = 0;
> > +	u64 mask, fir, fec, uid, gfir, gfir_masked, sfir, sfec;
> > +	u32 fir_addr, fir_clr_addr, fec_addr, sfir_addr, sfec_addr;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > + healthMonitor:
> > +	iterations++;
> > +	if (iterations > 16) {
> > +		dev_err(&pci_dev->dev, "* exit looping after %d times\n",
> > +			iterations);
> > +		goto fatal_error;
> > +	}
> > +
> > +	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
> > +	if (gfir != 0x0)
> > +		dev_err(&pci_dev->dev, "* 0x%08x 0x%016llx\n",
> > +				    IO_SLC_CFGREG_GFIR, gfir);
> > +	if (gfir == IO_ILLEGAL_VALUE)
> > +		goto fatal_error;
> > +
> > +	/**
> > +	 * Avoid printing when to GFIR bit is on prevents contignous
> > +	 * printout e.g. for the following bug:
> > +	 *   FIR set without a 2ndary FIR/FIR cannot be cleared
> > +	 * Comment out the following if to get the prints:
> > +	 */
> > +	if (gfir == 0)
> > +		return 0;
> > +
> > +	gfir_masked = gfir & GFIR_ERR_TRIGGER;  /* fatal errors */
> > +
> > +	for (uid = 0; uid < GENWQE_MAX_UNITS; uid++) { /* 0..2 in zEDC */
> > +
> > +		/* read the primary FIR (pfir) */
> > +		fir_addr = (uid << 24) + 0x08;
> > +		fir = __genwqe_readq(cd, fir_addr);
> > +		if (fir == 0x0)
> > +			continue;  /* no error in this unit */
> > +
> > +		dev_err(&pci_dev->dev, "* 0x%08x 0x%016llx\n", fir_addr, fir);
> > +		if (fir == IO_ILLEGAL_VALUE)
> > +			goto fatal_error;
> > +
> > +		/* read primary FEC */
> > +		fec_addr = (uid << 24) + 0x18;
> > +		fec = __genwqe_readq(cd, fec_addr);
> > +
> > +		dev_err(&pci_dev->dev, "* 0x%08x 0x%016llx\n", fec_addr, fec);
> > +		if (fec == IO_ILLEGAL_VALUE)
> > +			goto fatal_error;
> > +
> > +		for (j = 0, mask = 1ULL; j < 64; j++, mask <<= 1) {
> > +
> > +			/* secondary fir empty, skip it */
> > +			if ((fir & mask) == 0x0)
> > +				continue;
> > +
> > +			sfir_addr = (uid << 24) + 0x100 + 0x08 * j;
> 
> More magic numbers? Similar below.

This is our hardware designers recommended way to retrieve the debug
data. They always refer to addresses rather than names for those
resources. So it made in my eyes not too much sense to invent defines
for each and everything in this case, when we are asked for addresses
again at the end when we like them to help us figuring out what is wrong
with the card.

What it boils down to at the end is that the chip is structured in units
and each unit has its own register-address range. Within that address
range, we will find the error registers (FIR: fault isolation register)
in a similar hierarchy manor.

> 
> > +			sfir = __genwqe_readq(cd, sfir_addr);
> > +
> > +			if (sfir == IO_ILLEGAL_VALUE)
> > +				goto fatal_error;
> > +			dev_err(&pci_dev->dev,
> > +				"* 0x%08x 0x%016llx\n", sfir_addr, sfir);
> > +
> > +			sfec_addr = (uid << 24) + 0x300 + 0x08 * j;
> > +			sfec = __genwqe_readq(cd, sfec_addr);
> > +
> > +			if (sfec == IO_ILLEGAL_VALUE)
> > +				goto fatal_error;
> > +			dev_err(&pci_dev->dev,
> > +				"* 0x%08x 0x%016llx\n", sfec_addr, sfec);
> > +
> > +			gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
> > +			if (gfir == IO_ILLEGAL_VALUE)
> > +				goto fatal_error;
> > +
> > +			/* gfir turned on during routine! get out and
> > +			   start over. */
> > +			if ((gfir_masked == 0x0) &&
> > +			    (gfir & GFIR_ERR_TRIGGER)) {
> > +				/* dev_warn(&pci_dev->dev,
> > +					 "ACK! Another FIR! Recursing %d!\n",
> > +					 iterations); */
> 
> Why is this commented out? Remove?

Ok.

> 
> > +				goto healthMonitor;
> > +			}
> > +
> > +			/* do not clear if we entered with a fatal gfir */
> > +			if (gfir_masked == 0x0) {
> > +
> > +				/* NEW clear by mask the logged bits */
> > +				sfir_addr = (uid << 24) + 0x100 + 0x08 * j;
> > +				__genwqe_writeq(cd, sfir_addr, sfir);
> > +
> > +				dev_dbg(&pci_dev->dev,
> > +					"[HM] Clearing  2ndary FIR 0x%08x "
> > +					"with 0x%016llx\n", sfir_addr, sfir);
> > +
> > +				/**
> > +				 * note, these cannot be error-Firs
> > +				 * since gfir_masked is 0 after sfir
> > +				 * was read. Also, it is safe to do
> > +				 * this write if sfir=0. Still need to
> > +				 * clear the primary. This just means
> > +				 * there is no secondary FIR.
> > +				 */
> > +
> > +				/* clear by mask the logged bit. */
> > +				fir_clr_addr = (uid << 24) + 0x10;
> > +				__genwqe_writeq(cd, fir_clr_addr, mask);
> > +
> > +				dev_dbg(&pci_dev->dev,
> > +					"[HM] Clearing primary FIR 0x%08x "
> > +					"with 0x%016llx\n", fir_clr_addr,
> > +					mask);
> > +			}
> > +		}
> > +	}
> > +	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
> > +	if (gfir == IO_ILLEGAL_VALUE)
> > +		goto fatal_error;
> > +
> > +	if ((gfir_masked == 0x0) && (gfir & GFIR_ERR_TRIGGER)) {
> > +		/**
> > +		 * Check once more that it didn't go on after all the
> > +		 * FIRS were cleared.
> > +		 */
> > +		dev_dbg(&pci_dev->dev, "ACK! Another FIR! Recursing %d!\n",
> > +			iterations);
> > +		goto healthMonitor;
> > +	}
> > +	return gfir_masked;
> > +
> > + fatal_error:
> > +	return IO_ILLEGAL_VALUE;
> > +}
> > +
> > +/**
> > + * This thread monitors the health of the card. A critical situation
> > + * is when we read registers which contain -1 (IO_ILLEGAL_VALUE). In
> > + * this case we need to be recovered from outside. Writing to
> > + * registers will very likely not work either.
> > + *
> > + * This thread must only exit if kthread_should_stop() becomes true.
> > + *
> > + * Testing bind/unbind with:
> > + *   sudo sh -c "echo -n 0000:20:00.0 > /sys/bus/pci/drivers/genwqe/unbind"
> > + *   sudo sh -c "echo -n 0000:20:00.0 > /sys/bus/pci/drivers/genwqe/bind"
> > + *
> > + * Condition for the health-thread to trigger:
> > + *   a) when a kthread_stop() request comes in or
> > + *   b) a critical GFIR occured
> > + *
> > + * Informational GFIRs are checked and potentially printed in
> > + * health_check_interval seconds.
> > + *
> > + * Testcase to trigger this code:
> > + *   Fatal GFIR:
> > + *     sudo ./tools/genwqe_poke -C0 0x00000008 0x001
> > + *   Info GFIR by writing to VF:
> > + *     sudo ./tools/genwqe_poke -C2 0x00020020 0x800
> > + */
> > +static int genwqe_health_thread(void *data)
> > +{
> > +	int rc, should_stop = 0;
> > +	struct genwqe_dev *cd = (struct genwqe_dev *)data;
> 
> Nit - don't need the cast.

I removed it.

> 
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	u64 gfir, gfir_masked, slu_unitcfg, app_unitcfg;
> > +
> > +	while (!kthread_should_stop()) {
> > +		rc = wait_event_interruptible_timeout(cd->health_waitq,
> > +			 (genwqe_health_check_cond(cd, &gfir) ||
> > +			  (should_stop = kthread_should_stop())),
> > +				genwqe_health_check_interval * HZ);
> > +
> > +		if (should_stop)
> > +			break;
> > +
> > +		if (gfir == IO_ILLEGAL_VALUE) {
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] GFIR=%016llx\n", __func__, gfir);
> > +			goto fatal_error;
> > +		}
> > +
> > +		slu_unitcfg = __genwqe_readq(cd, IO_SLU_UNITCFG);
> > +		if (slu_unitcfg == IO_ILLEGAL_VALUE) {
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] SLU_UNITCFG=%016llx\n",
> > +				__func__, slu_unitcfg);
> > +			goto fatal_error;
> > +		}
> > +
> > +		app_unitcfg = __genwqe_readq(cd, IO_APP_UNITCFG);
> > +		if (app_unitcfg == IO_ILLEGAL_VALUE) {
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] APP_UNITCFG=%016llx\n",
> > +				__func__, app_unitcfg);
> > +			goto fatal_error;
> > +		}
> > +
> > +		gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
> > +		if (gfir == IO_ILLEGAL_VALUE) {
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] %s: GFIR=%016llx\n", __func__,
> > +				(gfir & GFIR_ERR_TRIGGER) ? "err" : "info",
> > +				gfir);
> > +			goto fatal_error;
> > +		}
> > +
> > +		gfir_masked = genwqe_fir_checking(cd);
> > +		if (gfir_masked == IO_ILLEGAL_VALUE)
> > +			goto fatal_error;
> > +
> > +		/**
> > +		 * GFIR ErrorTrigger bits set => reset the card!
> > +		 * Never do this for old/manufacturing images!
> > +		 */
> > +		if ((gfir_masked) && !genwqe_skip_recovery &&
> > +		    genwqe_recovery_on_fatal_gfir_required(cd)) {
> > +
> > +			cd->card_state = GENWQE_CARD_FATAL_ERROR;
> > +
> > +			rc = genwqe_recover_card(cd, 0);
> > +			if (rc < 0) {
> > +				/* FIXME Card is unusable and needs unbind! */
> > +				goto fatal_error;
> > +			}
> > +		}
> > +
> > +		cd->last_gfir = gfir;
> > +		cond_resched();
> > +	}
> > +
> > +	return 0;
> > +
> > + fatal_error:
> > +	dev_err(&pci_dev->dev,
> > +		"[%s] card unusable. Please trigger unbind!\n", __func__);
> > +
> > +	/* Bring down logical devices to inform user space via udev remove. */
> > +	cd->card_state = GENWQE_CARD_FATAL_ERROR;
> > +	genwqe_stop(cd);
> > +
> > +	/* genwqe_bus_reset failed(). Now wait for genwqe_remove(). */
> > +	while (!kthread_should_stop())
> > +		cond_resched();
> > +
> > +	return -EIO;
> > +}
> > +
> > +static int genwqe_health_check_start(struct genwqe_dev *cd)
> > +{
> > +	int rc;
> > +
> > +	if (genwqe_health_check_interval <= 0)
> > +		return 0;	/* valid for disabling the service */
> > +
> > +	/* moved before request_irq() */
> > +	/* init_waitqueue_head(&cd->health_waitq); */
> > +
> > +	cd->health_thread = kthread_run(genwqe_health_thread, cd,
> > +					GENWQE_DEVNAME "%d_health",
> > +					cd->card_idx);
> > +	if (IS_ERR(cd->health_thread)) {
> > +		rc = PTR_ERR(cd->health_thread);
> > +		cd->health_thread = NULL;
> > +		return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int genwqe_health_thread_running(struct genwqe_dev *cd)
> > +{
> > +	return (cd->health_thread != NULL);
> > +}
> > +
> > +static int genwqe_health_check_stop(struct genwqe_dev *cd)
> > +{
> > +	int rc;
> > +
> > +	if (!genwqe_health_thread_running(cd))
> > +		return -EIO;
> > +
> > +	rc = kthread_stop(cd->health_thread);
> > +	cd->health_thread = NULL;
> > +	return 0;
> > +}
> > +
> > +/**
> > + * @brief Allocate PCIe related resources for our card.
> > + */
> > +static int genwqe_pci_setup(struct genwqe_dev *cd)
> > +{
> > +	int err, bars;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	bars = pci_select_bars(pci_dev, IORESOURCE_MEM);
> > +	err = pci_enable_device_mem(pci_dev);
> > +	if (err) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: failed to enable pci memory (err=%d)\n", err);
> > +		goto err_out;
> > +	}
> > +
> > +	/* Reserve PCI I/O and memory resources */
> > +	err = pci_request_selected_regions(pci_dev, bars, genwqe_driver_name);
> > +	if (err) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: request bars failed (%d)\n", __func__, err);
> > +		err = -EIO;
> > +		goto err_disable_device;
> > +	}
> > +
> > +	/* check for 64-bit DMA address supported (DAC) */
> > +	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
> > +		err = pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(64));
> > +		if (err) {
> > +			dev_err(&pci_dev->dev,
> > +				"err: DMA64 consistent mask error\n");
> > +			err = -EIO;
> > +			goto out_release_resources;
> > +		}
> > +	/* check for 32-bit DMA address supported (SAC) */
> > +	} else if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
> > +		err = pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(32));
> > +		if (err) {
> > +			dev_err(&pci_dev->dev,
> > +				"err: DMA32 consistent mask error\n");
> > +			err = -EIO;
> > +			goto out_release_resources;
> > +		}
> > +	} else {
> > +		dev_err(&pci_dev->dev,
> > +			"err: neither DMA32 nor DMA64 supported\n");
> > +		err = -EIO;
> > +		goto out_release_resources;
> > +	}
> > +
> > +	pci_set_master(pci_dev);
> > +	pci_enable_pcie_error_reporting(pci_dev);
> > +
> > +	/* request complete BAR-0 space (length = 0) */
> > +	cd->mmio_len = pci_resource_len(pci_dev, 0);
> > +	cd->mmio = pci_iomap(pci_dev, 0, 0);
> > +	if (cd->mmio == NULL) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: mapping BAR0 failed\n", __func__);
> > +		err = -ENOMEM;
> > +		goto out_release_resources;
> > +	}
> > +
> > +	err = genwqe_read_ids(cd);
> > +	if (err)
> > +		goto out_iounmap;
> > +
> > +	return 0;
> > +
> > + out_iounmap:
> > +	pci_iounmap(pci_dev, cd->mmio);
> > + out_release_resources:
> > +	pci_release_selected_regions(pci_dev, bars);
> > + err_disable_device:
> > +	pci_disable_device(pci_dev);
> > + err_out:
> > +	return err;
> > +}
> > +
> > +/**
> > + * @brief Free PCIe related resources for our card.
> > + */
> > +static void genwqe_pci_remove(struct genwqe_dev *cd)
> > +{
> > +	int bars;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	if (cd->mmio)
> > +		pci_iounmap(pci_dev, cd->mmio);
> > +
> > +	bars = pci_select_bars(pci_dev, IORESOURCE_MEM);
> > +	pci_release_selected_regions(pci_dev, bars);
> > +	pci_disable_device(pci_dev);
> > +}
> > +
> > +/**
> > + * @brief	device initialization
> > + *		Callable for multiple cards. No __devinit attribute applicable.
> > + *              This function is called on bind.
> > + *
> > + * @pdev	PCI device information struct
> > + * @return	0 if succeeded, < 0 when failed
> > + */
> > +static int genwqe_probe(struct pci_dev *pci_dev,
> > +			const struct pci_device_id *id)
> > +{
> > +	int err;
> > +	struct genwqe_dev *cd;
> > +
> > +	init_crc32();
> > +
> > +	cd = genwqe_dev_alloc(&err);
> > +	if (cd == NULL) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: could not allocate memory!\n");
> 
> You generally don't need to print an error on memory allocation failure
> since the kmalloc calls will print a warning + stacktrace on failure if
> __GFP_NOWARN is not passed.

I like to know which card has a problem. We are using mostly more than
one card and an anonymous stackdump without the cards name and
bus/func_id id is problematic to analyze for us. That is why I like to
keep that in most cases.

> 
> > +		return err;
> > +	}
> > +
> > +	dev_set_drvdata(&pci_dev->dev, cd);
> > +	cd->pci_dev = pci_dev;
> > +	cd->num_vfs = genwqe_max_num_vfs;
> > +
> > +	err = genwqe_pci_setup(cd);
> > +	if (err < 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: problems with PCI setup (err=%d)\n", err);
> > +		goto out_free_dev;
> > +	}
> > +
> > +	err = genwqe_start(cd);
> > +	if (err < 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"err: cannot start card services! (err=%d)\n", err);
> > +		goto out_pci_remove;
> > +	}
> > +
> > +	if (genwqe_is_privileged(cd)) {
> > +		err = genwqe_health_check_start(cd);
> > +		if (err < 0) {
> > +			dev_err(&pci_dev->dev,
> > +				"err: cannot start health checking! "
> > +				"(err=%d)\n", err);
> > +			goto out_stop_services;
> > +		}
> > +	}
> > +	return 0;
> > +
> > + out_stop_services:
> > +	genwqe_stop(cd);
> > + out_pci_remove:
> > +	genwqe_pci_remove(cd);
> > + out_free_dev:
> > +	genwqe_dev_free(cd);
> > +	return err;
> > +}
> > +
> > +/**
> > + * @brief	Called when device is removed (hot-plugable)
> > + *		or when driver is unloaded respecitively when unbind is done.
> > + */
> > +static void genwqe_remove(struct pci_dev *pci_dev)
> > +{
> > +	struct genwqe_dev *cd = dev_get_drvdata(&pci_dev->dev);
> > +
> > +	genwqe_health_check_stop(cd);
> > +
> > +	/**
> > +	 * genwqe_stop() must survive if it is called twice
> > +	 * sequentially. This happens when the health thread calls it
> > +	 * and fails on genwqe_bus_reset().
> > +	 */
> > +	genwqe_stop(cd);
> > +	genwqe_pci_remove(cd);
> > +	genwqe_dev_free(cd);
> > +}
> > +
> > +/*
> > + * This callback is called by the PCI subsystem whenever
> > + * a PCI bus error is detected.
> > + */
> > +static pci_ers_result_t genwqe_err_error_detected(struct pci_dev *pci_dev,
> > +						 enum pci_channel_state state)
> > +{
> > +	pci_ers_result_t result = PCI_ERS_RESULT_NEED_RESET;
> > +	struct genwqe_dev *cd;
> > +
> > +	dev_err(&pci_dev->dev,
> > +		"[%s] state=%d\n", __func__, state);
> > +
> > +	if (pci_dev == NULL)
> > +		return result;
> > +
> > +	cd = dev_get_drvdata(&pci_dev->dev);
> > +	if (cd == NULL)
> > +		return result;
> > +
> > +	switch (state) {
> > +	case pci_channel_io_normal:
> > +		result = PCI_ERS_RESULT_CAN_RECOVER;
> > +		break;
> 
> Nit:
> 
> 	case pci_channel_io_normal:
> 		return PCI_ERS_RESULT_CAN_RECOVER;
> 
> etc.

Ok, fixed.

> 
> > +	case pci_channel_io_frozen:
> > +		result = PCI_ERS_RESULT_NEED_RESET;
> > +		break;
> > +	case pci_channel_io_perm_failure:
> > +		result = PCI_ERS_RESULT_DISCONNECT;
> > +		break;
> > +	default:
> > +		result = PCI_ERS_RESULT_NEED_RESET;
> > +	}
> > +	return result;		/* Request a slot reset. */
> > +}
> > +
> > +static pci_ers_result_t genwqe_err_mmio_enabled(struct pci_dev *dev)
> > +{
> > +	return PCI_ERS_RESULT_NONE;
> > +}
> > +
> > +static pci_ers_result_t genwqe_err_link_reset(struct pci_dev *dev)
> > +{
> > +	return PCI_ERS_RESULT_NONE;
> > +}
> > +
> > +static pci_ers_result_t genwqe_err_slot_reset(struct pci_dev *dev)
> > +{
> > +	return PCI_ERS_RESULT_NONE;
> > +}
> 
> Nit, these could all just be replaced by a single function.

Ok, I am using the same function now.

> 
> > +
> > +static void genwqe_err_resume(struct pci_dev *dev)
> > +{
> > +}
> > +
> > +static int genwqe_sriov_configure(struct pci_dev *dev, int numvfs)
> > +{
> > +	if (numvfs > 0) {
> > +		pci_enable_sriov(dev, numvfs);
> > +		return numvfs;
> > +	}
> > +	if (numvfs == 0) {
> > +		pci_disable_sriov(dev);
> > +		return 0;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static struct pci_error_handlers genwqe_err_handler = {
> > +	.error_detected = genwqe_err_error_detected,
> > +	.mmio_enabled	= genwqe_err_mmio_enabled,
> > +	.link_reset	= genwqe_err_link_reset,
> > +	.slot_reset	= genwqe_err_slot_reset,
> > +	.resume		= genwqe_err_resume,
> > +};
> > +
> > +static struct pci_driver genwqe_driver = {
> > +	.name	  = genwqe_driver_name,
> > +	.id_table = genwqe_device_table,
> > +	.probe	  = genwqe_probe,
> > +	.remove	  = genwqe_remove,
> > +	.sriov_configure = genwqe_sriov_configure,
> > +	.err_handler = &genwqe_err_handler,
> > +};
> > +
> > +/**
> > + * @brief	driver registration
> > + */
> > +static int __init genwqe_init_module(void)
> > +{
> > +	int rc;
> > +
> > +	class_genwqe = class_create(THIS_MODULE, GENWQE_DEVNAME);
> > +	if (IS_ERR(class_genwqe)) {
> > +		pr_err("[%s] create class failed\n", __func__);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	rc = pci_register_driver(&genwqe_driver);
> > +	if (rc != 0) {
> > +		pr_err("[%s] pci_reg_driver (rc=%d)\n", __func__, rc);
> > +		goto err_out;
> > +	}
> > +	return rc;
> > +
> > + err_out:
> > +	class_destroy(class_genwqe);
> > +	class_genwqe = NULL;
> > +	return rc;
> > +}
> > +
> > +/**
> > + * @brief	driver exit
> > + */
> > +static void __exit genwqe_exit_module(void)
> > +{
> > +	pci_unregister_driver(&genwqe_driver);
> > +	class_destroy(class_genwqe);
> > +	class_genwqe = NULL;
> 
> Not needed. The whole module just went away.

Ok. Removed.

> 
> > +}
> > +
> > +module_init(genwqe_init_module);
> > +module_exit(genwqe_exit_module);
> > diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
> > new file mode 100644
> > index 0000000..7a9b9de
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/card_base.h
> > @@ -0,0 +1,515 @@
> > +#ifndef __CARD_BASE_H__
> > +#define __CARD_BASE_H__
> > +
> > +/**
> > + * IBM Accelerator Family 'GenWQE'
> > + *
> > + * (C) Copyright IBM Corp. 2013
> > + *
> > + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> > + * Author: Michael Jung <mijung@de.ibm.com>
> > + * Author: Michael Ruettger <michael@ibmra.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2, or (at your option)
> > + * any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +/**
> > + * Interfaces within the GenWQE module. Defines genwqe_card and
> > + * ddcb_queue as well as ddcb_requ.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/types.h>
> > +#include <linux/cdev.h>
> > +#include <linux/stringify.h>
> > +#include <linux/pci.h>
> > +#include <linux/semaphore.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/io.h>
> > +#include <linux/version.h>
> > +#include <linux/genwqe/genwqe_card.h>
> > +
> > +#include "genwqe_driver.h"
> > +
> > +#define GENWQE_MSI_IRQS		4  /**< we use only one until we have MSIx */
> > +#define GENWQE_MAX_FUNCS	16 /**< max PF and VFs */
> > +#define GENWQE_CARD_NO_MAX	(16 * GENWQE_MAX_FUNCS)
> > +#define GENWQE_MAX_DEVICES      4  /**< max number for platform devices */
> > +
> > +/*< Module parameters */
> > +extern int genwqe_debug;
> > +extern int genwqe_skip_reset;
> > +extern int genwqe_max_num_vfs;
> > +extern int genwqe_ddcb_max;
> > +extern int genwqe_ddcb_software_timeout;
> > +extern int genwqe_polling_enabled;
> > +extern int genwqe_health_check_interval;
> > +extern int genwqe_collect_ffdc_units;
> > +extern int genwqe_kill_timeout;
> > +
> > +/**
> > + * config space of Genwqe5 A7:
> > + * 00:[14 10 4b 04]46 04 10 00[00 00 00 12]10 00 00 00
> > + * 10: 0c 00 00 98 00 00 00 00 00 00 00 a0 00 00 00 00
> > + * 20: 00 00 00 00 00 00 00 00 00 00 00 00[14 10 5f 03]
> > + * 30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 01 00 00
> > + *
> > + * new config space for Genwqe5 A7:
> > + * 00:[14 10 4b 04]40 00 10 00[00 00 00 12]00 00 00 00
> > + * 10: 0c 00 00 f0 07 3c 00 00 00 00 00 00 00 00 00 00
> > + * 20: 00 00 00 00 00 00 00 00 00 00 00 00[14 10 4b 04]
> > + * 30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00
> > + */
> > +
> > +#define PCI_DEVICE_GENWQE		0x044b /**< Genwqe DeviceID */
> > +
> > +#define PCI_SUBSYSTEM_ID_GENWQE5	0x035f /**< Genwqe A5 Subsystem-ID */
> > +#define PCI_SUBSYSTEM_ID_GENWQE5_NEW	0x044b /**< Genwqe A5 Subsystem-ID */
> > +#define PCI_CLASSCODE_GENWQE5		0x1200 /**< UNKNOWN */
> > +
> > +#define PCI_SUBVENDOR_ID_IBM_SRIOV	0x0000
> > +#define PCI_SUBSYSTEM_ID_GENWQE5_SRIOV	0x0000 /**< Genwqe A5 Subsystem-ID */
> > +#define PCI_CLASSCODE_GENWQE5_SRIOV	0x1200 /**< UNKNOWN */
> > +
> > +/* allocation and deallocation helpers */
> > +#define GENWQE_FLAG_MSI_ENABLED		(1 << 8)
> > +
> > +/**
> > + * required SLU hardware architecture level
> > + * 1 = wfo
> > + * 2 = zEDC
> > + * 3 = zEDC & generic DDCB
> > + */
> > +#define	GENWQE_SLU_ARCH_REQ	2
> > +
> > +
> > +/**
> > + * Flags for extended output (dbg_print)
> > + *   We define different levels of debugging for the appropriate unit.
> > + */
> > +#define dbg_card			0x00000001
> > +#define dbg_card_ddcb			0x00000004
> > +#define dbg_card_regs			0x00000008
> > +#define dbg_card_sglist			0x00000400
> > +#define dbg_card_pinning		0x00000800
> > +
> > +extern int debug;
> 
> Across the whole kernel? Call it genqwe_debug at least.

Removed. It was a leftover from the times our driver had no prefix in
front of the module parameters.

> 
> > +
> > +#define dbg_printk(_cd, dbg_unit, fmt, ...) do {			\
> > +		struct genwqe_dev *__cd = (_cd);			\
> > +		if (genwqe_debug & (dbg_unit))				\
> > +			dev_info(&__cd->pci_dev->dev, fmt,		\
> > +				 ## __VA_ARGS__);			\
> > +	} while (0)
> 
> Nit, genwqe_dprintk would be a better name for this. dbg_printk sounds
> like a generic function.
> 

I like your naming better than my choice. I renamed it according to your
proposal.

> > +
> > +/**< Software error injection to simulate card failures */
> > +#define GENWQE_INJECT_HARDWARE_FAILURE	0x00000001 /* injects -1 reg reads */
> > +#define GENWQE_INJECT_BUS_RESET_FAILURE 0x00000002 /* pci_bus_reset fail */
> > +#define GENWQE_INJECT_GFIR_FATAL	0x00000004 /* GFIR = 0x0000ffff */
> > +#define GENWQE_INJECT_GFIR_INFO		0x00000008 /* GFIR = 0xffff0000 */
> > +
> > +/**
> > + * Genwqe card description and management data.
> > + *
> > + * Error-handling in case of card malfunction
> > + * ------------------------------------------
> > + *
> > + * If the card is detected to be defective the outside environment
> > + * will cause the PCI layer to call deinit (the cleanup function for
> > + * probe). This is the same effect like doing a unbind/bind operation
> > + * on the card.
> > + *
> > + * The genwqe card driver implements a health checking thread which
> > + * verifies the card function. If this detects a problem the cards
> > + * device is being shutdown and restarted again, along with a reset of
> > + * the card and queue.
> > + *
> > + * All functions accessing the card device return either EIO or ENODEV
> > + * code to indicate the malfunction to the user. The user has to close
> > + * the filedestriptor and open a new one, once the card becomes
> 
> Typo: "file descriptor". Fix elsewhere below.

Ok.

> 
> > + * available again.
> > + *
> > + * If the open filedescriptor is setup to receive SIGIO, the signal is
> > + * genereated for the application which has to provide a handler to
> > + * react on it. If the application does not close the open
> > + * filedescriptors a SIGKILL is send to enforce freeing the cards
> > + * resources.
> > + *
> > + * I did not find a different way to prevent kernel problems due to
> > + * reference counters for the cards character devices getting out of
> > + * sync. The character device deallocation does not block, even if
> > + * there is still an open filedescriptor pending. If this pending
> > + * descriptor is closed, the data structures used by the character
> > + * device is reinstantiated, which will lead to the reference counter
> > + * dropping below the allowed values.
> > + *
> > + * Card recovery
> > + * -------------
> > + *
> > + * To test the internal driver recovery the following command can be used:
> > + *   sudo sh -c 'echo 0xfffff > /sys/class/genwqe/genwqe0_card/err_inject'
> > + */
> > +
> > +
> > +/**
> > + * To avoid memcpying data arround we use user memory directly. To do
> > + * this we need to pin/swap-in the memory and request a DMA address
> > + * for it.
> > + */
> > +enum dma_mapping_type {
> > +	GENWQE_MAPPING_RAW = 0,		/**< contignous memory buffer */
> > +	GENWQE_MAPPING_SGL_TEMP,		/**< sglist dynamically used */
> > +	GENWQE_MAPPING_SGL_PINNED,	/**< sglist used with pinning */
> > +};
> > +
> > +struct dma_mapping {
> > +	enum dma_mapping_type type;
> > +
> > +	void *u_vaddr;			/**< user-space vaddr/non-aligned */
> > +	void *k_vaddr;			/**< kernel-space vaddr/non-aligned */
> > +	dma_addr_t dma_addr;		/**< physical DMA address */
> > +
> > +	struct page **page_list;	/**< list of pages used by user buff */
> > +	dma_addr_t *dma_list;		/**< list of dma addresses per page */
> > +	unsigned int nr_pages;		/**< number of pages */
> > +	unsigned int size;		/**< size in bytes */
> > +
> > +	struct list_head card_list;	/**< list of usr_maps for card */
> > +	struct list_head pin_list;	/**< list of pinned memory for dev */
> > +};
> > +
> > +static inline void genwqe_mapping_init(struct dma_mapping *m,
> > +				       enum dma_mapping_type type)
> > +{
> > +	memset(m, 0, sizeof(*m));
> > +	m->type = type;
> > +}
> > +
> > +struct ddcb_queue {
> > +	const char *name;
> > +
> > +	/** service layer: device driver control blocks (DDCB) */
> > +	int ddcb_max;			/**< amount of DDCBs  */
> > +	int ddcb_next;			/**< next available DDCB num */
> > +	int ddcb_act;			/**< DDCB to be processed */
> > +	u16 ddcb_seq;			/**< slc seq num */
> > +	unsigned int ddcbs_in_flight;	/**< number of ddcbs in processing */
> > +	unsigned int ddcbs_completed;
> > +	unsigned int ddcbs_max_in_flight;
> > +	unsigned int busy;		/**< how many times -EBUSY? */
> > +
> > +	dma_addr_t ddcb_daddr;		/**< DMA address */
> > +	struct ddcb __iomem *ddcb_vaddr;
> > +	struct ddcb_requ **ddcb_req;	/**< ddcb processing parameter */
> > +	wait_queue_head_t *ddcb_waitqs; /**< waitqueue per ddcb */
> > +
> > +	spinlock_t ddcb_lock;		/**< exclusive access to queue */
> > +	wait_queue_head_t ddcb_waitq;	/**< for ddcb processing */
> > +	void *ddcb_attr;		/**< sysfs attr. block */
> > +
> > +	/* registers or the respective queue to be used */
> > +	u32 IO_QUEUE_CONFIG;
> > +	u32 IO_QUEUE_STATUS;
> > +	u32 IO_QUEUE_SEGMENT;
> > +	u32 IO_QUEUE_INITSQN;
> > +	u32 IO_QUEUE_WRAP;
> > +	u32 IO_QUEUE_OFFSET;
> > +	u32 IO_QUEUE_WTIME;
> > +	u32 IO_QUEUE_ERRCNTS;
> > +	u32 IO_QUEUE_LRW;
> > +};
> > +
> > +/**
> > + * GFIR, SLU_UNITCFG, APP_UNITCFG
> > + *   8 Units with FIR/FEC + 64 * 2ndary FIRS/FEC.
> > + */
> > +#define GENWQE_FFDC_REGS	(3 + (8 * (2 + 2 * 64)))
> > +
> > +struct genwqe_ffdc {
> > +	unsigned int entries;
> > +	struct genwqe_reg *regs;
> > +};
> > +
> > +struct genwqe_dev {
> > +	enum genwqe_card_state card_state;
> > +	spinlock_t print_lock;
> > +
> > +	int card_idx;			/**< card index 0..CARD_NO_MAX-1 */
> > +	u64 flags;			/**< general flags */
> > +
> > +	/* FFDC data gathering */
> > +	struct genwqe_ffdc ffdc[GENWQE_DBG_UNITS];
> > +
> > +	/* DDCB workqueue */
> > +	struct task_struct *card_thread;
> > +	wait_queue_head_t queue_waitq;
> > +	struct ddcb_queue queue;	/**< genwqe DDCB queue */
> > +	unsigned int irqs_processed;
> > +
> > +	/* Card health checking thread */
> > +	struct task_struct *health_thread;
> > +	wait_queue_head_t health_waitq;
> > +
> > +	/* char device */
> > +	dev_t  devnum_genwqe;		/**< major/minor num card */
> > +	struct class *class_genwqe;	/**< reference to class object */
> > +	struct device *dev;		/**< for device creation */
> > +	struct cdev cdev_genwqe;		/**< char device for card */
> > +
> > +	/* pci resources */
> > +	struct pci_dev *pci_dev;	/**< PCI device */
> > +	void __iomem *mmio;		/**< BAR-0 MMIO start */
> > +	unsigned long mmio_len;
> > +	u16 num_vfs;
> > +	int is_privileged;	       /**< access to all regs possible */
> > +
> > +	/* config regs which we need often */
> > +	u64  slu_unitcfg;
> > +	u64  app_unitcfg;
> > +	u64  softreset;
> > +	u64  err_inject;
> > +	u64  last_gfir;
> > +	char app_name[5];
> > +
> > +	spinlock_t file_lock;		/**< lock for open files */
> > +	struct list_head file_list;	/**< list of open files */
> > +
> > +	int co_devices;			/**< number of platform devices */
> > +	struct platform_device *co_dev[GENWQE_MAX_DEVICES];
> > +};
> > +
> > +/** kernel internal representation of the DDCB request */
> > +struct ddcb_requ {
> > +	/* kernel specific content */
> > +	enum genwqe_requ_state req_state;		/**< request status */
> > +	int num;			/**< ddcb_no for this request */
> > +	struct ddcb_queue *queue;	/**< associated queue */
> > +
> > +	struct dma_mapping  dma_mappings[DDCB_FIXUPS];
> > +	struct sg_entry     *sgl[DDCB_FIXUPS];
> > +	dma_addr_t	    sgl_dma_addr[DDCB_FIXUPS];
> > +	size_t		    sgl_size[DDCB_FIXUPS];
> > +
> > +	/* kernel/user shared content */
> > +	struct genwqe_ddcb_cmd cmd;	/**< ddcb_no for this request */
> > +	struct genwqe_debug_data debug_data;
> > +};
> > +
> > +static inline enum genwqe_requ_state ddcb_requ_get_state(struct ddcb_requ *req)
> > +{
> > +	return req->req_state;
> > +}
> > +
> > +static inline void ddcb_requ_set_state(struct ddcb_requ *req,
> > +				       enum genwqe_requ_state new_state)
> > +{
> > +	req->req_state = new_state;
> > +}
> > +
> > +int  ddcb_requ_finished(struct genwqe_dev *cd, struct ddcb_requ *req);
> > +
> > +static inline int ddcb_requ_collect_debug_data(struct ddcb_requ *req)
> > +{
> > +	return (req->cmd.debug_data != NULL);
> > +}
> > +
> > +/** This data structure exists during genwqe_card file descriptor's lifetime */
> > +struct genwqe_file {
> > +	struct genwqe_dev *cd;
> > +	struct genwqe_driver *client;
> > +	struct file *filp;
> > +
> > +	struct fasync_struct *async_queue;
> > +	struct task_struct *owner;
> > +	struct list_head list;		/**< entry in list of open files */
> > +
> > +	spinlock_t map_lock;		/**< lock for dma_mappings */
> > +	struct list_head map_list;	/**< list of dma_mappings */
> > +
> > +	spinlock_t pin_lock;		/**< lock for pinned memory */
> > +	struct list_head pin_list;	/**< list of pinned memory */
> > +};
> > +
> > +int  genwqe_setup_service_layer(struct genwqe_dev *cd); /**< for PF only */
> > +int  genwqe_finish_queue(struct genwqe_dev *cd);
> > +int  genwqe_release_service_layer(struct genwqe_dev *cd);
> > +
> > +/**
> > + * @brief	evaluate id of Service Layer Unit
> > + *		0x00 : Development mode.  /  Genwqe4-WFO (defunct)
> > + *		0x01 : SLC1 (a5-wfo)
> > + *		0x02 : SLC2 (sept2012) zcomp, zdb2,  single DDCB,
> > + *		0x03 : SLC2 (feb2013,  zcomp, zdb2,  generic driver,
> > + */
> > +static inline int genwqe_get_slu_id(struct genwqe_dev *cd)
> > +{
> > +	return (int)((cd->slu_unitcfg >> 32) & 0xff);
> > +}
> > +
> > +int  genwqe_check_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue);
> > +int  genwqe_next_ddcb_ready(struct genwqe_dev *cd);
> > +int  genwqe_ddcbs_in_flight(struct genwqe_dev *cd);
> > +
> > +u8   genwqe_card_type(struct genwqe_dev *cd);
> > +int  genwqe_card_reset(struct genwqe_dev *cd);
> > +int  genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count);
> > +void genwqe_reset_interrupt_capability(struct genwqe_dev *cd);
> > +
> > +int  genwqe_device_create(struct genwqe_dev *cd);
> > +int  genwqe_device_remove(struct genwqe_dev *cd);
> > +
> > +int  genwqe_enable_sriov(struct genwqe_dev *cd);
> > +int  genwqe_disable_sriov(struct genwqe_dev *cd);
> > +
> > +int  create_card_sysfs(struct genwqe_dev *cd);
> > +void remove_card_sysfs(struct genwqe_dev *cd);
> > +
> > +int  genwqe_read_softreset(struct genwqe_dev *cd);
> > +
> > +/* Hardware Circumventions */
> > +int  genwqe_recovery_on_fatal_gfir_required(struct genwqe_dev *cd);
> > +int  genwqe_flash_readback_fails(struct genwqe_dev *cd);
> > +
> > +/**
> > + * @param [in] cd    genwqe device
> > + * @param [in] func  0: PF, 1: VF0, ..., 15: VF14
> > + */
> > +int  genwqe_write_jtimer(struct genwqe_dev *cd, int func, u64 val);
> > +
> > +/**
> > + * @param [in] cd    genwqe device
> > + * @param [in] func  0: PF, 1: VF0, ..., 15: VF14
> > + */
> > +u64  genwqe_read_jtimer(struct genwqe_dev *cd, int func);
> > +
> > +/* FFDC Buffer Management */
> > +int  genwqe_ffdc_buff_size(struct genwqe_dev *cd, int unit_id);
> > +int  genwqe_ffdc_buff_read(struct genwqe_dev *cd, int unit_id,
> > +			  struct genwqe_reg *regs, unsigned int max_regs);
> > +int  genwqe_read_ffdc_regs(struct genwqe_dev *cd, struct genwqe_reg *regs,
> > +			  unsigned int max_regs, int all);
> > +int genwqe_ffdc_dump_dma(struct genwqe_dev *cd,
> > +			 struct genwqe_reg *regs, unsigned int max_regs);
> > +
> > +int  genwqe_print_ffdc(struct genwqe_dev *cd);
> > +
> > +int  genwqe_init_debug_data(struct genwqe_dev *cd,
> > +			    struct genwqe_debug_data *d);
> > +
> > +void init_crc32(void);
> > +int  genwqe_read_app_id(struct genwqe_dev *cd, char *app_name, int len);
> > +
> > +/**< memory allocation/deallocation; dma address handling */
> > +int  user_vmap(struct genwqe_dev *cd, struct dma_mapping *m,
> > +	       void *uaddr, unsigned long size,
> > +	       struct ddcb_requ *req);
> > +
> > +int  user_vunmap(struct genwqe_dev *cd, struct dma_mapping *m,
> > +		 struct ddcb_requ *req);
> > +
> > +
> > +struct sg_entry *genwqe_alloc_sgl(struct genwqe_dev *cd, int num_pages,
> > +				 dma_addr_t *dma_addr, size_t *sgl_size);
> > +
> > +void genwqe_free_sgl(struct genwqe_dev *cd, struct sg_entry *sg_list,
> > +		    dma_addr_t dma_addr, size_t size);
> > +
> > +int genwqe_setup_sgl(struct genwqe_dev *cd,
> > +		    unsigned long offs,
> > +		    unsigned long size,
> > +		    struct sg_entry *sgl, /* genwqe sgl */
> > +		    dma_addr_t dma_addr, size_t sgl_size,
> > +		    dma_addr_t *dma_list, int page_offs, int num_pages);
> > +
> > +int genwqe_check_sgl(struct genwqe_dev *cd, struct sg_entry *sg_list,
> > +		     int size);
> > +
> > +static inline int dma_mapping_used(struct dma_mapping *m)
> 
> bool?

Sure.

> 
> > +{
> > +	if (!m)
> > +		return 0;
> > +	return (m->size != 0);
> > +}
> > +
> > +/**
> > + * This function will do the address translation changes to the DDCBs
> > + * according to the definitions required by the ATS field. It looks up
> > + * the memory allocation buffer or does vmap/vunmap for the respective
> > + * user-space buffers, inclusive page pinning and scatter gather list
> > + * buildup and teardown.
> > + */
> > +int  __genwqe_execute_ddcb(struct genwqe_dev *cd,
> > +			   struct genwqe_ddcb_cmd *cmd);
> > +
> > +/**
> > + * This version will not do address translation or any modifcation of
> > + * the DDCB data. It is used e.g. for the MoveFlash DDCB which is
> > + * entirely prepared by the driver itself. That means the appropriate
> > + * DMA addresses are already in the DDCB and do not need any
> > + * modification.
> > + */
> > +int  __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
> > +			       struct genwqe_ddcb_cmd *cmd);
> > +
> > +int  __genwqe_enqueue_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req);
> > +int  __genwqe_wait_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req);
> > +int  __genwqe_purge_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req);
> > +
> > +/** register access */
> > +int __genwqe_writeq(struct genwqe_dev *cd, u64 byte_offs, u64 val);
> > +u64 __genwqe_readq(struct genwqe_dev *cd, u64 byte_offs);
> > +int __genwqe_writel(struct genwqe_dev *cd, u64 byte_offs, u32 val);
> > +u32 __genwqe_readl(struct genwqe_dev *cd, u64 byte_offs);
> > +
> > +void *__genwqe_alloc_consistent(struct genwqe_dev *cd, size_t size,
> > +				 dma_addr_t *dma_handle);
> > +void __genwqe_free_consistent(struct genwqe_dev *cd, size_t size,
> > +			      void *vaddr, dma_addr_t dma_handle);
> > +
> > +/** base clock frequency in MHz */
> > +int  genwqe_base_clock_frequency(struct genwqe_dev *cd);
> > +
> > +/** before FFDC is captured the traps should be stopped. */
> > +void genwqe_stop_traps(struct genwqe_dev *cd);
> > +void genwqe_start_traps(struct genwqe_dev *cd);
> > +
> > +/* Hardware circumvention */
> > +int  genwqe_need_err_masking(struct genwqe_dev *cd);
> > +
> > +/**
> > + * On Intel with SRIOV support we see:
> > + *   PF: is_physfn = 1 is_virtfn = 0
> > + *   VF: is_physfn = 0 is_virtfn = 1
> > + *
> > + * On Systems with no SRIOV support _and_ virtualized systems we get:
> > + *       is_physfn = 0 is_virtfn = 0
> > + *
> > + * Other vendors have individual pci device ids to distinguish between
> > + * virtual function drivers and physical function drivers. GenWQE
> > + * unfortunately has just on pci device id for both, VFs and PF.
> > + *
> > + * The following code is used to distinguish if the card is running in
> > + * privileged mode, either as true PF or in a virtualized system with
> > + * full register access e.g. currently on PowerPC.
> > + *
> > + * if (pci_dev->is_virtfn)
> > + *          cd->is_privileged = 0;
> > + *  else
> > + *          cd->is_privileged = (__genwqe_readq(cd, IO_SLU_BITSTREAM)
> > + *				 != IO_ILLEGAL_VALUE);
> > + */
> > +static inline int genwqe_is_privileged(struct genwqe_dev *cd)
> > +{
> > +	return cd->is_privileged;
> > +}
> > +
> > +#endif	/* __CARD_BASE_H__ */
> > diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
> > new file mode 100644
> > index 0000000..66ba23f
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/card_ddcb.c
> > @@ -0,0 +1,1377 @@
> > +/**
> > + * IBM Accelerator Family 'GenWQE'
> > + *
> > + * (C) Copyright IBM Corp. 2013
> > + *
> > + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> > + * Author: Michael Jung <mijung@de.ibm.com>
> > + * Author: Michael Ruettger <michael@ibmra.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2, or (at your option)
> > + * any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +/**
> > + * Device Driver Control Block (DDCB) queue support. Definition of
> > + * interrupt handlers for queue support as well as triggering the
> > + * health monitor code in case of problems. The current hardware uses
> > + * an MSI interrupt which is shared between error handling and
> > + * functional code.
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <linux/module.h>
> > +#include <linux/sched.h>
> > +#include <linux/wait.h>
> > +#include <linux/pci.h>
> > +#include <linux/string.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/delay.h>
> > +#include <linux/module.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/crc-itu-t.h>
> > +
> > +#include "card_ddcb.h"
> > +
> > +/****************************************************************************/
> > +/** Service Layer Helpers						    */
> > +/****************************************************************************/
> > +
> > +/**
> > + * N: next DDCB, this is where the next DDCB will be put.
> > + * A: active DDCB, this is where the code will look for the next completion.
> > + * x: DDCB is enqueued, we are waiting for its completion.
> > +
> > + * Situation (1): Empty queue
> > + *  +---+---+---+---+---+---+---+---+
> > + *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
> > + *  |   |   |   |   |   |   |   |   |
> > + *  +---+---+---+---+---+---+---+---+
> > + *           A/N
> > + *  enqueued_ddcbs = A - N = 2 - 2 = 0
> > + *
> > + * Situation (2): Wrapped, N > A
> > + *  +---+---+---+---+---+---+---+---+
> > + *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
> > + *  |   |   | x | x |   |   |   |   |
> > + *  +---+---+---+---+---+---+---+---+
> > + *            A       N
> > + *  enqueued_ddcbs = N - A = 4 - 2 = 2
> > + *
> > + * Situation (3): Queue wrapped, A > N
> > + *  +---+---+---+---+---+---+---+---+
> > + *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
> > + *  | x | x |   |   | x | x | x | x |
> > + *  +---+---+---+---+---+---+---+---+
> > + *            N       A
> > + *  enqueued_ddcbs = queue_max  - (A - N) = 8 - (4 - 2) = 6
> > + *
> > + * Situation (4a): Queue full N > A
> > + *  +---+---+---+---+---+---+---+---+
> > + *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
> > + *  | x | x | x | x | x | x | x |   |
> > + *  +---+---+---+---+---+---+---+---+
> > + *    A                           N
> > + *
> > + *  enqueued_ddcbs = N - A = 7 - 0 = 7
> > + *
> > + * Situation (4a): Queue full A > N
> > + *  +---+---+---+---+---+---+---+---+
> > + *  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
> > + *  | x | x | x |   | x | x | x | x |
> > + *  +---+---+---+---+---+---+---+---+
> > + *                N   A
> > + *  enqueued_ddcbs = queue_max - (A - N) = 8 - (4 - 3) = 7
> > + */
> > +
> > +int queue_empty(struct ddcb_queue *queue)
> > +{
> > +	return (queue->ddcb_next == queue->ddcb_act);
> > +}
> > +
> > +int queue_enqueued_ddcbs(struct ddcb_queue *queue)
> > +{
> > +	if (queue->ddcb_next >= queue->ddcb_act)
> > +		return queue->ddcb_next - queue->ddcb_act;
> > +
> > +	return queue->ddcb_max - (queue->ddcb_act - queue->ddcb_next);
> > +}
> > +
> > +int queue_free_ddcbs(struct ddcb_queue *queue)
> > +{
> > +	int free_ddcbs = queue->ddcb_max - queue_enqueued_ddcbs(queue) - 1;
> > +
> > +	if (free_ddcbs < 0) {	/* must never ever happen! */
> 
> Maybe then:
> 
> 	if (WARN_ON(free_ddcbs < 0)) {

> Use WARN_ON_ONCE if this could potentially re-occur a lot (you don't
> want to spam the log if there is some persistent issue).
> 
Good idea. I added that. The static int count ... code I use elsewhere
is similar. There I changed the code using printk with rate-limit.

> 
> > +		return 0;
> > +	}
> > +	return free_ddcbs;
> > +}
> > +
> > +/**
> > + * Use of the PRIV field in the DDCB for queue debugging:
> > + *
> > + * (1) Trying to get rid of a DDCB which saw a timeout:
> > + *     pddcb->priv[6] = 0xcc;   # cleared
> > + *
> > + * (2) Append a DDCB via NEXT bit:
> > + *     pddcb->priv[7] = 0xaa;	# appended
> > + *
> > + * (3) DDCB needed tapping:
> > + *     pddcb->priv[7] = 0xbb;   # tapped
> > + *
> > + * (4) DDCB marked as correctly finished:
> > + *     pddcb->priv[6] = 0xff;	# finished
> > + */
> > +
> > +static inline void ddcb_mark_tapped(struct ddcb *pddcb)
> > +{
> > +	pddcb->priv[7] = 0xbb;  /* tapped */
> > +}
> > +
> > +static inline void ddcb_mark_appended(struct ddcb *pddcb)
> > +{
> > +	pddcb->priv[7] = 0xaa;	/* appended */
> > +}
> > +
> > +static inline void ddcb_mark_cleared(struct ddcb *pddcb)
> > +{
> > +	pddcb->priv[6] = 0xcc; /* cleared */
> > +}
> > +
> > +static inline void ddcb_mark_finished(struct ddcb *pddcb)
> > +{
> > +	pddcb->priv[6] = 0xff;	/* finished */
> > +}
> > +
> > +static inline void ddcb_mark_unused(struct ddcb *pddcb)
> > +{
> > +	pddcb->priv_64 = cpu_to_be64(0); /* not tapped */
> > +}
> > +
> > +/**
> > + * @brief	Generate 16-bit crc as required for DDCBs
> > + *		polynomial = x^16 + x^12 + x^5 + 1   (0x1021)
> > + *		- example:
> > + *		  4 bytes 0x01 0x02 0x03 0x04 with init = 0xffff
> > + *		  should result in a crc16 of 0x89c3
> > + *
> > + * @param	buff	pointer to data buffer
> > + * @param	len	length of data for calculation
> > + * @param	init	initial crc (0xffff at start)
> > + *
> > + * @return	crc16 checksum in big endian format !
> 
> Kernel function documentation uses kerneldoc, not doxygen. Please read:
> 
>    Documentation/kernel-doc-nano-HOWTO.txt

That was quite some work to change. I hope I found all spots where we
were using doxygen style docu. Might be a good idea to add some checking
in the scripts/checkpatch.pl script?

> 
> > + */
> > +static inline u16 genwqe_crc16(const u8 *buff, size_t len, u16 init)
> > +{
> > +	return crc_itu_t(init, buff, len);
> > +}
> > +
> > +/****************************************************************************/
> > +/** Service Layer Functions						    */
> > +/****************************************************************************/
> > +
> > +static void print_ddcb_info(struct genwqe_dev *cd, struct ddcb_queue *queue)
> > +{
> > +	int i;
> > +	struct ddcb *pddcb;
> > +	unsigned long flags;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	spin_lock_irqsave(&cd->print_lock, flags);
> > +
> > +	dev_info(&pci_dev->dev,
> > +		 "DDCB list for card #%d (ddcb_act=%d / ddcb_next=%d):\n",
> > +		 cd->card_idx, queue->ddcb_act, queue->ddcb_next);
> > +
> > +	pddcb = queue->ddcb_vaddr;
> > +	for (i = 0; i < queue->ddcb_max; i++) {
> > +		dev_err(&pci_dev->dev,
> > +			"  %c %-3d: RETC=%03x SEQ=%04x "
> > +			"HSI=%02X SHI=%02x PRIV=%06llx CMD=%03x\n",
> > +			i == queue->ddcb_act ? '>' : ' ',
> > +			i,
> > +			be16_to_cpu(pddcb->retc_16),
> > +			be16_to_cpu(pddcb->seqnum_16),
> > +			pddcb->hsi,
> > +			pddcb->shi,
> > +			be64_to_cpu(pddcb->priv_64),
> > +			pddcb->cmd);
> > +		pddcb++;
> > +	}
> > +	spin_unlock_irqrestore(&cd->print_lock, flags);
> > +}
> > +
> > +struct genwqe_ddcb_cmd *ddcb_requ_alloc(void)
> > +{
> > +	struct ddcb_requ *req;
> > +
> > +	req = kzalloc(sizeof(*req), GFP_ATOMIC);
> > +	if (!req)
> > +		return NULL;
> > +
> > +	return &req->cmd;
> > +}
> > +
> > +void ddcb_requ_free(struct genwqe_ddcb_cmd *cmd)
> > +{
> > +	struct ddcb_requ *req = container_of(cmd, struct ddcb_requ, cmd);
> > +	kfree(req);
> > +}
> > +
> > +/**
> > + * @brief	Returns the hardware state of the associated DDCB. The
> > + *		status of ddcb_requ mirrors this hardware state, but is
> > + *		copied in the ddcb_requ on interrupt/polling function.
> > + *		The lowlevel code should check the hardware state directly,
> > + *		the higher level code should check the copy.
> > + *
> > + *              This function will also return true if the state of
> > + *              the queue is not GENWQE_CARD_USED. This enables us to
> > + *              purge all DDCBs in the shutdown case.
> > + *
> > + * @param cd
> > + * @param req
> > + */
> > +int ddcb_requ_finished(struct genwqe_dev *cd, struct ddcb_requ *req)
> > +{
> > +	return ((ddcb_requ_get_state(req) == GENWQE_REQU_FINISHED) ||
> > +		(cd->card_state != GENWQE_CARD_USED));
> > +}
> > +
> > +/**
> > + * @brief	Start execution of DDCB by tapping or append to queue
> > + *              via NEXT bit. This is done by an atomic 'compare and swap'
> > + *              instruction and checking SHI and HSI of the previous DDCB.
> > + * @important	This function must only be called with ddcb_lock held!
> > + *
> > + * @param cd	pointer to genwqe device descriptor
> > + * @param queue	queue this operation should be done on
> > + * @param ddcb_no pointer to ddcb number being tapped
> > + *
> > + * @return	0 if simulated tapping
> > + *		1 if new DDCB is appended to previous
> > + *		2 if DDCB queue is tapped via register/simulation
> > + */
> > +static int enqueue_ddcb(struct genwqe_dev *cd,
> > +			struct ddcb_queue *queue,
> > +			struct ddcb *pddcb, int ddcb_no)
> > +{
> > +	unsigned int try;
> > +	int prev_no;
> > +	struct ddcb *prev_ddcb;
> > +	u32 old, new, icrc_hsi_shi;
> > +	u64 num;
> > +
> > +	/**
> > +	 * For performance checks a Dispatch Timestamp can be put into
> > +	 * DDCB It is supposed to use the SLU's free running counter,
> > +	 * but this requires PCIe cycles.
> > +	 */
> > +	ddcb_mark_unused(pddcb);
> > +
> > +	/* check previous DDCB if already fetched */
> > +	prev_no = (ddcb_no == 0) ? queue->ddcb_max - 1 : ddcb_no - 1;
> > +	prev_ddcb = &queue->ddcb_vaddr[prev_no];
> > +
> > +	/**
> > +	 * It might have happened that the HSI.FETCHED bit is
> > +	 * set. Retry in this case. Therefore I expect maximum 2 times
> > +	 * trying.
> > +	 */
> > +	ddcb_mark_appended(pddcb);
> > +	for (try = 0; try < 2; try++) {
> > +		old = prev_ddcb->icrc_hsi_shi_32; /* read SHI/HSI in BE32 */
> > +
> > +		/* try to append via NEXT bit if prev DDCB is not completed */
> > +		if ((old & DDCB_COMPLETED_BE32) != 0x00000000)
> > +			break;
> > +
> > +		new = (old | DDCB_NEXT_BE32);
> > +		icrc_hsi_shi = cmpxchg(&prev_ddcb->icrc_hsi_shi_32, old, new);
> > +
> > +		if (icrc_hsi_shi == old)
> > +			return 1; /* append to existing queue */
> > +		else
> > +			continue;
> 
> Remove the else continue. For loops do that automatically :-).
> 
> > +	}
> > +
> > +	/* Queue must be re-started by updating QUEUE_OFFSET */
> > +	ddcb_mark_tapped(pddcb);
> > +	num = (u64)ddcb_no << 8;
> > +	__genwqe_writeq(cd, queue->IO_QUEUE_OFFSET, num); /* start queue */
> > +	return 2;
> 
> #defines for the return values would make reading the callers easier.

Fixed it. I found that I do not really exploit the information. But the
code looks better now.

> 
> > +}
> > +
> > +/**
> > + * @brief	Waits until DDCB is completed
> > + *		The Service Layer will update the RETC in DDCB when
> > + *		processing is pending or done.
> > + *
> > + * @param cd [in]	pointer to genwqe device descriptor
> > + * @param req [inout]	pointer to requsted DDCB parameters
> > + *
> > + * @return	>0 remaining jiffies, DDCB completed
> > + *		-ETIMEDOUT	when timeout
> > + *		-ERESTARTSYS	when ^C
> > + *		-EINVAL		when unknown error condition
> > + *
> > + * When an error is returned the called needs to ensure that
> > + * purge_ddcb() is being called to get the &req removed from the
> > + * queue. If this is not done, and req is e.g. temporarilly allocated
> > + * on the stack, problems will occur.
> > + */
> > +int __genwqe_wait_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req)
> > +{
> > +	int rc;
> > +	unsigned int ddcb_no;
> > +	struct ddcb_queue *queue;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	if (req == NULL)
> > +		return -EINVAL;
> > +
> > +	queue = req->queue;
> > +	if (queue == NULL)
> > +		return -EINVAL;
> > +
> > +	ddcb_no = req->num;
> > +	if (ddcb_no >= queue->ddcb_max)
> > +		return -EINVAL;
> > +
> > +	rc = wait_event_interruptible_timeout(queue->ddcb_waitqs[ddcb_no],
> > +				ddcb_requ_finished(cd, req),
> > +				genwqe_ddcb_software_timeout * HZ);
> > +
> > +	/* We need to distinguish 3 cases here:
> > +	 *   1. rc == 0              timeout occured
> > +	 *   2. rc == -ERESTARTSYS   signal received
> > +	 *   3. rc > 0               remaining jiffies condition is true
> > +	 */
> > +	if (rc == 0) {
> > +		struct ddcb_queue *queue = req->queue;
> > +
> > +		/**
> > +		 * Timeout may be caused by long task switching of PCI
> > +		 * Support partition. When timeout happens, check if
> > +		 * the request has meanwhile completed. See ODT ticket
> > +		 * B3215
> > +		 */
> > +		genwqe_check_ddcb_queue(cd, req->queue);
> > +		if (ddcb_requ_finished(cd, req))
> > +			return rc;
> > +
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: DDCB#%d timeout rc=%d state=%d req @ %p\n",
> > +			__func__, req->num, rc,	ddcb_requ_get_state(req),
> > +			req);
> > +		dev_err(&pci_dev->dev,
> > +			"[%s]      IO_QUEUE_STATUS=0x%016llx\n", __func__,
> > +			__genwqe_readq(cd, queue->IO_QUEUE_STATUS));
> > +
> > +		if (genwqe_debug & dbg_card_ddcb) {
> > +			struct ddcb *pddcb = &queue->ddcb_vaddr[req->num];
> > +			genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
> > +		}
> > +		print_ddcb_info(cd, req->queue);
> > +		return -ETIMEDOUT;
> > +
> > +	} else if (rc == -ERESTARTSYS) {
> > +		return rc;	/* -EINTR; rc; */
> > +		/** EINTR: Stops the application */
> > +		/** ERESTARTSYS: Restartable systemcall; called again  */
> 
> Commented out code is messy. Put a proper comment, and remove the dead code.

Ok.

> 
> > +
> > +	} else if (rc < 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: DDCB#%d unknown result (rc=%d) %d!\n",
> > +			__func__, req->num, rc, ddcb_requ_get_state(req));
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Severe error occured. Driver is forced to stop operation */
> > +	if (cd->card_state != GENWQE_CARD_USED) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: DDCB#%d forced to stop (rc=%d)\n",
> > +			__func__, req->num, rc);
> > +		return -EIO;
> > +	}
> > +	return rc;
> > +}
> > +
> > +/**
> > + * @brief	Get next available DDCB
> > + *		DDCB's content is completely cleared but presets for
> > + *		PRE and SEQNUM.
> > + * @important	This function must only be called when ddcb_lock is held!
> > + *
> > + * @param cd	pointer to genwqe device descriptor.
> > + * @return	NULL if no empty DDCB available otherwise ptr to next DDCB.
> > + */
> > +static struct ddcb *get_next_ddcb(struct genwqe_dev *cd,
> > +				  struct ddcb_queue *queue,
> > +				  int *num)
> > +{
> > +	u64 *pu64;
> > +	struct ddcb *pddcb;
> > +
> > +	if (queue_free_ddcbs(queue) == 0) /* queue is  full */
> > +		return NULL;
> > +
> > +	/* find new ddcb */
> > +	pddcb = &queue->ddcb_vaddr[queue->ddcb_next];
> > +
> > +	/* if it is not completed, we are not allowed to use it */
> > +	/* barrier(); */
> > +	if ((pddcb->icrc_hsi_shi_32 & DDCB_COMPLETED_BE32) == 0x00000000)
> > +		return NULL;
> > +
> > +	*num = queue->ddcb_next;	/* internal DDCB number */
> > +	queue->ddcb_next = (queue->ddcb_next + 1) % queue->ddcb_max;
> > +
> > +	/* clear important DDCB fields */
> > +	pu64 = (u64 *)pddcb;
> > +	pu64[0] = 0ULL;		/* offs 0x00 (ICRC,HSI,SHI,...) */
> > +	pu64[1] = 0ULL;		/* offs 0x01 (ACFUNC,CMD...) */
> > +
> > +	/* destroy previous results in ASV */
> > +	pu64[0x80/8] = 0ULL;	/* offs 0x80 (ASV + 0) */
> > +	pu64[0x88/8] = 0ULL;	/* offs 0x88 (ASV + 0x08) */
> > +	pu64[0x90/8] = 0ULL;	/* offs 0x90 (ASV + 0x10) */
> > +	pu64[0x98/8] = 0ULL;	/* offs 0x98 (ASV + 0x18) */
> > +	pu64[0xd0/8] = 0ULL;	/* offs 0xd0 (RETC,ATTN...) */
> > +
> > +	pddcb->pre = DDCB_PRESET_PRE; /* 128 */
> > +	pddcb->seqnum_16 = cpu_to_be16(queue->ddcb_seq++);
> > +	return pddcb;
> > +}
> > +
> > +/**
> > + * @brief	Copy all output state from the real DDCB to the
> > + *		request data structure.
> > + *		This is needed by:
> > + *		- genwqe_purge_ddcb();
> > + *		- genwqe_check_ddcb_queue();
> > + */
> > +static void copy_ddcb_results(struct ddcb_requ *req, int ddcb_no)
> > +{
> > +	struct ddcb_queue *queue = req->queue;
> > +	struct ddcb *pddcb = &queue->ddcb_vaddr[req->num];
> > +
> > +	/* copy DDCB ASV to request struct */
> > +	/* there is no endian conversion made, since data structure */
> > +	/* in ASV is still unknown here */
> > +	memcpy(&req->cmd.asv[0], &pddcb->asv[0], DDCB_ASV_LENGTH);
> > +
> > +	/* copy status flags of the variant part */
> > +	req->cmd.vcrc     = be16_to_cpu(pddcb->vcrc_16);
> > +	req->cmd.deque_ts = be64_to_cpu(pddcb->deque_ts_64);
> > +	req->cmd.cmplt_ts = be64_to_cpu(pddcb->cmplt_ts_64);
> > +
> > +	req->cmd.attn     = be16_to_cpu(pddcb->attn_16);
> > +	req->cmd.progress = be32_to_cpu(pddcb->progress_32);
> > +	req->cmd.retc     = be16_to_cpu(pddcb->retc_16);
> > +
> > +	if (ddcb_requ_collect_debug_data(req)) {
> > +		int prev_no = (ddcb_no == 0) ?
> > +			queue->ddcb_max - 1 : ddcb_no - 1;
> > +		struct ddcb *prev_pddcb = &queue->ddcb_vaddr[prev_no];
> > +
> > +		memcpy(&req->debug_data.ddcb_finished, pddcb,
> > +		       sizeof(req->debug_data.ddcb_finished));
> > +		memcpy(&req->debug_data.ddcb_prev, prev_pddcb,
> > +		       sizeof(req->debug_data.ddcb_prev));
> > +	}
> > +}
> > +
> > +/**
> > + * @brief	Remove a DDCB from the workqueue. This will fail when the
> > + *		request was already FETCHED. In this case we need to wait
> > + *		until it is finished. Else the DDCB can be reused. This
> > + *		function also ensures that the request data structure is
> > + *		removed from ddcb_req[].
> > + *
> > + * @note	Please do not forget to call this function when
> > + *		genwqe_wait_ddcb() fails, such that the request gets really
> > + *		removed from ddcb_req[].
> > + *
> > + * @param cd	genwqe device descriptor
> > + * @param req	ddcb request
> > + *
> > + * @return	0 if success
> > + */
> > +int __genwqe_purge_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req)
> > +{
> > +	struct ddcb *pddcb = NULL;
> > +	unsigned int t;
> > +	unsigned long flags;
> > +	struct ddcb_queue *queue = req->queue;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	u32 icrc_hsi_shi = 0x0000;
> > +	u64 queue_status;
> > +	u32 old, new;
> > +
> > +	/* unsigned long flags; */
> > +	if (genwqe_ddcb_software_timeout <= 0) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: software timeout is not set!\n", __func__);
> > +		return -EFAULT;
> > +	}
> > +
> > +	pddcb = &queue->ddcb_vaddr[req->num];
> > +
> > +	for (t = 0; t < genwqe_ddcb_software_timeout * 10; t++) {
> > +
> > +		spin_lock_irqsave(&queue->ddcb_lock, flags);
> > +
> > +		/* Check if req was meanwhile finished */
> > +		if (ddcb_requ_get_state(req) == GENWQE_REQU_FINISHED)
> > +			goto go_home;
> > +
> > +		/* try to set PURGE bit if FETCHED/COMPLETED are not set */
> > +		old = pddcb->icrc_hsi_shi_32;	/* read SHI/HSI in BE32 */
> > +		if ((old & DDCB_FETCHED_BE32) == 0x00000000) {
> > +
> > +			new = (old | DDCB_PURGE_BE32);
> > +			icrc_hsi_shi = cmpxchg(&pddcb->icrc_hsi_shi_32,
> > +					       old, new);
> > +			if (icrc_hsi_shi == old)
> > +				goto finish_ddcb;
> > +		}
> > +
> > +		/* normal finish with HSI bit */
> > +		barrier();
> > +		icrc_hsi_shi = pddcb->icrc_hsi_shi_32;
> > +		if (icrc_hsi_shi & DDCB_COMPLETED_BE32)
> > +			goto finish_ddcb;
> > +
> > +		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +
> > +		/* NOTE: Here the check_ddcb() function will most
> > +		   likely discover this DDCB to be finished some point
> > +		   in time. It will mark the req finished and free it
> > +		   up in the list. */
> > +
> > +		copy_ddcb_results(req, req->num);  /* for the failing case */
> > +		msleep(1000/10); /* sleep for 1/10 second and try again */
> 
> msleep(100);
> 
Yes, ok.

> ?
> 
> > +		continue;
> > +
> > +finish_ddcb:
> > +		copy_ddcb_results(req, req->num);
> > +		ddcb_requ_set_state(req, GENWQE_REQU_FINISHED);
> > +		queue->ddcbs_in_flight--;
> > +		queue->ddcb_req[req->num] = NULL; /* delete from array */
> > +		ddcb_mark_cleared(pddcb);
> > +
> > +		/* Move active DDCB further; Nothing to do here anymore. */
> > +
> > +		/**
> > +		 * We need to ensure that there is at least one free
> > +		 * DDCB in the queue. To do that, we must update
> > +		 * ddcb_act only if the COMPLETED bit is set for the
> > +		 * DDCB we are working on else we treat that DDCB even
> > +		 * if we PURGED it as occupied (hardware is supposed
> > +		 * to set the COMPLETED bit yet!).
> > +		 */
> > +		icrc_hsi_shi = pddcb->icrc_hsi_shi_32;
> > +		if ((icrc_hsi_shi & DDCB_COMPLETED_BE32) &&
> > +		    (queue->ddcb_act == req->num)) {
> > +			queue->ddcb_act = ((queue->ddcb_act + 1) %
> > +					   queue->ddcb_max);
> > +		}
> > +go_home:
> > +		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +		return 0;
> > +	}
> > +
> > +	/* FIXME If the card is dead and the queue is forced to stop
> > +	   we might see this in the queue status register; check with
> > +	   hardware designers */
> > +	queue_status = __genwqe_readq(cd, queue->IO_QUEUE_STATUS);
> > +
> > +	if (genwqe_debug & dbg_card_ddcb) {
> > +		dbg_printk(cd, dbg_card_ddcb, "UN/FINISHED DDCB#%d\n",
> > +			   req->num);
> > +		genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
> > +	}
> > +	dev_err(&pci_dev->dev,
> > +		"[%s] err: DDCB#%d not purged and not completed "
> > +		"after %d seconds QSTAT=%016llx!!\n",
> > +		__func__, req->num, genwqe_ddcb_software_timeout,
> > +		queue_status);
> > +
> > +	print_ddcb_info(cd, req->queue);
> > +
> > +	return -EFAULT;
> > +}
> > +
> > +int genwqe_init_debug_data(struct genwqe_dev *cd, struct genwqe_debug_data *d)
> > +{
> > +	int len;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	if (d == NULL) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] err: invalid memory for debug data!\n",
> > +			__func__);
> > +		return -EFAULT;
> > +	}
> > +
> > +	len  = sizeof(d->driver_version);
> > +	snprintf(d->driver_version, len - 1, "%s", DRV_VERS_STRING);
> > +	d->driver_version[len - 1] = 0;
> 
> snprintf always writes a NUL terminator, so you can pass len as the
> size, and remove the explicit NUL terminator. Alternatively, replace it
> with strncpy and keep the explicit NUL terminator.
> 
> > +	d->slu_unitcfg = cd->slu_unitcfg;
> > +	d->app_unitcfg = cd->app_unitcfg;
> > +	return 0;
> > +}
> > +
> > +/**
> > + * @brief		client interface
> > + *			append new DDCB to queue list
> > + *
> > + * @param cd		pointer to genwqe device descriptor
> > + * @param req		pointer to requsted DDCB parameters
> > + *
> > + * @return		0	if enqueuing succeeded
> > + *                      -EIO    if card is unusable/PCIe problems
> > + *			-EBUSY	if enqueuing failed
> 
> Indentation is weird here, you have mixed tabs and spaces.

This should all be gone now by the change to the kernel doc format.

> 
> > + */
> > +int __genwqe_enqueue_ddcb(struct genwqe_dev *cd, struct ddcb_requ *req)
> > +{
> > +	struct ddcb *pddcb;
> > +	unsigned long flags;
> > +	struct ddcb_queue *queue;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	u16 icrc;
> > +
> > +	if (cd->card_state != GENWQE_CARD_USED) {
> > +		static int count;
> > +
> > +		if (count++ < 20)
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] Card is unusable/PCIe problem Req#%d\n",
> > +				__func__, req->num);
> 
> A printk_once or rate-limited printk is probably better than doing this?

I added the rate-limited prink. I needed to add GENWQE_DEVNAME,
dev_name(&pci_dev->dev), such that I can figure out which of my cards
has a problem. I did not find a dev_err_rate_limited()?

I had multiple spots where I used the static int count. I replaced them
all.

> 
> > +
> > +		return -EIO;
> > +	}
> > +
> > +	queue = req->queue = &cd->queue;
> > +
> > +	/* FIXME circumvention to improve performance when no irq is
> > +	 * there.
> > +	 */
> > +	if (genwqe_polling_enabled)
> > +		genwqe_check_ddcb_queue(cd, queue);
> > +
> > +	/**
> > +	 * It must be ensured to process all DDCBs in successive
> > +	 * order. Use a lock here in order to prevent nested DDCB
> > +	 * enqueuing.
> > +	 */
> > +	spin_lock_irqsave(&queue->ddcb_lock, flags);
> > +
> > +	pddcb = get_next_ddcb(cd, queue, &req->num);	/* get ptr and num */
> > +	if (pddcb == NULL) {
> > +		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +		queue->busy++;
> > +		return -EBUSY;
> > +	}
> > +
> > +	if (queue->ddcb_req[req->num] != NULL) {
> > +		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] picked DDCB %d with req=%p still in use!!\n",
> > +			__func__, req->num, req);
> > +		return -EFAULT;
> > +	}
> > +	ddcb_requ_set_state(req, GENWQE_REQU_ENQUEUED);
> > +	queue->ddcb_req[req->num] = req;
> > +
> > +	pddcb->cmdopts_16 = cpu_to_be16(req->cmd.cmdopts);
> > +	pddcb->cmd = req->cmd.cmd;
> > +	pddcb->acfunc = req->cmd.acfunc;	/* functional unit */
> > +
> > +	/**
> > +	 * We know that we can get retc 0x104 with CRC error, do not
> > +	 * stop the queue in those cases for this command. XDIR = 1
> > +	 * does not work for old SLU versions.
> > +	 *
> > +	 * Last bitstream with the old XDIR behavior had SLU_ID
> > +	 * 0x34199.
> > +	 */
> > +	if ((cd->slu_unitcfg & 0xFFFF0ull) > 0x34199ull)
> > +		pddcb->xdir = 0x1;
> > +	else
> > +		pddcb->xdir = 0x0;
> > +
> > +
> > +	pddcb->psp = (((req->cmd.asiv_length / 8) << 4) |
> > +		      ((req->cmd.asv_length  / 8)));
> > +	pddcb->disp_ts_64 = cpu_to_be64(req->cmd.disp_ts);
> > +
> > +	/* NOTE: If copying the whole DDCB_ASIV_LENGTH is impacting
> > +	 * performance we need to change it to req->cmd.asiv_length. But
> > +	 * simulation benefits from some non-architectured bits behind
> > +	 * the architectured content.
> > +	 *
> > +	 * NOTE: how much data is copied depends on the availability
> > +	 * of the ATS field, which was introduced late. If the ATS
> > +	 * field is supported ASIV is 8 bytes shorter than it used to
> > +	 * be. Since the ATS field is copied too, the code should do
> > +	 * exactly what it did before, but I wanted to make copying of
> > +	 * the ATS field very explicit.
> > +	 */
> > +	if (genwqe_get_slu_id(cd) <= 0x2) {
> > +		memcpy(&pddcb->__asiv[0],	/* destination */
> > +		       &req->cmd.__asiv[0],	/* source */
> > +		       DDCB_ASIV_LENGTH);	/* req->cmd.asiv_length */
> > +	} else {
> > +		pddcb->n.ats_64 = req->cmd.ats;
> > +		memcpy(&pddcb->n.asiv[0],		/* destination */
> > +			&req->cmd.asiv[0],	/* source */
> > +			DDCB_ASIV_LENGTH_ATS);	/* req->cmd.asiv_length */
> > +	}
> > +
> > +	pddcb->icrc_hsi_shi_32 = cpu_to_be32(0x00000000); /* for crc */
> > +
> > +	/**
> > +	 * Calculate CRC_16 for corresponding range PSP(7:4). Include
> > +	 * empty 4 bytes prior to the data.
> > +	 */
> > +	icrc = genwqe_crc16((const u8 *)pddcb,
> > +			   ICRC_LENGTH(req->cmd.asiv_length), 0xffff);
> > +	pddcb->icrc_hsi_shi_32 = cpu_to_be32((u32)icrc << 16);
> > +
> > +	/* enable DDCB completion irq */
> > +	if (!genwqe_polling_enabled)
> > +		pddcb->icrc_hsi_shi_32 |= DDCB_INTR_BE32;
> > +
> > +	if (genwqe_debug & dbg_card_ddcb) {
> > +		dbg_printk(cd, dbg_card_ddcb, "INPUT DDCB#%d\n", req->num);
> > +		genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
> > +	}
> > +
> > +	if (ddcb_requ_collect_debug_data(req)) {
> > +		/* use the kernel copy of debug data. copying back to
> > +		   user buffer happens later */
> > +
> > +		genwqe_init_debug_data(cd, &req->debug_data);
> > +		memcpy(&req->debug_data.ddcb_before, pddcb,
> > +		       sizeof(req->debug_data.ddcb_before));
> > +	}
> > +
> > +	enqueue_ddcb(cd, queue, pddcb, req->num);
> > +	queue->ddcbs_in_flight++;
> > +
> > +	if (queue->ddcbs_in_flight > queue->ddcbs_max_in_flight)
> > +		queue->ddcbs_max_in_flight = queue->ddcbs_in_flight;
> > +
> > +	ddcb_requ_set_state(req, GENWQE_REQU_TAPPED);
> > +	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +	wake_up_interruptible(&cd->queue_waitq);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * @brief		setup and execute an ECH DDCB for SLU processing
> > + * @note		Gets called via IOCTL.
> > + *
> > + * @param cd		pointer to genwqe device descriptor
> > + * @param req		user provided parameter set
> > + */
> > +int __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
> > +			     struct genwqe_ddcb_cmd *cmd)
> > +{
> > +	int rc = 0;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	struct ddcb_requ *req = container_of(cmd, struct ddcb_requ, cmd);
> > +
> > +	if (cmd->asiv_length > DDCB_ASIV_LENGTH) {
> > +		dev_err(&pci_dev->dev, "[%s] err: wrong asiv_length of %d\n",
> > +			__func__, cmd->asiv_length);
> > +		return -EINVAL;
> > +	}
> > +	if (cmd->asv_length > DDCB_ASV_LENGTH) {
> > +		dev_err(&pci_dev->dev, "[%s] err: wrong asv_length of %d\n",
> > +			__func__, cmd->asiv_length);
> > +		return -EINVAL;
> > +	}
> > +	rc = __genwqe_enqueue_ddcb(cd, req);
> > +	if (rc != 0)
> > +		return rc;
> > +
> > +	rc = __genwqe_wait_ddcb(cd, req);
> > +	if (rc < 0)		/* error or signal interrupt */
> > +		goto err_exit;
> > +
> > +	if (ddcb_requ_collect_debug_data(req)) {
> > +		if (copy_to_user(cmd->debug_data, &req->debug_data,
> > +				 sizeof(*cmd->debug_data))) {
> > +			dev_warn(&pci_dev->dev,
> > +				 "warn: could not copy debug data to user!\n");
> 
> Why doesn't this return an error to the user?
> 
> Probably get rid of the warning too, since it would be easy for a user
> to trigger it (just call with an invalid dest address), which allows
> users to use this code-path to spam the system log.

I changed it to return an error.

> 
> > +		}
> > +	}
> > +
> > +	/**
> > +	 * Higher values than 0x102 indicate completion with faults,
> > +	 * lower values than 0x102 indicate processing faults. Note
> > +	 * that DDCB might have been purged. E.g. Cntl+C.
> > +	 */
> > +	if (cmd->retc != DDCB_RETC_COMPLETE) {
> > +		/* This might happen e.g. flash read, and needs to be
> > +		   handled by the upper layer code. */
> > +		rc = -EBADMSG;	/* not processed/error retc */
> > +	}
> > +
> > +	return rc;
> > +
> > + err_exit:
> > +	__genwqe_purge_ddcb(cd, req);
> > +
> > +	if (ddcb_requ_collect_debug_data(req)) {
> > +		if (copy_to_user(cmd->debug_data, &req->debug_data,
> > +				 sizeof(*cmd->debug_data))) {
> > +			dev_warn(&pci_dev->dev,
> > +				 "warn: could not copy debug data to user!\n");
> > +		}
> > +	}
> > +	return rc;
> > +}
> > +
> > +/**
> > + * Figure out if the next DDCB is already finished. We need this as
> > + * condition for our wait-queue code.
> > + */
> > +int genwqe_next_ddcb_ready(struct genwqe_dev *cd)
> > +{
> > +	unsigned long flags;
> > +	struct ddcb *pddcb;
> > +	struct ddcb_queue *queue = &cd->queue;
> > +
> > +	spin_lock_irqsave(&queue->ddcb_lock, flags);
> 
> Does all the locking need to be irqsave? If you know the context the
> functions are called in then you should be using spin_lock,
> spin_lock_irq, etc. spin_lock_irqsave should only be used for functions
> which are called with an unknown interrupt enabled state.
> 

I think some time ago we had code which was modifying the queue within
our interrupt handler. I got rid of that and use a kernel thread now
with a wait queue which is woken up whenever work is there. Therefore
you are right, and I could use spin_lock() instead, although I have not
tried it yet. I hope you don't mind if I for the moment keep the irqsafe
variant. As Documentation/spinlocks.txt says: "The above is always
safe". But I will keep your comment in mind when thinking about
performance improvements.

> > +
> > +	if (queue_empty(queue)) { /* emtpy queue */
> > +		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +		return 0;
> > +	}
> > +
> > +	pddcb = &queue->ddcb_vaddr[queue->ddcb_act];
> > +	if (pddcb->icrc_hsi_shi_32 & DDCB_COMPLETED_BE32) { /* ddcb ready */
> > +		spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +		return 1;
> > +	}
> > +
> > +	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * Keep track on the number of DDCBs which ware currently in the
> > + * queue. This is needed for statistics as well as conditon if we want
> > + * to wait or better do polling in case of no interrupts available.
> > + */
> > +int genwqe_ddcbs_in_flight(struct genwqe_dev *cd)
> > +{
> > +	unsigned long flags;
> > +	int ddcbs_in_flight = 0;
> > +	struct ddcb_queue *queue = &cd->queue;
> > +
> > +	spin_lock_irqsave(&queue->ddcb_lock, flags);
> > +	ddcbs_in_flight += queue->ddcbs_in_flight;
> > +	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +
> > +	return ddcbs_in_flight;
> > +}
> > +
> > +/**
> > + * @brief	This function checks the DDCB queue for completed work
> > + *		requests. When a completed request is found, we use the
> > + *		request struct to inform the requestor.
> > + *
> > + * FIXME If in a two CPU system, one fills the queue and the other
> > + * handles the interrupt, it might occur that the interrupt is never
> > + * exited. This might lead to problems on that CPU where other
> > + * processes will starve.
> > + *
> > + * @param cd	pointer to genwqe device descriptor
> > + * @return      number of DDCBs which were finished
> > + */
> > +int genwqe_check_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
> > +{
> > +	unsigned long flags;
> > +	int ddcbs_finished = 0;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	spin_lock_irqsave(&queue->ddcb_lock, flags);
> > +
> > +	/* FIXME avoid soft locking CPU */
> > +	while (!queue_empty(queue) && (ddcbs_finished < queue->ddcb_max)) {
> > +
> > +		struct ddcb *pddcb;
> > +		struct ddcb_requ *req;
> > +		u16 vcrc, vcrc_16, retc_16;
> > +
> > +		pddcb = &queue->ddcb_vaddr[queue->ddcb_act];
> > +
> > +		if ((pddcb->icrc_hsi_shi_32 & DDCB_COMPLETED_BE32) ==
> > +		    0x00000000)
> > +			goto go_home; /* not completed, continue waiting */
> > +
> > +		/* Note: DDCB could be purged */
> > +
> > +		req = queue->ddcb_req[queue->ddcb_act];
> > +		if (req == NULL) {
> > +			/* this occurs if DDCB is purged, not an error */
> > +			/* Move active DDCB further; Nothing to do anymore. */
> > +			goto pick_next_one;
> > +		}
> > +
> > +		/**
> > +		 * HSI=0x44 (fetched and completed), but RETC is
> > +		 * 0x101, or even worse 0x000.
> > +		 *
> > +		 * In case of seeing the queue in inconsistent state
> > +		 * we read the errcnts and the queue status to provide
> > +		 * a trigger for our PCIe analyzer stop capturing.
> > +		 */
> > +		retc_16 = be16_to_cpu(pddcb->retc_16);
> > +		if ((pddcb->hsi == 0x44) && (retc_16 <= 0x101)) {
> > +			u64 errcnts, status;
> > +			u64 ddcb_offs = (u64)pddcb - (u64)queue->ddcb_vaddr;
> > +
> > +			errcnts = __genwqe_readq(cd, queue->IO_QUEUE_ERRCNTS);
> > +			status  = __genwqe_readq(cd, queue->IO_QUEUE_STATUS);
> > +
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] SEQN=%04x HSI=%02x RETC=%03x "
> > +				" Q_ERRCNTS=%016llx Q_STATUS=%016llx\n"
> > +				" DDCB_DMA_ADDR=%016llx\n",
> > +				__func__, be16_to_cpu(pddcb->seqnum_16),
> > +				pddcb->hsi, retc_16, errcnts, status,
> > +				queue->ddcb_daddr + ddcb_offs);
> > +		}
> > +
> > +		copy_ddcb_results(req, queue->ddcb_act);
> > +		queue->ddcb_req[queue->ddcb_act] = NULL; /* take from queue */
> > +
> > +		if (genwqe_debug & dbg_card_ddcb) {
> > +			dbg_printk(cd, dbg_card_ddcb, "FINISHED DDCB#%d\n",
> > +				   req->num);
> > +			genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
> > +		}
> > +
> > +		ddcb_mark_finished(pddcb);
> > +
> > +		/* calculate CRC_16 to see if VCRC is correct */
> > +		vcrc = genwqe_crc16(pddcb->asv,
> > +				   VCRC_LENGTH(req->cmd.asv_length),
> > +				   0xffff);
> > +		vcrc_16 = be16_to_cpu(pddcb->vcrc_16);
> > +		if (vcrc != vcrc_16) {
> > +			static int count;
> > +
> > +			if (count++ < 5)
> > +				dev_err(&pci_dev->dev,
> > +					"err: wrong VCRC pre=%02x vcrc_len=%d "
> > +					"bytes vcrc_data=%04x is not "
> > +					"vcrc_card=%04x\n",
> > +					pddcb->pre,
> > +					VCRC_LENGTH(req->cmd.asv_length),
> > +					vcrc, vcrc_16);
> 
> printk_once or rate-limited?

Good idea. See above comment.

> 
> > +		}
> > +
> > +		ddcb_requ_set_state(req, GENWQE_REQU_FINISHED);
> > +		queue->ddcbs_completed++;
> > +		queue->ddcbs_in_flight--;
> > +
> > +		/* wake up process waiting for this DDCB */
> > +		wake_up_interruptible(&queue->ddcb_waitqs[queue->ddcb_act]);
> > +
> > +pick_next_one:
> > +		queue->ddcb_act = (queue->ddcb_act + 1) % queue->ddcb_max;
> > +		ddcbs_finished++;
> > +	}
> > +
> > + go_home:
> > +	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +	return ddcbs_finished;
> > +}
> > +
> > +static int setup_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
> > +{
> > +	int rc, i;
> > +	struct ddcb *pddcb;
> > +	u64 val64;
> > +	unsigned int queue_size;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	if (genwqe_ddcb_max < 2)
> > +		return -EINVAL;
> > +
> > +	queue_size = roundup(genwqe_ddcb_max * sizeof(struct ddcb), PAGE_SIZE);
> > +
> > +	queue->ddcbs_in_flight = 0;  /* statistics */
> > +	queue->ddcbs_max_in_flight = 0;
> > +	queue->ddcbs_completed = 0;
> > +	queue->busy = 0;
> > +
> > +	queue->ddcb_seq	  = 0x100; /* start sequence number */
> > +	queue->ddcb_max	  = genwqe_ddcb_max; /* module parameter */
> > +	queue->ddcb_vaddr = __genwqe_alloc_consistent(cd, queue_size,
> > +						&queue->ddcb_daddr);
> > +	if (queue->ddcb_vaddr == NULL) {
> > +		dev_err(&pci_dev->dev,
> > +			"[%s] **err: could not allocate DDCB **\n", __func__);
> > +		return -ENOMEM;
> > +	}
> > +	memset(queue->ddcb_vaddr, 0, queue_size);
> > +
> > +	queue->ddcb_req = kzalloc(sizeof(struct ddcb_requ *) *
> > +				  queue->ddcb_max, GFP_KERNEL);
> > +	if (!queue->ddcb_req) {
> > +		rc = -ENOMEM;
> > +		goto free_ddcbs;
> > +	}
> > +
> > +	queue->ddcb_waitqs = kzalloc(sizeof(wait_queue_head_t) *
> > +				     queue->ddcb_max, GFP_KERNEL);
> > +	if (!queue->ddcb_waitqs) {
> > +		rc = -ENOMEM;
> > +		goto free_requs;
> > +	}
> > +
> > +	for (i = 0; i < queue->ddcb_max; i++) {
> > +		pddcb = &queue->ddcb_vaddr[i];		     /* DDCBs */
> > +		pddcb->icrc_hsi_shi_32 = DDCB_COMPLETED_BE32;
> > +		pddcb->retc_16 = cpu_to_be16(0xfff);
> > +
> > +		queue->ddcb_req[i] = NULL;		     /* requests */
> > +		init_waitqueue_head(&queue->ddcb_waitqs[i]); /* waitqueues */
> > +	}
> > +
> > +	queue->ddcb_act  = 0;
> > +	queue->ddcb_next = 0;	/* queue is empty */
> > +
> > +	spin_lock_init(&queue->ddcb_lock);
> > +	init_waitqueue_head(&queue->ddcb_waitq);
> > +
> > +	val64 = ((u64)(queue->ddcb_max - 1) <<  8); /* lastptr */
> > +	__genwqe_writeq(cd, queue->IO_QUEUE_CONFIG,  0x07);  /* iCRC/vCRC */
> > +	__genwqe_writeq(cd, queue->IO_QUEUE_SEGMENT, queue->ddcb_daddr);
> > +	__genwqe_writeq(cd, queue->IO_QUEUE_INITSQN, queue->ddcb_seq);
> > +	__genwqe_writeq(cd, queue->IO_QUEUE_WRAP,    val64);
> > +	return 0;
> > +
> > + free_requs:
> > +	kfree(queue->ddcb_req);
> > +	queue->ddcb_req = NULL;
> > + free_ddcbs:
> > +	__genwqe_free_consistent(cd, queue_size, queue->ddcb_vaddr,
> > +				queue->ddcb_daddr);
> > +	queue->ddcb_vaddr = NULL;
> > +	queue->ddcb_daddr = 0ull;
> > +	return -ENODEV;
> > +
> > +}
> > +
> > +static int ddcb_queue_initialized(struct ddcb_queue *queue)
> > +{
> > +	return (queue->ddcb_vaddr != NULL);
> > +}
> > +
> > +static void free_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
> > +{
> > +	unsigned int queue_size;
> > +
> > +	queue_size = roundup(queue->ddcb_max * sizeof(struct ddcb), PAGE_SIZE);
> > +
> > +	kfree(queue->ddcb_req);
> > +	queue->ddcb_req = NULL;
> > +
> > +	if (queue->ddcb_vaddr) {
> > +		__genwqe_free_consistent(cd, queue_size, queue->ddcb_vaddr,
> > +					queue->ddcb_daddr);
> > +		queue->ddcb_vaddr = NULL;
> > +		queue->ddcb_daddr = 0ull;
> > +	}
> > +}
> > +
> > +static irqreturn_t genwqe_pf_isr(int irq, void *dev_id)
> > +{
> > +	u64 gfir;
> > +	struct genwqe_dev *cd = (struct genwqe_dev *)dev_id;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	static int count;
> > +
> > +	/**
> > +	 * In case of fatal FIR error the queue is stopped, such that
> > +	 * we can safely check it without risking anything.
> > +	 */
> > +	cd->irqs_processed++;
> > +	wake_up_interruptible(&cd->queue_waitq);
> > +
> > +	/**
> > +	 * Checking for errors before kicking the queue might be
> > +	 * safer, but slower for the good-case ... See above.
> > +	 */
> > +	gfir = __genwqe_readq(cd, IO_SLC_CFGREG_GFIR);
> > +	if ((gfir & GFIR_ERR_TRIGGER) != 0x0) {
> > +
> > +		wake_up_interruptible(&cd->health_waitq);
> > +
> > +		/* By default GFIRs causes recovery actions.
> > +		   This count is just for debug when recovery is masked */
> > +		if (count++ < 20) {
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] GFIR=%016llx\n", __func__, gfir);
> > +		}
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static irqreturn_t genwqe_vf_isr(int irq, void *dev_id)
> > +{
> > +	struct genwqe_dev *cd = (struct genwqe_dev *)dev_id;
> > +
> > +	cd->irqs_processed++;
> > +	wake_up_interruptible(&cd->queue_waitq);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +/**
> > + * The idea is to check if there are DDCBs in processing. If so, we do
> > + * a short wait using cond_resched(). That should still allow others
> > + * to do work.
> > + *
> > + * If there is no work to do we check every timer tick. To get out of
> > + * this wait, we have the tap_ddcb() function kick the queue_waitq
> > + * such that we drop out of this wait and are able to adjust the wait
> > + * time when DDCBs are in flight.
> > + */
> > +static int genwqe_card_thread(void *data)
> > +{
> > +	int should_stop = 0, rc = 0;
> > +	struct genwqe_dev *cd = (struct genwqe_dev *)data;
> > +
> > +	while (!kthread_should_stop()) {
> > +
> > +		genwqe_check_ddcb_queue(cd, &cd->queue);
> > +		if (genwqe_polling_enabled) {
> > +			rc = wait_event_interruptible_timeout(
> > +				cd->queue_waitq,
> > +				genwqe_ddcbs_in_flight(cd) ||
> > +				(should_stop = kthread_should_stop()), 1);
> 
> Timeout of 1 is odd, it will vary depending on HZ.

This kind of fast polling is not used under normal circumstances. I kept
it in the code for the case that someone has problems with interrupts.
For this case I thought that polling once per timer tick is ensuring
that we can run operations. They will not perform well of course because
polling faster caused the system load to explode.

> 
> > +		} else {
> > +			rc = wait_event_interruptible_timeout(
> > +				cd->queue_waitq,
> > +				genwqe_next_ddcb_ready(cd) ||
> > +				(should_stop = kthread_should_stop()), HZ);
> > +		}
> > +		if (should_stop)
> > +			break;
> > +
> > +		/* avoid soft lockups on heavy loads; we do not want
> > +		   to disable our interrupts */
> > +		cond_resched();
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * @brief	setup DDCBs for service layer of Physical Function
> > + *		- allocate DDCBs
> > + *		- configure Service Layer Controller (SLC)
> > + *
> > + * @param cd	pointer to genwqe device descriptor
> > + * @return	0 if success
> > + */
> > +int genwqe_setup_service_layer(struct genwqe_dev *cd)
> > +{
> > +	int rc;
> > +	struct ddcb_queue *queue;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	/* reset the card ****************************************************/
> > +	if (!genwqe_skip_reset && genwqe_is_privileged(cd)) {
> > +		rc = genwqe_card_reset(cd);	/* RESET CARD!! */
> > +		if (rc < 0) {
> > +			dev_err(&pci_dev->dev,
> > +				"[%s] err: reset failed.\n", __func__);
> > +			return rc;
> > +		}
> > +		genwqe_read_softreset(cd);
> > +	}
> > +
> > +	/* Setup the DDCB queue **********************************************/
> > +	queue = &cd->queue;
> > +	queue->IO_QUEUE_CONFIG  = IO_SLC_QUEUE_CONFIG;
> > +	queue->IO_QUEUE_STATUS  = IO_SLC_QUEUE_STATUS;
> > +	queue->IO_QUEUE_SEGMENT = IO_SLC_QUEUE_SEGMENT;
> > +	queue->IO_QUEUE_INITSQN = IO_SLC_QUEUE_INITSQN;
> > +	queue->IO_QUEUE_OFFSET  = IO_SLC_QUEUE_OFFSET;
> > +	queue->IO_QUEUE_WRAP    = IO_SLC_QUEUE_WRAP;
> > +	queue->IO_QUEUE_WTIME   = IO_SLC_QUEUE_WTIME;
> > +	queue->IO_QUEUE_ERRCNTS = IO_SLC_QUEUE_ERRCNTS;
> > +	queue->IO_QUEUE_LRW     = IO_SLC_QUEUE_LRW;
> > +
> > +	rc = setup_ddcb_queue(cd, queue);
> > +	if (rc != 0) {
> > +		rc = -ENODEV;
> > +		goto err_out;
> > +	}
> > +
> > +	/* start genwqe maintenance thread ***********************************/
> 
> What's with all the trailing *'s?

I thought they look nicely. I removed them such that all comments look
similar now.

> 
> > +	init_waitqueue_head(&cd->queue_waitq);
> > +	cd->card_thread = kthread_run(genwqe_card_thread, cd,
> > +				      GENWQE_DEVNAME "%d_thread",
> > +				      cd->card_idx);
> > +	if (IS_ERR(cd->card_thread)) {
> > +		rc = PTR_ERR(cd->card_thread);
> > +		cd->card_thread = NULL;
> > +		goto stop_free_queue;
> > +	}
> > +
> > +	/* Interrupt enablement **********************************************/
> > +	rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
> > +	if (rc > 0)
> > +		rc = genwqe_set_interrupt_capability(cd, rc);
> > +	if (rc != 0) {
> > +		rc = -ENODEV;
> > +		goto stop_kthread;
> > +	}
> > +
> > +	/**
> > +	 * We must have all wait-queues initialized when we enable the
> > +	 * interrupts. Otherwise we might crash if we get an early
> > +	 * irq.
> > +	 */
> > +	init_waitqueue_head(&cd->health_waitq);
> > +
> > +	if (genwqe_is_privileged(cd)) {
> > +		rc = request_irq(pci_dev->irq, genwqe_pf_isr, IRQF_SHARED,
> > +				 GENWQE_DEVNAME, cd);
> > +	} else {
> > +		rc = request_irq(pci_dev->irq, genwqe_vf_isr, IRQF_SHARED,
> > +				 GENWQE_DEVNAME, cd);
> > +	}
> > +	if (rc < 0) {
> > +		dev_err(&pci_dev->dev, "irq %d not free.\n", pci_dev->irq);
> > +		goto stop_irq_cap;
> > +	}
> > +
> > +	cd->card_state = GENWQE_CARD_USED;
> > +	return 0;
> > +
> > + stop_irq_cap:
> > +	genwqe_reset_interrupt_capability(cd);
> > + stop_kthread:
> > +	kthread_stop(cd->card_thread); /* stop maintenance thread */
> > +	cd->card_thread = NULL;
> > + stop_free_queue:
> > +	free_ddcb_queue(cd, queue);
> > + err_out:
> > +	return rc;
> > +}
> > +
> > +/**
> > + * This function is for the fatal error case. The PCI device got
> > + * unusable and we have to stop all pending requests as fast as we
> > + * can. The code after this must purge the DDCBs in question and
> > + * ensure that all mappings are freed.
> > + */
> > +static int queue_wake_up_all(struct genwqe_dev *cd)
> > +{
> > +	unsigned int i;
> > +	unsigned long flags;
> > +	struct ddcb_queue *queue = &cd->queue;
> > +
> > +	spin_lock_irqsave(&queue->ddcb_lock, flags);
> > +
> > +	for (i = 0; i < queue->ddcb_max; i++)
> > +		wake_up_interruptible(&queue->ddcb_waitqs[queue->ddcb_act]);
> > +
> > +	spin_unlock_irqrestore(&queue->ddcb_lock, flags);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * @brief This function will remove any genwqe devices and
> > + * user-interfaces but it relies on the pre-condition that there are
> > + * no users of the card device anymore e.g. with open
> > + * file-descriptors.
> > + *
> > + * @note This function must be robust enough to be called twice.
> > + */
> > +int genwqe_finish_queue(struct genwqe_dev *cd)
> > +{
> > +	int i, rc, in_flight;
> > +	int waitmax = genwqe_ddcb_software_timeout;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +	struct ddcb_queue *queue = &cd->queue;
> > +
> > +	if (!ddcb_queue_initialized(queue))
> > +		return 0;
> > +
> > +	/* Do not wipe out the error state. */
> > +	if (cd->card_state == GENWQE_CARD_USED)
> > +		cd->card_state = GENWQE_CARD_UNUSED;
> > +
> > +	/* Wake up all requests in the DDCB queue such that they
> > +	   should be removed nicely. */
> > +	queue_wake_up_all(cd);
> > +
> > +	/* We must wait to get rid of the DDCBs in flight */
> > +	for (i = 0; i < waitmax; i++) {
> > +		in_flight = genwqe_ddcbs_in_flight(cd);
> > +
> > +		if (in_flight == 0)
> > +			break;
> > +
> > +		dev_info(&pci_dev->dev,
> > +			 "  DEBUG [%d/%d] waiting for queue to get empty: "
> > +			 "%d requests!\n", i, waitmax, in_flight);
> > +		msleep(1000);
> 
> What is this sleep for, and why is it for 1 second? A comment would help
> explain.

I added a comment to the code.

> 
> > +	}
> > +	if (i == waitmax) {
> > +		dev_err(&pci_dev->dev, "  [%s] err: queue is not empty!!\n",
> > +			__func__);
> > +		rc = -EIO;
> > +	}
> > +	return rc;
> > +}
> > +
> > +/**
> > + * @brief	release DDCBs for service layer of Physical Function
> > + * @param cd	genwqe device descriptor
> > + *
> > + * @note This function must be robust enough to be called twice.
> > + */
> > +int genwqe_release_service_layer(struct genwqe_dev *cd)
> > +{
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	if (!ddcb_queue_initialized(&cd->queue))
> > +		return 1;
> > +
> > +	free_irq(pci_dev->irq, cd);
> > +	genwqe_reset_interrupt_capability(cd);
> > +
> > +	if (cd->card_thread != NULL) {
> > +		kthread_stop(cd->card_thread);
> > +		cd->card_thread = NULL;
> > +	}
> > +
> > +	free_ddcb_queue(cd, &cd->queue);
> > +	return 0;
> > +}
> > diff --git a/drivers/misc/genwqe/card_ddcb.h b/drivers/misc/genwqe/card_ddcb.h
> > new file mode 100644
> > index 0000000..8072241
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/card_ddcb.h
> > @@ -0,0 +1,159 @@
> > +#ifndef __CARD_DDCB_H__
> > +#define __CARD_DDCB_H__
> > +
> > +/**
> > + * IBM Accelerator Family 'GenWQE'
> > + *
> > + * (C) Copyright IBM Corp. 2013
> > + *
> > + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> > + * Author: Michael Jung <mijung@de.ibm.com>
> > + * Author: Michael Ruettger <michael@ibmra.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2, or (at your option)
> > + * any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <asm/byteorder.h>
> > +
> > +#include "genwqe_driver.h"
> > +#include "card_base.h"
> > +
> > +/******************************************************************************
> > + * Device Driver Control Block DDCB (spec 9.5)
> > + * format: Big Endian
> > + *****************************************************************************/
> > +
> > +#define ASIV_LENGTH		104 /* Old specification without ATS field */
> > +#define ASIV_LENGTH_ATS		96  /* New specification with ATS field */
> > +#define ASV_LENGTH		64
> > +
> > +struct ddcb {
> > +	union {
> > +		__be32 icrc_hsi_shi_32;	/**< iCRC, Hardware/SW interlock */
> > +		struct {
> > +			__be16	icrc_16;
> > +			u8	hsi;
> > +			u8	shi;
> > +		};
> > +	};
> > +	u8  pre;		/**< Preamble */
> > +	u8  xdir;		/**< Execution Directives */
> > +	__be16 seqnum_16;	/**< Sequence Number */
> > +
> > +	u8  acfunc;		/**< Accelerator Function.. */
> > +	u8  cmd;		/**< Command. */
> > +	__be16 cmdopts_16;	/**< Command Options */
> > +	u8  sur;		/**< Status Update Rate */
> > +	u8  psp;		/**< Protection Section Pointer */
> > +	__be16 rsvd_0e_16;	/**< Reserved invariant */
> > +
> > +	__be64 fwiv_64;		/**< Firmware Invariant. */
> > +
> > +	union {
> > +		struct {
> > +			__be64 ats_64;  /**< Address Translation Spec */
> > +			u8     asiv[ASIV_LENGTH_ATS]; /**< New ASIV */
> > +		} n;
> > +		u8  __asiv[ASIV_LENGTH];	/**< obsolete */
> > +	};
> > +	u8     asv[ASV_LENGTH];	/**< Appl Spec Variant */
> > +
> > +	__be16 rsvd_c0_16;	/**< Reserved Variant */
> > +	__be16 vcrc_16;		/**< Variant CRC */
> > +	__be32 rsvd_32;		/**< Reserved unprotected */
> > +
> > +	__be64 deque_ts_64;	/**< Deque Time Stamp. */
> > +
> > +	__be16 retc_16;		/**< Return Code */
> > +	__be16 attn_16;		/**< Attention/Extended Error Codes */
> > +	__be32 progress_32;	/**< Progress indicator. */
> > +
> > +	__be64 cmplt_ts_64;	/**< Completion Time Stamp. */
> > +
> > +	/* The following layout matches the new service layer format */
> > +	__be32 ibdc_32;		/**< Inbound Data Count  (* 256) */
> > +	__be32 obdc_32;		/**< Outbound Data Count (* 256) */
> > +
> > +	__be64 rsvd_SLH_64;	/**< Reserved for hardware */
> > +	union {			/**< private data for driver */
> > +		u8	priv[8];
> > +		__be64	priv_64;
> > +	};
> > +	__be64 disp_ts_64;	/**< Dispatch TimeStamp */
> > +} __attribute__((__packed__));
> > +
> > +/* CRC polynomials for DDCB */
> > +#define CRC16_POLYNOMIAL	0x1021
> > +
> > +/**
> > + * SHI: Software to Hardware Interlock
> > + *   This 1 byte field is written by software to interlock the
> > + *   movement of one queue entry to another with the hardware in the
> > + *   chip.
> > + */
> > +#define DDCB_SHI_INTR		0x04 /* Bit 2 */
> > +#define DDCB_SHI_PURGE		0x02 /* Bit 1 */
> > +#define DDCB_SHI_NEXT		0x01 /* Bit 0 */
> > +
> > +/* HSI: Hardware to Software interlock
> > + * This 1 byte field is written by hardware to interlock the movement
> > + * of one queue entry to another with the software in the chip.
> > + */
> > +#define DDCB_HSI_COMPLETED	0x40 /* Bit 6 */
> > +#define DDCB_HSI_FETCHED	0x04 /* Bit 2 */
> > +
> > +/**
> > + * Accessing HSI/SHI is done 32-bit wide
> > + *   Normally 16-bit access would work too, but on some platforms the
> > + *   16 compare and swap operation is not supported. Therefore
> > + *   switching to 32-bit such that those platforms will work too.
> > + *
> > + *                                         iCRC HSI/SHI
> > + */
> > +#define DDCB_INTR_BE32		cpu_to_be32(0x00000004)
> > +#define DDCB_PURGE_BE32		cpu_to_be32(0x00000002)
> > +#define DDCB_NEXT_BE32		cpu_to_be32(0x00000001)
> > +#define DDCB_COMPLETED_BE32	cpu_to_be32(0x00004000)
> > +#define DDCB_FETCHED_BE32	cpu_to_be32(0x00000400)
> > +
> > +/* Definitions of DDCB presets */
> > +#define DDCB_PRESET_PRE		0x80
> > +#define ICRC_LENGTH(n)		((n) + 8 + 8 + 8)  /* used ASIV + hdr fields */
> > +#define VCRC_LENGTH(n)		((n))		   /* used ASV */
> > +
> > +/******************************************************************************
> > + * Genwqe Scatter Gather list
> > + *  FIXME Check the spec if those values got modified ...
> > + *  Each element has up to 8 entries.
> > + *  The chaining element is element 0 cause of prefetching needs.
> > + *****************************************************************************/
> > +
> > +/* 0b0110 Chained descriptor. The descriptor is describing the next
> > +   descriptor list. */
> > +#define SG_CHAINED		(0x6)
> > +
> > +/* 0b0010 First entry of a descriptor list. Start from a Buffer-Empty
> > +    condition. */
> > +#define SG_DATA			(0x2)
> > +
> > +/* 0b0000 Early terminator. This is the last entry on the list
> > +   irregardless of the length indicated. */
> > +#define SG_END_LIST		(0x0)
> > +
> > +struct sg_entry {
> > +	__be64 target_addr;
> > +	__be32 len;
> > +	__be32 flags;
> > +};
> > +
> > +#endif /* __CARD_DDCB_H__ */
> 

Regards

Frank


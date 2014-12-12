Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031005AbaLLROt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:14:49 -0500
Received: from mail-bn1bon0095.outbound.protection.outlook.com ([157.56.111.95]:32160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030831AbaLLROr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:14:47 -0500
Date: Fri, 12 Dec 2014 11:14:39 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Michal Simek <michal.simek@xilinx.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 5/6] staging: fpga manager: framework core
In-Reply-To: <049ad99df824432caa190566141d1525@BN1BFFO11FD005.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412121026480.27443@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <1418156090-23578-6-git-send-email-atull@opensource.altera.com> <049ad99df824432caa190566141d1525@BN1BFFO11FD005.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0014.namprd00.prod.outlook.com (25.160.102.24) To
 BY1PR0301MB1239.namprd03.prod.outlook.com (25.161.203.23)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1239;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BY1PR0301MB1239;
X-Forefront-PRVS: 04238CD941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(51704005)(24454002)(22564002)(107046002)(106356001)(19580395003)(120916001)(99396003)(54356999)(86362001)(92566001)(105586002)(69596002)(76176999)(86152002)(50986999)(122386002)(21056001)(110136001)(33716001)(15975445007)(68736005)(46406003)(81156004)(101416001)(87976001)(23726002)(64706001)(66066001)(53416004)(97736003)(46102003)(47776003)(20776003)(42186005)(83506001)(31966008)(77156002)(50466002)(62966003)(4396001)(7059030)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1239;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1239;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB0872;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Michal Simek wrote:

Hi Michal,

Thanks for the review comments.  I have incorporated most of them.
A few questions below.

> > --- /dev/null
> > +++ b/drivers/staging/fpga/Kconfig
> > @@ -0,0 +1,21 @@
> > +#
> > +# FPGA framework configuration
> > +#
> > +
> > +menu "FPGA devices"
> > +
> > +config FPGA
> > +	tristate "FPGA Framework"
> > +	help
> > +	  Say Y here if you want support for configuring FPGAs from the
> > +	  kernel.  The FPGA framework adds a FPGA manager class and FPGA
> > +	  manager drivers.
> > +
> 
> I would add here
> if FPGA
> 

OK

> 
> > +config FPGA_MGR_SYSFS
> > +	bool "FPGA Manager SysFS Interface"
> > +	depends on FPGA
> 
> remove this line.

Good

> 
> > +	depends on SYSFS
> > +	help
> > +	  FPGA Manager SysFS interface.
> > +
> 
> maybe this is not needed at, i2c has no this dependency too and compilation
> looks good too.
> 

Seems like we are dependent on sysfs, so I need 'depends on SYSFS', right?
Also, I want to be able to disable the sysfs interface (more below on that).

> 
> endif here

OK

> 
> The reason is that all "low level" drivers will depend on FPGA that's why with this
> we don't need to add depends on FPGA to every entry.
> 
> > +endmenu
> > diff --git a/drivers/staging/fpga/Makefile b/drivers/staging/fpga/Makefile
> > new file mode 100644
> > index 0000000..c8a676f
> > --- /dev/null
> > +++ b/drivers/staging/fpga/Makefile
> > @@ -0,0 +1,10 @@
> > +#
> > +# Makefile for the fpga framework and fpga manager drivers.
> > +#
> > +
> > +fpga-mgr-core-y += fpga-mgr.o
> > +
> > +# Core FPGA Manager Framework
> > +obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
> 
> Just
> obj-$(CONFIG_FPGA)			+= fpga-mgr.o
> should be enough here.

Yes

> 
> > +
> > +# FPGA Manager Drivers
> > diff --git a/drivers/staging/fpga/fpga-mgr.c b/drivers/staging/fpga/fpga-mgr.c
> > new file mode 100644
> > index 0000000..d08cb82
> > --- /dev/null
> > +++ b/drivers/staging/fpga/fpga-mgr.c
> > @@ -0,0 +1,485 @@
> > +/*
> > + * FPGA Manager Core
> > + *
> > + *  Copyright (C) 2013-2014 Altera Corporation
> > + *
> > + * With code from the mailing list:
> > + * Copyright (C) 2013 Xilinx, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> 
> Greg, Grant: What about to use just SPDX?
> 
> SPDX-License-Identifier:     GPL-2.0
> 

This is a standared GPLv2 header, we're keeping it.  Our legal dept wants it.

> > +#include <linux/delay.h>
> > +#include <linux/firmware.h>
> > +#include <linux/fpga-mgr.h>
> 
> I think it will be worth to add this to linux/fpga/ folder.
> 

OK

> > +#include <linux/fs.h>
> > +#include <linux/idr.h>
> > +#include <linux/interrupt.h>
> 
> Already added by fpga-mgr.h
> 
> > +#include <linux/kernel.h>
> 
> linux/delay.h is adding this header already.

I'm cleaning up the includes in v5.

> > +/*
> > + * Get FPGA state from low level driver
> > + * return value is same enum as fpga_mgr_framework_state
> 
> This is enum fpga_mgr_states based on fpga-mgr.h
> 
> > + *
> > + * This will be used to initialize framework state
> > + */
> 
> We have an opportunity to have this in kernel-doc format.
> Description is pretty similar to kernel doc anyway.

I'll change the core (fpga-mgr.c and fpga-mgr.h) to use kernel-doc.
I'll leave it out of the altera.c part though.

> 
> > +int fpga_mgr_low_level_state(struct fpga_manager *mgr)
> 
> static enum fpga_mgr_states here

OK, there are several places where I've changed to use the enum.

> > +#if IS_ENABLED(CONFIG_FPGA_MGR_SYSFS)
> 
> This shouldn't be needed.

>From the way the discussion has gone about this, there is a desire for
different interfaces for this. I want it to be possible to disable this sysfs
interface if I'm just using the exported functions or some other future
interface.  Part of my main point here is to export enough functionality in
the core functions to make it possible to build other interfaces that people
want to support different use cases or use models.   Since we are going to be
in staging, that is a good place to be doing this.

> 
> > +const char *state_str[] = {
> 
> static const ...

Yes, well actually 'static const *const state_str[]...'

> 
> > +	[FPGA_MGR_STATE_UNKNOWN] =		"unknown",
> > +	[FPGA_MGR_STATE_POWER_OFF] =		"power_off",
> > +	[FPGA_MGR_STATE_POWER_UP] =		"power_up",
> > +	[FPGA_MGR_STATE_RESET] =		"reset",
> > +
> > +	/* write sequence */
> > +	[FPGA_MGR_STATE_FIRMWARE_REQ] =		"firmware_request",
> > +	[FPGA_MGR_STATE_FIRMWARE_REQ_ERR] =	"firmware_request_err",
> > +	[FPGA_MGR_STATE_WRITE_INIT] =		"write_init",
> > +	[FPGA_MGR_STATE_WRITE_INIT_ERR] =	"write_init_err",
> > +	[FPGA_MGR_STATE_WRITE] =		"write",
> > +	[FPGA_MGR_STATE_WRITE_ERR] =		"write_err",
> > +	[FPGA_MGR_STATE_WRITE_COMPLETE] =	"write_complete",
> > +	[FPGA_MGR_STATE_WRITE_COMPLETE_ERR] =	"write_complete_err",
> > +
> > +	[FPGA_MGR_STATE_OPERATING] =		"operating",
> > +};
> > +
> > +/*
> > + * class attributes
> > + */
> > +static ssize_t fpga_mgr_name_show(struct device *dev,
> > +				  struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_manager *mgr = to_fpga_manager(dev);
> > +
> > +	return fpga_mgr_name(mgr, buf);
> > +}
> > +

> > +static DEVICE_ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL);
> 
> DEVICE_ATTR_RO - name change.
> 
> > +static DEVICE_ATTR(state, S_IRUGO, fpga_mgr_state_show, NULL);
> 
> DEVICE_ATTR_RO
> 
> > +static DEVICE_ATTR(firmware, S_IRUGO | S_IWUSR,
> > +		   fpga_mgr_firmware_show, fpga_mgr_firmware_store);
> 
> DEVICE_ATTR_RW
> 
> > +static DEVICE_ATTR(reset, S_IWUSR, NULL, fpga_mgr_reset_store);
> 
> DEVICE_ATTR_WO

Good, thanks.

> 
> > +
> > +static struct attribute *fpga_mgr_attrs[] = {
> > +	&dev_attr_name.attr,
> > +	&dev_attr_state.attr,
> > +	&dev_attr_firmware.attr,
> > +	&dev_attr_reset.attr,
> > +	NULL,
> > +};
> > +
> > +static const struct attribute_group fpga_mgr_group = {
> > +	.attrs = fpga_mgr_attrs,
> > +};
> > +
> > +const struct attribute_group *fpga_mgr_groups[] = {
> > +	&fpga_mgr_group,
> > +	NULL,
> > +};
> > +#else
> > +#define fpga_mgr_groups NULL
> > +#endif /* CONFIG_FPGA_MGR_SYSFS */
> 
> ATTRIBUTE_GROUPS(fpga_mgr)

Yes

> 
> > +
> > +static int fpga_mgr_suspend(struct device *dev)
> > +{
> > +	struct fpga_manager *mgr = to_fpga_manager(dev);
> > +
> > +	if (!mgr)
> > +		return -ENODEV;
> > +
> > +	if (mgr->mops->suspend)
> > +		return mgr->mops->suspend(mgr);
> > +
> > +	return 0;
> > +}
> > +
> > +static int fpga_mgr_resume(struct device *dev)
> > +{
> > +	struct fpga_manager *mgr = to_fpga_manager(dev);
> > +	int ret = 0;
> > +
> > +	if (!mgr)
> > +		return -ENODEV;
> > +
> > +	if (mgr->mops->resume) {
> > +		ret = mgr->mops->resume(mgr);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	if (strlen(mgr->image_name) != 0)
> > +		fpga_mgr_firmware_write(mgr, mgr->image_name);
> > +
> > +	return 0;
> > +}
> > +
> > +const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
> 
> static

Yes

> 
> > +	.suspend	= fpga_mgr_suspend,
> > +	.resume		= fpga_mgr_resume,
> > +};
> > +
> > +static void fpga_mgr_dev_release(struct device *dev)
> > +{
> > +	struct fpga_manager *mgr = to_fpga_manager(dev);
> > +
> > +	dev_dbg(dev, "releasing '%s'\n", dev_name(dev));
> > +	kfree(mgr);
> > +}
> > +
> > +int fpga_mgr_register(struct device *dev, const char *name,
> > +		      struct fpga_manager_ops *mops,
> > +		      void *priv)
> > +{
> > +	struct fpga_manager *mgr;
> > +	int id, ret;
> > +
> > +	BUG_ON(!mops || !name || !strlen(name));
> 
> Isn't this pretty strong? Any reasonable reaction will be better.

You are right.  Changing it to return an error.

> 
> > +
> > +	id = ida_simple_get(&fpga_mgr_ida, 0, 0, GFP_KERNEL);
> > +	if (id < 0)
> > +		return id;
> > +
> > +	mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
> > +	if (!mgr)
> > +		return -ENOMEM;
> 
> here is missing error path handling because you got id.
> It should be moved before ida_simple_get call
> 

OK

> > +
> > +void fpga_mgr_remove(struct device *dev)
> > +{
> > +	struct fpga_manager *mgr = to_fpga_manager(dev);
> > +	int id;
> > +
> > +	if (mgr)
> > +		id = mgr->dev.id;
> 
> Why is here the checking? What cases this can cover if mrg
> is not there?
> 

Not needed.  Removing it.

> > +
> > +	device_unregister(dev);
> > +
> > +	if (mgr) {
> > +		if (mgr->mops->fpga_remove)
> > +			mgr->mops->fpga_remove(mgr);
> > +
> > +		mutex_lock(&fpga_mgr_mutex);
> > +		list_del(&mgr->list);
> > +		mutex_unlock(&fpga_mgr_mutex);
> > +		kfree(mgr);
> > +		ida_simple_remove(&fpga_mgr_ida, id);
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_mgr_remove);
> > +

> > +++ b/include/linux/fpga-mgr.h
> > @@ -0,0 +1,104 @@
> > +/*
> > + * FPGA Framework
> > + *
> > + *  Copyright (C) 2013-2014 Altera Corporation
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +#include <linux/device.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/limits.h>
> > +#include <linux/mutex.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +
> > +#ifndef _LINUX_FPGA_MGR_H
> > +#define _LINUX_FPGA_MGR_H
> > +
> > +struct fpga_manager;
> > +
> > +/*
> > + * fpga_manager_ops are the low level functions implemented by a specific
> > + * fpga manager driver.  Leaving any of these out that aren't needed is fine
> > + * as they are all tested for NULL before being called.
> > + */
> > +struct fpga_manager_ops {
> > +	/* Returns an enum value of the FPGA's state */
> > +	int (*state)(struct fpga_manager *mgr);
> 
> here return should be enum not int.
> 

Yes

> > +
> > +	/* Put FPGA into reset state */
> > +	int (*reset)(struct fpga_manager *mgr);
> > +
> > +	/* Prepare the FPGA to receive confuration data */
> > +	int (*write_init)(struct fpga_manager *mgr);
> > +
> > +	/* Write count bytes of configuration data to the FPGA */
> > +	int (*write)(struct fpga_manager *mgr, const char *buf, size_t count);
> > +
> > +	/* Return FPGA to default state after writing is done */
> > +	int (*write_complete)(struct fpga_manager *mgr);
> > +
> 
> Here are missing read options which were in any previous series.
> But they can be added in the following patch.

Yes, they can be added later.

> 
> > +	/* Optional: Set FPGA into a specific state during driver remove */
> > +	void (*fpga_remove)(struct fpga_manager *mgr);
> > +
> > +	int (*suspend)(struct fpga_manager *mgr);
> > +
> > +	int (*resume)(struct fpga_manager *mgr);
> > +};
> > +
> > +/* Valid states may vary by manufacturer; superset is: */
> > +enum fpga_mgr_states {
> > +	FPGA_MGR_STATE_UNKNOWN,		/* can't determine state */
> > +	FPGA_MGR_STATE_POWER_OFF,	/* FPGA power is off */
> > +	FPGA_MGR_STATE_POWER_UP,	/* FPGA reports power is up */
> > +	FPGA_MGR_STATE_RESET,		/* FPGA held in reset state */
> > +
> > +	/* write sequence */
> > +	FPGA_MGR_STATE_FIRMWARE_REQ,	/* firmware request in progress */
> > +	FPGA_MGR_STATE_FIRMWARE_REQ_ERR, /* firmware request failed */
> > +	FPGA_MGR_STATE_WRITE_INIT,	/* preparing FPGA for programming */
> > +	FPGA_MGR_STATE_WRITE_INIT_ERR,	/* Error during write_init stage */
> > +	FPGA_MGR_STATE_WRITE,		/* FPGA ready to receive image data */
> > +	FPGA_MGR_STATE_WRITE_ERR,	/* Error while programming FPGA */
> > +	FPGA_MGR_STATE_WRITE_COMPLETE,	/* Doing post programming steps */
> > +	FPGA_MGR_STATE_WRITE_COMPLETE_ERR, /* Error during write_complete */
> > +
> > +	FPGA_MGR_STATE_OPERATING,	/* FPGA is programmed and operating */
> > +};
> > +
> 
> kernel-doc here will be good.

OK

> 
> > +struct fpga_manager {
> > +	const char *name;
> > +	struct device dev;
> > +	struct list_head list;
> > +	struct mutex lock;
> > +	enum fpga_mgr_states state;
> > +	char image_name[NAME_MAX];
> > +
> > +	struct fpga_manager_ops *mops;
> > +	void *priv;
> > +};
> > +
> > +#define to_fpga_manager(d) container_of(d, struct fpga_manager, dev)
> > +
> > +#if IS_ENABLED(CONFIG_FPGA)
> 
> you can simple remove this if.

Cool.

Alan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3KFMYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:24:33 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:43396 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3KFMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:24:31 -0500
Subject: Re: [PATCH 5/6] GenWQE Sysfs interfaces
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <52795861.5010802@gmail.com>
References: <1383641074-13710-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383641074-13710-6-git-send-email-haver@linux.vnet.ibm.com>
	 <52795861.5010802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 06 Nov 2013 13:24:20 +0100
Message-ID: <1383740660.9962.7.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110612-4966-0000-0000-0000076A0C1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Am Mittwoch, den 06.11.2013, 07:43 +1100 schrieb Ryan Mallon:
> On 05/11/13 19:44, Frank Haverkamp wrote:
> 
> > Sysfs interfaces for the GenWQE card. There are attributes to query
> > the version of the bitstream as well as some for the driver. For
> > debugging, please also see the debugfs interfaces of this driver.
> > 
> > Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
> >             Michael Jung <MIJUNG@de.ibm.com>,
> >             Michael Ruettger <michael@ibmra.de>
> 
> 
> Handful of small comments below,
> 
> ~Ryan
> 
> > ---
> >  Documentation/ABI/testing/sysfs-driver-genwqe |   55 +++++
> >  drivers/misc/genwqe/card_sysfs.c              |  290 +++++++++++++++++++++++++
> >  2 files changed, 345 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
> >  create mode 100644 drivers/misc/genwqe/card_sysfs.c
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
> > new file mode 100644
> > index 0000000..0976901
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-driver-genwqe
> > @@ -0,0 +1,55 @@
> > +What:           /sys/class/genwqe/genwqe<n>_card/version
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Unique bitstream identification e.g.
> > +                '0000000330336283.00000000475a4950'.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/appid
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Identifies the currently active card application e.g. 'GZIP'
> > +                for compression/decompression.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/type
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Type of the card e.g. 'GenWQE5-A7'.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/cpld_version
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Version id of the cards CPLD.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/curr_bitstream
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Currently active bitstream. 1 is default, 0 is backup.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/next_bitstream
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to set the next bitstream to be used.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/tempsens
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Interface to read the cards temperature sense register.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/state
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    State of the card: "unused", "used", "error".
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/base_clock
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Base clock frequency of the card.
> > +
> > +What:           /sys/class/genwqe/genwqe<n>_card/device/sriov_numvfs
> > +Date:           Oct 2013
> > +Contact:        haver@linux.vnet.ibm.com
> > +Description:    Enable VFs (1..15):
> > +                  sudo sh -c 'echo 15 > \
> > +                    /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
> > +                Disable VFs:
> > +                  Write a 0 into the same sysfs entry.
> > diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
> > new file mode 100644
> > index 0000000..f29ce55
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/card_sysfs.c
> > @@ -0,0 +1,290 @@
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
> > + * it under the terms of the GNU General Public License (version 2 only)
> > + * as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +/*
> > + * Sysfs interfaces for the GenWQE card. There are attributes to query
> > + * the version of the bitstream as well as some for the driver. For
> > + * debugging, please also see the debugfs interfaces of this driver.
> > + */
> > +
> > +#include <linux/version.h>
> > +#include <linux/kernel.h>
> > +#include <linux/types.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/string.h>
> > +#include <linux/fs.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/ctype.h>
> > +#include <linux/device.h>
> > +
> > +#include "card_base.h"
> > +#include "card_ddcb.h"
> > +
> > +static const char * const genwqe_types[] = {
> > +	[GENWQE_TYPE_ALTERA_230] = "GenWQE4-230",
> > +	[GENWQE_TYPE_ALTERA_530] = "GenWQE4-530",
> > +	[GENWQE_TYPE_ALTERA_A4]  = "GenWQE5-A4",
> > +	[GENWQE_TYPE_ALTERA_A7]  = "GenWQE5-A7",
> > +};
> > +
> > +static ssize_t status_show(struct device *dev, struct device_attribute *attr,
> > +			   char *buf)
> > +{
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +	const char *cs[GENWQE_CARD_STATE_MAX] = { "unused", "used", "error" };
> > +
> > +	return scnprintf(buf, PAGE_SIZE, "%s\n", cs[cd->card_state]);
> > +}
> > +static DEVICE_ATTR_RO(status);
> > +
> > +static ssize_t appid_show(struct device *dev, struct device_attribute *attr,
> > +			  char *buf)
> > +{
> > +	char app_name[5];
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	genwqe_read_app_id(cd, app_name, sizeof(app_name));
> > +	return scnprintf(buf, PAGE_SIZE, "%s\n", app_name);
> > +}
> > +static DEVICE_ATTR_RO(appid);
> > +
> > +static ssize_t version_show(struct device *dev, struct device_attribute *attr,
> > +			    char *buf)
> > +{
> > +	u64 slu_id, app_id;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
> > +	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
> > +
> > +	return scnprintf(buf, PAGE_SIZE, "%016llx.%016llx\n", slu_id, app_id);
> > +}
> > +static DEVICE_ATTR_RO(version);
> > +
> > +static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> > +			 char *buf)
> > +{
> > +	u8 card_type;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	card_type = genwqe_card_type(cd);
> > +	return scnprintf(buf, PAGE_SIZE, "%s\n",
> > +			 (card_type >= ARRAY_SIZE(genwqe_types)) ?
> > +			 "invalid" : genwqe_types[card_type]);
> > +}
> > +static DEVICE_ATTR_RO(type);
> > +
> > +static ssize_t driver_show(struct device *dev, struct device_attribute *attr,
> > +			   char *buf)
> > +{
> > +	return scnprintf(buf, PAGE_SIZE, "%s\n", DRV_VERS_STRING);
> > +}
> > +static DEVICE_ATTR_RO(driver);
> > +
> > +static ssize_t tempsens_show(struct device *dev, struct device_attribute *attr,
> > +			     char *buf)
> > +{
> > +	u64 tempsens;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	tempsens = __genwqe_readq(cd, IO_SLU_TEMPERATURE_SENSOR);
> > +	return scnprintf(buf, PAGE_SIZE, "%016llx\n", tempsens);
> > +}
> > +static DEVICE_ATTR_RO(tempsens);
> > +
> > +static ssize_t base_clock_show(struct device *dev,
> > +			       struct device_attribute *attr,
> > +			       char *buf)
> > +{
> > +	u64 base_clock;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	base_clock = genwqe_base_clock_frequency(cd);
> > +	return scnprintf(buf, PAGE_SIZE, "%lld\n", base_clock);
> > +}
> > +static DEVICE_ATTR_RO(base_clock);
> > +
> > +/**
> > + * curr_bitstream_show() - Show the current bitstream id
> > + *
> > + * There is a bug in some old versions of the CPLD which selects the
> > + * bitstream, which causes the IO_SLU_BITSTREAM register to report
> > + * unreliable data in very rare cases. This makes this sysfs
> > + * unreliable up to the point were a new CPLD version is being used.
> > + *
> > + * Unfortunately there is no automatic way yet to query the CPLD
> > + * version (See show_cpld_version() ;-)), such that you need to
> > + * manually ensure via programming tools that you have a recent
> > + * version of the CPLD software.
> > + *
> > + * The proposed circumvention is to use a special recovery bitstream
> > + * on the backup partition (0) to identify problems while loading the
> > + * image.
> > + */
> > +static ssize_t curr_bitstream_show(struct device *dev,
> > +				   struct device_attribute *attr, char *buf)
> > +{
> > +	int curr_bitstream;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	curr_bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM) & 0x1;
> > +	return scnprintf(buf, PAGE_SIZE, "%d\n", curr_bitstream);
> > +}
> > +static DEVICE_ATTR_RO(curr_bitstream);
> > +
> > +/**
> > + * next_bitstream_show() - Show the next activated bitstream
> > + *
> > + * IO_SLC_CFGREG_SOFTRESET: This register can only be accessed by the PF.
> > + */
> > +static ssize_t next_bitstream_show(struct device *dev,
> > +				   struct device_attribute *attr, char *buf)
> > +{
> > +	int next_bitstream;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	switch ((cd->softreset & 0xcull) >> 2) {
> 
> 
> The ull suffix isn't really necessary here, and can just be removed.

Ok.

> 
> > +	case 0x2:
> > +		next_bitstream =  0;
> > +		break;
> > +	case 0x3:
> > +		next_bitstream =  1;
> > +		break;
> > +	default:
> > +		next_bitstream = -1;
> > +		break;		/* error */
> > +	}
> > +	return scnprintf(buf, PAGE_SIZE, "%d\n", next_bitstream);
> 
> 
> sprintf is fine, a %d is not going to be larger than PAGE_SIZE.
> 

Agreed.

> > +}
> > +
> > +static ssize_t next_bitstream_store(struct device *dev,
> > +				    struct device_attribute *attr,
> > +				    const char *buf, size_t count)
> > +{
> > +	u64 partition;
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +
> > +	if (kstrtoull(buf, 0, &partition) < 0)
> > +		return -EINVAL;
> 
> 
> Why are you using kstrtoull for a value which is only 0 or 1?
> 
> > +
> > +	switch (partition) {
> > +	case 0x0:
> > +		cd->softreset = 0x78ull;
> > +		break;
> > +	case 0x1:
> > +		cd->softreset = 0x7cull;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
> > +	return count;
> > +}
> > +static DEVICE_ATTR_RW(next_bitstream);
> > +
> > +/**
> > + * FIXME Implement me!
> > + */
> > +static ssize_t cpld_version_show(struct device *dev,
> > +				 struct device_attribute *attr, char *buf)
> > +{
> > +	return scnprintf(buf, PAGE_SIZE, "unknown (FIXME)\n");
> > +}
> > +static DEVICE_ATTR_RO(cpld_version);
> 
> 
> Why provide this if it doesn't work? User-space obviously can't do the
> right thing with it, so just remove it until it gets implemented
> properly.

I removed it.

> 
> > +
> > +/*
> > + * Create device_attribute structures / params: name, mode, show, store
> > + * additional flag if valid in VF
> > + */
> > +static struct attribute *genwqe_attributes[] = {
> > +	&dev_attr_tempsens.attr,
> > +	&dev_attr_next_bitstream.attr,
> > +	&dev_attr_curr_bitstream.attr,
> > +	&dev_attr_base_clock.attr,
> > +	&dev_attr_driver.attr,
> > +	&dev_attr_type.attr,
> > +	&dev_attr_version.attr,
> > +	&dev_attr_appid.attr,
> > +	&dev_attr_status.attr,
> > +	&dev_attr_cpld_version.attr,
> > +	NULL,
> > +};
> > +
> > +static struct attribute *genwqe_normal_attributes[] = {
> > +	&dev_attr_driver.attr,
> > +	&dev_attr_type.attr,
> > +	&dev_attr_version.attr,
> > +	&dev_attr_appid.attr,
> > +	&dev_attr_status.attr,
> > +	NULL,
> > +};
> > +
> > +/**
> > + * genwqe_is_visible() - Determine if sysfs attribute should be visible or not
> > + *
> > + * VFs have restricted mmio capabilities, so not all sysfs entries
> > + * are allowed in VFs.
> > + */
> > +static umode_t genwqe_is_visible(struct kobject *kobj,
> > +				 struct attribute *attr, int n)
> 
> > +{
> > +	unsigned int j;
> > +	struct device *dev = container_of(kobj, struct device, kobj);
> > +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +	umode_t mode = attr->mode;
> > +
> > +	if (genwqe_is_privileged(cd))
> > +		return mode;
> > +
> > +	for (j = 0; genwqe_normal_attributes[j] != NULL;  j++)
> > +		if (genwqe_normal_attributes[j] == attr)
> > +			return mode;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct attribute_group genwqe_attribute_group = {
> > +	.is_visible = genwqe_is_visible,
> > +	.attrs      = genwqe_attributes,
> > +};
> > +
> > +/**
> > + * genwqe_init_sysfs() - Setup sysfs entries of the card device
> > + */
> > +int genwqe_init_sysfs(struct genwqe_dev *cd)
> > +{
> > +	int rc;
> > +
> > +	rc = sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
> > +	if (rc)
> > +		return -ENXIO;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * genwqe_exit_sysfs() - Remove sysfs entries
> > + */
> > +void genwqe_exit_sysfs(struct genwqe_dev *cd)
> > +{
> > +	sysfs_remove_group(&cd->dev->kobj, &genwqe_attribute_group);
> > +}
> 
> 

Regards

Frank



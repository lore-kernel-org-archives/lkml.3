Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab3HBDXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:23:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3HBDXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:23:09 -0400
Date: Fri, 2 Aug 2013 11:24:25 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Srikanth Thokala <srikanth.thokala@xilinx.com>
Cc: arnd@arndb.de, rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@linaro.org,
        Michal Simek <michal.simek@xilinx.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: Re: [LINUX PATCH RFC v2] trafgen: xilinx: add axi traffic generator
 driver
Message-ID: <20130802032425.GC2553@kroah.com>
References: <477a2d56-a6f9-455f-b5c7-740ae9e9ba8e@CO1EHSMHS024.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477a2d56-a6f9-455f-b5c7-740ae9e9ba8e@CO1EHSMHS024.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 08:31:14PM +0530, Srikanth Thokala wrote:
> This is the driver for AXI Traffic Generator IP. The AXI
> Traffic Generator IP is a core that stresses the AXI4
> interconnect and other AXI4 peripherals in the system.
> It generates a wide variety of AXI4 transactions based on
> the core programming.
> 
> Architecture of the core is broadly separated into a master
> and slave block, each of which contains the write block and
> read block. Other support functions are provided by the
> control registers and three internal RAMs - Master RAM,
> Command RAM, Parameter RAM. The initialisation sequence
> includes programming Command RAM with commands, data into
> Master RAM (optional Parameter RAM programming) and then
> enable master logic using control register interface.
> This sequence generates traffic to cores connected in the
> h/w design.
> 
> The driver for this IP is designed to be a module with
> sysfs interface.  All the control registers and internal
> RAMs can be accessed through sysfs interface.

As you are adding sysfs files, you also need to add Documentation/ABI/
entries as well.

One other comment:

> +	/*
> +	 * Create sysfs file entries for the device
> +	 *
> +	 * NOTE: We can create sysfs entries by adding attribute groups
> +	 * and then populate into device_driver structure. We see issue
> +	 * here, as this process doesn't allow to add sysfs entries with
> +	 * BIN attributes (SYSFS_KOBJ_BIN_ATTR). Also, this would create
> +	 * sysfs entries under driver/ which will be a bit confusing for
> +	 * users as bin files and normal files will be populated at diff
> +	 * erent places. So to avoid this, we created this function to
> +	 * add sysfs entries at a common place.
> +	 *
> +	 * This issue is being addressed in mainline by
> +	 * 'sysfs: add support for binary attributes in groups'. It
> +	 * removes this overhead of creating/removing sysfs file entries.
> +	 */
> +	err = xtg_create_sysfs_dev_files(tg);
> +	if (err < 0) {
> +		dev_err(tg->dev, "unable to create sysfs entries\n");
> +		return err;
> +	}

This patch is now in place, so you don't have to create the sysfs binary
files separately, just add them to the same attribute group as your
"normal" sysfs files.

Now the idea of doing all of the api to this device from sysfs is
another story, but as I don't know what these files are really doing
(i.e. no documentation), I'll hold off on that until you fix that up.

thanks,

greg k-h

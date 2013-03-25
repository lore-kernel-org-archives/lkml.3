Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3CYU27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:28:59 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48272 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab3CYU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:28:57 -0400
Date: Mon, 25 Mar 2013 13:28:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 01/11 V4] mei: bus: Initial MEI Client bus type
 implementation
Message-ID: <20130325202855.GA21494@kroah.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
 <1363819469-696-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363819469-696-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:44:19AM +0200, Tomas Winkler wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> mei cleint bus will present some of the me clients

s/me /mei /

> as devices for other standard subsystems
> 
> Implement the probe, remove, match and the device addtion routines.
> A mei-cleint-bus.txt document describing the rationale and the API usage
> is also added.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  Documentation/misc-devices/mei/mei-client-bus.txt | 143 ++++++++++++++++++++
>  drivers/misc/mei/Makefile                         |   1 +
>  drivers/misc/mei/bus.c                            | 151 ++++++++++++++++++++++
>  drivers/misc/mei/mei_dev.h                        |  27 ++++
>  include/linux/mei_cl_bus.h                        |  92 +++++++++++++
>  5 files changed, 414 insertions(+)
>  create mode 100644 Documentation/misc-devices/mei/mei-client-bus.txt

Shouldn't you also create Documentation/ABI/ entries as well?

> +#define NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, 0x94, \
> +			       0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
> +
> +static struct mei_cl_id contact_mei_cl_tbl[] = {
> +	{ CONTACT_DRIVER_NAME, NFC_UUID },
> +
> +	/* required last entry */
> +	{ }
> +};

What about MODULE_DEVICE() functionality for this structure?  Don't you
need/want that as well?


> +/**
> + * struct mei_cl_device - MEI device handle
> + * An mei_cl_device pointer is returned from mei_add_device()
> + * and links MEI bus clients to their actual ME host client pointer.
> + * Drivers for MEI devices will get an mei_cl_device pointer
> + * when being probed and shall use it for doing ME bus I/O.
> + *
> + * @dev: linux driver model device pointer
> + * @uuid: me client uuid
> + * @cl: mei client
> + * @priv_data: client private data
> + */
> +struct mei_cl_device {
> +	struct device dev;
> +
> +	uuid_le uuid;
> +	struct mei_cl *cl;
> +
> +	void *priv_data;
> +};

Why is priv_data needed?  What's wrong with the pointer provided to you
in struct device?

> +++ b/include/linux/mei_cl_bus.h
> @@ -0,0 +1,92 @@
> +/******************************************************************************
> + * Intel Management Engine Interface (Intel MEI) Linux driver
> + * Intel MEI Interface Header
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
> + * USA

Are you really going to track the movements of the FSF for the next 40+
years?

> + * The full GNU General Public License is included in this distribution
> + * in the file called LICENSE.GPL.

Not needed for an in-kernel header file, right?

> + *
> + * Contact Information:
> + *	Intel Corporation.
> + *	linux-mei@linux.intel.com
> + *	http://www.intel.com
> + *
> + * BSD LICENSE

Wait, you are putting code that has EXPORT_SYMBOL_GPL() usage under a
GPL/BSD license?  I need an Intel lawyer signed-off-by: on the patch
before I can accept that.

> +struct mei_cl_driver {
> +	struct device_driver driver;
> +	const char *name;

What's wrong with the driver.name field?

thanks,

greg k-h

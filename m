Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaKTL6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:58:25 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35513 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbaKTL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:58:23 -0500
Date: Thu, 20 Nov 2014 11:58:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device
 interface
Message-ID: <20141120115817.GC13269@x1>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>
 <20141118141827.GB24004@x1>
 <546DD00E.4000704@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546DD00E.4000704@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >> +#include <linux/compat.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/device.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/mfd/cros_ec.h>
> >> +#include <linux/mfd/cros_ec_commands.h>
> >> +#include <linux/mfd/cros_ec_dev.h>
> >> +#include <linux/module.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/printk.h>
> > 
> > What do you need this for?
> >
> 
> the printk.h header? to use the pr_* functions but I'll make sure that only
> the needed headers are included.

Right, I think don't think you should be using those on a platform device.

> >> +#include <linux/types.h>
> >> +#include <linux/uaccess.h>
> >> +
> >> +/* Device variables */
> >> +#define CROS_CLASS_NAME "chromeos"
> > 
> > Any reason why you can't use the name directly?
> > 
> 
> I prefer macros if possible since they cost nothing and give you an indirection
> level if you want to change it later. Any reason to not use a define directive?

Exactly as you said, they add a layer of (pointless)
indirection/complexity.  You only use this name once, just change it
where you use it if you wish to (but probably never will) adapt the
name. 

[...]

> >> +static struct platform_driver cros_ec_dev_driver = {
> >> +	.driver = {
> >> +		.name = "cros-ec-dev",
> >> +		.owner = THIS_MODULE,
> > 
> > Remove this line.
> >
> 
> Right, I've seen some cleanups efforts to remove the owner from drivers
> but forgot when reviewing this driver for posting.
>  
> >> +	},
> >> +	.probe = ec_device_probe,
> >> +	.remove = ec_device_remove,
> >> +};
> > 
> > Where is this device registered from?
> > 
> >> +module_platform_driver(cros_ec_dev_driver);
> 
> This preprocessor macro is expanded to (from include/linux/device.h):
> 
> module_platform_driver() -> module_driver()
> 
> #define module_driver(__driver, __register, __unregister, ...) \
> static int __init __driver##_init(void) \
> { \
> 	return __register(&(__driver) , ##__VA_ARGS__); \
> } \

I know how the device driver model works.  I'm asking where the
'device' is registered from, not the 'driver' i.e. platform data, DT,
ACPI?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

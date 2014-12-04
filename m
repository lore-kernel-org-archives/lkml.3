Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaLDTr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:47:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55324 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbaLDTr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:47:27 -0500
Date: Thu, 4 Dec 2014 13:46:15 -0600
From: Nishanth Menon <nm@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <jdelvare@suse.de>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (gpio-fan) Allow usage of gpio operations that
 may sleep
Message-ID: <20141204194615.GA7975@kahuna>
References: <1417712328-29831-1-git-send-email-nm@ti.com>
 <20141204190528.GA16925@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141204190528.GA16925@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:05-20141204, Guenter Roeck wrote:
> On Thu, Dec 04, 2014 at 10:58:47AM -0600, Nishanth Menon wrote:
> > Certain I2C based GPIO expanders could be used in sleepable context,
> > this results in:
> > [  115.890569] ------------[ cut here ]------------
> > [  115.895422] WARNING: CPU: 0 PID: 1115 at drivers/gpio/gpiolib.c:1370 gpiod_set_raw_value+0x40/0x4c()
> > [  115.905024] Modules linked in:
> > [  115.908229] CPU: 0 PID: 1115 Comm: sh Tainted: G        W      3.18.0-rc7-next-20141203-dirty #1
> > [  115.917461] Hardware name: Generic DRA74X (Flattened Device Tree)
> > [  115.923876] [<c0015368>] (unwind_backtrace) from [<c00119f4>] (show_stack+0x10/0x14)
> > [  115.932013] [<c00119f4>] (show_stack) from [<c05b78e8>] (dump_stack+0x78/0x94)
> > [  115.939594] [<c05b78e8>] (dump_stack) from [<c003de28>] (warn_slowpath_common+0x7c/0xb4)
> > [  115.948094] [<c003de28>] (warn_slowpath_common) from [<c003de7c>] (warn_slowpath_null+0x1c/0x24)
> > [  115.957315] [<c003de7c>] (warn_slowpath_null) from [<c03461e8>] (gpiod_set_raw_value+0x40/0x4c)
> > [  115.966457] [<c03461e8>] (gpiod_set_raw_value) from [<c04866f4>] (set_fan_speed+0x4c/0x64)
> > [  115.975145] [<c04866f4>] (set_fan_speed) from [<c04868a8>] (set_rpm+0x98/0xac)
> > [  115.982742] [<c04868a8>] (set_rpm) from [<c039fb4c>] (dev_attr_store+0x18/0x24)
> > [  115.990426] [<c039fb4c>] (dev_attr_store) from [<c01b0a28>] (sysfs_kf_write+0x4c/0x50)
> > [  115.998742] [<c01b0a28>] (sysfs_kf_write) from [<c01afe1c>] (kernfs_fop_write+0xbc/0x19c)
> > [  116.007333] [<c01afe1c>] (kernfs_fop_write) from [<c0148cc4>] (vfs_write+0xb0/0x1a0)
> > [  116.015461] [<c0148cc4>] (vfs_write) from [<c0148fbc>] (SyS_write+0x44/0x84)
> > [  116.022881] [<c0148fbc>] (SyS_write) from [<c000e5c0>] (ret_fast_syscall+0x0/0x48)
> > [  116.030833] ---[ end trace 3a0b636123acab82 ]---
> > 
> > So, switch over to sleepable GPIO operations as there is no mandatory
> > need for non-sleepable gpio operations in the fan driver.
> > 
> > This allows the fan driver to be used with i2c based gpio expanders such
> > as palmas_gpio.
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Applied to hwmon-next. Do we need this in older kernels ?

I have'nt had a need for it till recently.. in terms of the sleepable
get/set, it seems to have been introduced with
	commit 7560fa60fcdcdb0da662f6a9fad9064b554ef46c
	Author: David Brownell <david-b@pacbell.net>
	Date:   Tue Mar 4 14:28:27 2008 -0800
	gpio: <linux/gpio.h> and "no GPIO support here" stubs

Guessing no one needed it so far.. so probably future should be good
enough, I think..

-- 
Regards,
Nishanth Menon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbaKYOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:38:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKYOiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:38:21 -0500
Date: Tue, 25 Nov 2014 15:38:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-2022-JP?Q?=1B$B2+GH=1B=28J?= <huangbobupt@163.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: add BETOP game controller force feedback
 support
In-Reply-To: <3e9f782f.a7fa.149df95fef7.Coremail.huangbobupt@163.com>
Message-ID: <alpine.LNX.2.00.1411251534010.23174@pobox.suse.cz>
References: <3e9f782f.a7fa.149df95fef7.Coremail.huangbobupt@163.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, 黄波 wrote:

> From: Huang Bo <huangbobupt@163.com>
> 
> Adds force feedback support for BETOP USB game controllers.
> These devices are mass produced in China.

Thanks a lot for the patch. A few minor things below.

First, the whole driver formatting doesn't comply with our coding style 
(it has 4 spaces instead of tab). Please reformat that for v2.

[ ... snip ... ]
> diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
> new file mode 100644
> index 0000000..d97301a
> --- /dev/null
> +++ b/drivers/hid/hid-betopff.c
> @@ -0,0 +1,170 @@
> +/*
> + *  Force feedback support for Betop based devices
> + *
> + *  The devices are distributed under various names and the same USB device ID
> + *  can be used in both adapters and actual game controllers.
> + *
> + *  0x11C0:0x5506 "BTP2185 PC mode Joystick"
> + *   - tested with BTP2185 V2 PC Mode.
> + *
> + *  0x8380:0x1850 "BTP2185 V2 PC mode USB Gamepad"
> + *   - tested with BTP2185 PC Mode with another version.
> + *
> + *  0x20bc:0x5500 "BTP2185 V2 BFM mode Joystick"
> + *   - tested with BTP2185 BFM Mode.
> + *   - tested with BTP2171s.
> + *
> + *  Copyright (c) 2014 Huang Bo <huangbobupt@163.com>
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +/* #define DEBUG */
> +
> +#define debug(format, arg...) pr_debug("hid-betopff: " format "\n" , ## arg)
> +
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/hid.h>
> +
> +#include "hid-ids.h"
> +
> +struct betopff_device {
> +    struct hid_report *report;
> +};
> +
> +static int hid_betopff_play(struct input_dev *dev, void *data,
> +             struct ff_effect *effect)
> +{
> +    struct hid_device *hid = input_get_drvdata(dev);
> +    struct betopff_device *betopff = data;
> +    __u16 left, right;
> +
> +    left = effect->u.rumble.strong_magnitude;
> +    right = effect->u.rumble.weak_magnitude;
> +
> +    betopff->report->field[2]->value[0] = left / 256;
> +    betopff->report->field[3]->value[0] = right / 256;
> +    debug("running with 0x%02x 0x%02x", left, right);

Is there really a need for keeping this debug() in the "production" 
version?

[ ... snip ... ]
> +static const struct hid_device_id betop_devices[] = {
> +    { HID_USB_DEVICE(0x11C0, 0x5506), }, /* BTP2185 PC mode */
> +    { HID_USB_DEVICE(0x8380, 0x1850), }, /* BTP2185 V2 PC mode */
> +    { HID_USB_DEVICE(0x20bc, 0x5500), }, /* BTP2185 V2 BFM mode */
> +    { }

You also need an entry for these devices in hid_have_special_driver[] 
array in drivers/hid/hid-core.c, otherwise correct device <-> driver 
binding can't be guaranteed.

-- 
Jiri Kosina
SUSE Labs

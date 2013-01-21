Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3AUQhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:37:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab3AUQhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:37:07 -0500
Date: Mon, 21 Jan 2013 17:37:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add ThingM blink(1) USB LED support
In-Reply-To: <1355859068-29927-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Message-ID: <alpine.LNX.2.00.1301211714520.8266@pobox.suse.cz>
References: <1355859068-29927-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Vivien Didelot wrote:

> The ThingM blink(1) is an open source hardware USB RGB LED. It contains
> an internal EEPROM, allowing to configure up to 12 light patterns. A
> light pattern is a RGB color plus a fading time. This driver registers a
> LED class instance with additional sysfs attributes to support basic
> functions such as setting RGB colors, fading and playing. Other
> functions are still accessible through the hidraw interface.
> 
> At this time, the only documentation for the device is the firmware
> source code from ThingM, plus a few schematics. They are available at:
> 
> https://github.com/todbot/blink1
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-hid-blink1 |  25 ++
>  MAINTAINERS                                       |   5 +
>  drivers/hid/Kconfig                               |  10 +
>  drivers/hid/Makefile                              |   1 +
>  drivers/hid/hid-blink1.c                          | 275 ++++++++++++++++++++++

hid-blink sounds too generic to me, taking into account that this is not 
'generic HID blinking' framework, but rather a specific device driver for 
a particular device.

So something like hid-thingm-blink sounds more reasonable to me.

[ ... snip ... ]
> diff --git a/drivers/hid/hid-blink1.c b/drivers/hid/hid-blink1.c
> new file mode 100644
> index 0000000..13025a8
> --- /dev/null
> +++ b/drivers/hid/hid-blink1.c
> @@ -0,0 +1,275 @@
> +/*
> + *  ThingM blink(1) USB LED Driver
> + *  Copyright (C) 2012  Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> + *
> + *  This program is free software: you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation, either version 3 of the License, or

Linux Kernel is being shipped under GPL v2, without "or any later" clause 
added. So I am afraid I can't merge the code with this license.

-- 
Jiri Kosina
SUSE Labs

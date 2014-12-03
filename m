Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaLCJTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:19:48 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47107 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaLCJRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <54761BFC.4020705@ti.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
Date: Wed, 3 Dec 2014 17:17:13 +0800
Message-ID: <CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Grant Likely <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
>
> On 11/25/2014 07:16 AM, Chunyan Zhang wrote:
>>
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>>
>> [...]


>>
>> +++ b/drivers/tty/serial/sprd_serial.c
>> @@ -0,0 +1,752 @@
>> +/*
>> + * Copyright (C) 2012 Spreadtrum Communications Inc.
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include<linux/module.h>
>> +#include<linux/tty.h>
>> +#include<linux/ioport.h>
>> +#include<linux/console.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/tty_flip.h>
>> +#include<linux/serial_core.h>
>> +#include<linux/serial.h>
>> +#include<linux/delay.h>
>> +#include<linux/io.h>
>> +#include<asm/irq.h>
>> +#include<linux/slab.h>
>> +#include<linux/of.h>
>> +#include<linux/kernel.h>
>> +#include<linux/slab.h>
>> +#include<linux/clk.h>
>
> How about sorting this includes? asm/irq.h go first followed linux/ in alphabatical order?


There are a few compile warnings if I moved asm/irq.h to the top of
all included files.
Warning details are below:

In file included from drivers/tty/serial/sprd_serial.c:14:0:
./arch/arm64/include/asm/irq.h:6:39: warning: ‘struct pt_regs’
declared inside parameter list [enabled by default]
 extern void (*handle_arch_irq)(struct pt_regs *);
                                       ^
./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only this
definition or declaration, which is probably not what you want
[enabled by default]
./arch/arm64/include/asm/irq.h:8:54: warning: ‘struct pt_regs’
declared inside parameter list [enabled by default]
 extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));

Thanks,
Chunyan

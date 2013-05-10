Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3EJSD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:03:57 -0400
Received: from [216.32.180.186] ([216.32.180.186]:22068 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab3EJSD4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:03:56 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zz98dIc89bh1432Ic8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Fri, 10 May 2013 11:03:22 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <CAHp75Vcr10d=XesGQvrC_v+ijdp3nK+m=w5E7d6GCo1Z9ogWnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAHp75Vcr10d=XesGQvrC_v+ijdp3nK+m=w5E7d6GCo1Z9ogWnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b3594fb6-0cbd-45e4-b1aa-813e5b5a3bcd@CO1EHSMHS006.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Andy,

first, can you please send plain text email? The formatting gets messed up a
bit for me otherwise.

On Fri, May 10, 2013 at 08:42:34PM +0300, Andy Shevchenko wrote:
>    10.5.2013 20.32 "Soren Brinkmann" <soren.brinkmann@xilinx.com> kirjoitti:
>    >
>    > The userspace clock driver can be used to expose clock controls through
>    > sysfs to userspace. The driver creates entries in /sys/class/clk.
>    >
>    > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>    > ---
>    >  .../devicetree/bindings/clock/clk-userspace.txt    |   7 +
>    >  drivers/clk/Kconfig                                |   9 ++
>    >  drivers/clk/Makefile                               |   1 +
>    >  drivers/clk/clk-userspace.c                        | 169
>    +++++++++++++++++++++
>    >  4 files changed, 186 insertions(+)
>    >  create mode 100644
>    Documentation/devicetree/bindings/clock/clk-userspace.txt
>    >  create mode 100644 drivers/clk/clk-userspace.c
>    >
>    > diff --git a/Documentation/devicetree/bindings/clock/clk-userspace.txt
>    b/Documentation/devicetree/bindings/clock/clk-userspace.txt
>    > new file mode 100644
>    > index 0000000..2d153c7
>    > --- /dev/null
>    > +++ b/Documentation/devicetree/bindings/clock/clk-userspace.txt
>    > @@ -0,0 +1,7 @@
>    > +
>    > +Example:
>    > +       usclk: usclk {
>    > +               compatible = "clk-userspace";
>    > +               clocks = <&foo 15>, <&bar>;
>    > +               clock-count = <2>;
>    > +       };
>    > diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>    > index 0357ac4..b35b62c 100644
>    > --- a/drivers/clk/Kconfig
>    > +++ b/drivers/clk/Kconfig
>    > @@ -81,6 +81,15 @@ config COMMON_CLK_AXI_CLKGEN
>    >           Support for the Analog Devices axi-clkgen pcore clock
>    generator for Xilinx
>    >           FPGAs. It is commonly used in Analog Devices' reference
>    designs.
>    >
>    > +config COMMON_CLK_USERSPACE
>    > +       bool "Userspace Clock Controls"
>    > +       depends on OF
>    > +       depends on SYSFS
>    > +       help
>    > +       ---help---
>    > +         Expose clock controls through sysfs to userspace. Clocks are
>    selected
>    > +         through the device tree and the controls are exposed in
>    > +         /sys/class/clk.
>    >  endmenu
>    >
>    >  source "drivers/clk/mvebu/Kconfig"
>    > diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>    > index fa435bc..f2f68c8 100644
>    > --- a/drivers/clk/Makefile
>    > +++ b/drivers/clk/Makefile
>    > @@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)        += clk-fixed-rate.o
>    >  obj-$(CONFIG_COMMON_CLK)       += clk-gate.o
>    >  obj-$(CONFIG_COMMON_CLK)       += clk-mux.o
>    >  obj-$(CONFIG_COMMON_CLK)       += clk-composite.o
>    > +obj-$(CONFIG_COMMON_CLK_USERSPACE) += clk-userspace.o
>    >
>    >  # SoCs specific
>    >  obj-$(CONFIG_ARCH_BCM2835)     += clk-bcm2835.o
>    > diff --git a/drivers/clk/clk-userspace.c b/drivers/clk/clk-userspace.c
>    > new file mode 100644
>    > index 0000000..931cf92
>    > --- /dev/null
>    > +++ b/drivers/clk/clk-userspace.c
>    > @@ -0,0 +1,169 @@
>    > +/*
>    > + * Userspace clock driver
>    > + *
>    > + *  Copyright (C) 2013 Xilinx
>    > + *
>    > + *  Sören Brinkmann <soren.brinkmann@xilinx.com>
>    > + *
>    > + * This program is free software: you can redistribute it and/or modify
>    > + * it under the terms of the GNU General Public License v2 as published
>    by
>    > + * the Free Software Foundation.
>    > + *
>    > + * This program is distributed in the hope that it will be useful,
>    > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>    > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>    > + * GNU General Public License for more details.
>    > + *
>    > + * You should have received a copy of the GNU General Public License
>    > + * along with this program.  If not, see
>    <http://www.gnu.org/licenses/>.
>    > + *
>    > + * Expose clock controls through sysfs to userspace.
>    > + *
>    > + * By writing 0/1 to 'enable' the clock can be disabled/enabled.
>    Reading
>    > + * that file returns the current state - 0 = disabled, 1 = enabled.
>    > + *
>    > + * Reading 'set_rate' returns the current clock frequency in Hz.
>    Writing
>    > + * the file requests setting a new frequency in Hz.
>    > + */
>    > +
>    > +#include <linux/clk-provider.h>
>    > +#include <linux/fs.h>
>    > +#include <linux/module.h>
>    > +#include <linux/of.h>
>    > +#include <linux/device.h>
>    > +#include <linux/slab.h>
>    > +
>    > +#define DRIVER_NAME    "clk-userspace"
>    > +
>    > +struct usclk_data {
>    > +       struct clk *clk;
>    > +       int enabled;
>    > +};
>    > +
>    > +static ssize_t enable_show(struct device *dev, struct device_attribute
>    *attr,
>    > +               char *buf)
>    > +{
>    > +       struct usclk_data *pdata = dev_get_drvdata(dev);
>    > +
>    > +       return scnprintf(buf, PAGE_SIZE, "%u\n", pdata->enabled);
>    > +}
>    > +
>    > +static ssize_t enable_store(struct device *dev, struct device_attribute
>    *attr,
>    > +               const char *buf, size_t count)
>    > +{
>    > +       unsigned long enable;
>    > +       int ret;
>    > +       struct usclk_data *pdata = dev_get_drvdata(dev);
>    > +
>    > +       ret = kstrtoul(buf, 0, &enable);
> 
>    strbool()?
Can you explain this a little more, please? I grepped the kernel sources for
'strbool' and didn't get a single match.

	Sören



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaH0LWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:22:14 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:55189 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaH0LWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:22:12 -0400
Message-ID: <53FDBF59.1050001@codethink.co.uk>
Date: Wed, 27 Aug 2014 12:22:01 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v6 4/5] clk: RK808: Add clkout driver for RK808
References: <1409062589-12157-1-git-send-email-zyw@rock-chips.com> <CAD=FV=WS=FaJdDVomCo2FxnsoRxDAHNNK-VX75JLzBYHHGS8AA@mail.gmail.com>
In-Reply-To: <CAD=FV=WS=FaJdDVomCo2FxnsoRxDAHNNK-VX75JLzBYHHGS8AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 19:02, Doug Anderson wrote:
> Chris,
> 
> On Tue, Aug 26, 2014 at 7:16 AM, Chris Zhong <zyw@rock-chips.com> wrote:
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>
>> ---
>>
>> Changes in v6:
>> Adviced by doug
>> - use correct argument call of_clk_add_provider in probe
>>
>> Changes in v5:
>> Adviced by doug
>> - add some error checking in probe
>> - move "rockchip,rk808.h" into the patch about dt-bindings
>>
>> Changes in v4:
>> Adviced by doug
>> - add "clock-output-names" propertiey
>> - add a header file "rockchip,rk808.h"
>>
>> Changes in v3:
>> - fix compile err
>>
>> Changes in v2:
>> Adviced by javier.martinez
>> - separated from rtc-rk808.
>>
>>  drivers/clk/Kconfig     |    9 +++
>>  drivers/clk/Makefile    |    1 +
>>  drivers/clk/clk-rk808.c |  163 +++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 173 insertions(+)
>>  create mode 100644 drivers/clk/clk-rk808.c
>>
>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>> index cfd3af7..84e0590 100644
>> --- a/drivers/clk/Kconfig
>> +++ b/drivers/clk/Kconfig
>> @@ -38,6 +38,15 @@ config COMMON_CLK_MAX77686
>>         ---help---
>>           This driver supports Maxim 77686 crystal oscillator clock.
>>
>> +config COMMON_CLK_RK808
>> +       tristate "Clock driver for RK808"
>> +       depends on MFD_RK808
>> +       ---help---
>> +         This driver supports RK808 crystal oscillator clock. These
>> +         multi-function devices have two fixed-rate oscillators,
>> +         clocked at 32KHz each. Clkout1 is always on, Clkout2 can off
>> +         by control register.
>> +
>>  config COMMON_CLK_SI5351
>>         tristate "Clock driver for SiLabs 5351A/B/C"
>>         depends on I2C
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index f537a0b..99f53d5 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -28,6 +28,7 @@ obj-$(CONFIG_ARCH_NOMADIK)            += clk-nomadik.o
>>  obj-$(CONFIG_ARCH_NSPIRE)              += clk-nspire.o
>>  obj-$(CONFIG_COMMON_CLK_PALMAS)                += clk-palmas.o
>>  obj-$(CONFIG_CLK_PPC_CORENET)          += clk-ppc-corenet.o
>> +obj-$(CONFIG_COMMON_CLK_RK808)         += clk-rk808.o
>>  obj-$(CONFIG_COMMON_CLK_S2MPS11)       += clk-s2mps11.o
>>  obj-$(CONFIG_COMMON_CLK_SI5351)                += clk-si5351.o
>>  obj-$(CONFIG_COMMON_CLK_SI570)         += clk-si570.o
>> diff --git a/drivers/clk/clk-rk808.c b/drivers/clk/clk-rk808.c
>> new file mode 100644
>> index 0000000..21f8b54
>> --- /dev/null
>> +++ b/drivers/clk/clk-rk808.c
>> @@ -0,0 +1,163 @@
>> +/*
>> + * Clkout driver for Rockchip RK808
>> + *
>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Chris Zhong <zyw@rock-chips.com>
> 
> I probably would have removed "Author" here (like in other patches)
> since it's below in MODULE_AUTHOR.  ...but I'm not a huge stickler for
> it.
> 
> 
> 
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mfd/rk808.h>
>> +#include <linux/i2c.h>
>> +
>> +struct rk808_clkout {
>> +       struct rk808 *rk808;
>> +       struct clk_onecell_data clk_data;
>> +       struct clk_hw           clkout1_hw;
>> +       struct clk_hw           clkout2_hw;
>> +};
>> +
>> +static unsigned long rk808_clkout_recalc_rate(struct clk_hw *hw,
>> +                                             unsigned long parent_rate)
>> +{
>> +       return 32768;
>> +}
>> +

Given one of these is a fixed, ungatable clock then surely it would
be easier to use a separate fixed clock node for that and then just
have a none for the gated clock?


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

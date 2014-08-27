Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928AbaH0SbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:31:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58764 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935181AbaH0SbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:31:09 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>,
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
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v6 4/5] clk: RK808: Add clkout driver for RK808
Date: Wed, 27 Aug 2014 20:32:53 +0200
Message-ID: <5320662.uDieR7oLoG@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <53FDBF59.1050001@codethink.co.uk>
References: <1409062589-12157-1-git-send-email-zyw@rock-chips.com> <CAD=FV=WS=FaJdDVomCo2FxnsoRxDAHNNK-VX75JLzBYHHGS8AA@mail.gmail.com> <53FDBF59.1050001@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. August 2014, 12:22:01 schrieb Ben Dooks:
> >> diff --git a/drivers/clk/clk-rk808.c b/drivers/clk/clk-rk808.c
> >> new file mode 100644
> >> index 0000000..21f8b54
> >> --- /dev/null
> >> +++ b/drivers/clk/clk-rk808.c
> >> @@ -0,0 +1,163 @@
> >> +/*
> >> + * Clkout driver for Rockchip RK808
> >> + *
> >> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> >> + *
> >> + * Author: Chris Zhong <zyw@rock-chips.com>
> > 
> > I probably would have removed "Author" here (like in other patches)
> > since it's below in MODULE_AUTHOR.  ...but I'm not a huge stickler for
> > it.
> > 
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> it
> >> + * under the terms and conditions of the GNU General Public License,
> >> + * version 2, as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope it will be useful, but
> >> WITHOUT
> >> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> >> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> >> for + * more details.
> >> + */
> >> +
> >> +#include <linux/clk.h>
> >> +#include <linux/clk-provider.h>
> >> +#include <linux/module.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/mfd/rk808.h>
> >> +#include <linux/i2c.h>
> >> +
> >> +struct rk808_clkout {
> >> +       struct rk808 *rk808;
> >> +       struct clk_onecell_data clk_data;
> >> +       struct clk_hw           clkout1_hw;
> >> +       struct clk_hw           clkout2_hw;
> >> +};
> >> +
> >> +static unsigned long rk808_clkout_recalc_rate(struct clk_hw *hw,
> >> +                                             unsigned long parent_rate)
> >> +{
> >> +       return 32768;
> >> +}
> >> +
> 
> Given one of these is a fixed, ungatable clock then surely it would
> be easier to use a separate fixed clock node for that and then just
> have a none for the gated clock?

Hmm, with the devicetree being supposed to describe the hardware, I guess this 
is debatable. As both clocks are provided by the rk808 chip, I guess the clock 
references for both also should point there and not some arbitary fixed clock 
somewhere else in the dt?

But this view could also be to pendantic :-) .

Maybe the dt maintainers can shed some light on this.

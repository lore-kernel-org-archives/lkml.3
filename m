Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaHZRIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:08:11 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:59247 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHZRIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 26 Aug 2014 10:08:08 -0700
X-Google-Sender-Auth: HJZbMsCpP7qctgLcnpwo50zpcoI
Message-ID: <CAD=FV=X1GY+uUqt7fHETnt=qmPpLp+qtasvVZN8dXC4gxTYX-g@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Aug 26, 2014 at 7:14 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> +static struct regmap_irq_chip rk808_irq_chip = {
> +       .name = "rk808",
> +       .irqs = rk808_irqs,
> +       .num_irqs = ARRAY_SIZE(rk808_irqs),
> +       .num_regs = 2,
> +       .irq_reg_stride = 2,
> +       .status_base = RK808_INT_STS_REG1,
> +       .mask_base = RK808_INT_STS_MSK_REG1,
> +       .ack_base = RK808_INT_STS_REG1,

Can you add ".init_ack_masked = true" here?  If I don't do that and I
boot with the IRQ configured as "level low" then the system will just
keep getting IRQs that it can't handle and eventually disable the
whole rk808.  If I boot with the IRQ as "falling edge" then the system
will never get RTC alarms.

I posted this fixup with an explanation at
<https://chromium-review.googlesource.com/#/c/214241/> and it could be
squashed into your patch.

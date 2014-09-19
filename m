Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbaISUW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:22:58 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:50747 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaISUWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <1411113739-1934-2-git-send-email-zyw@rock-chips.com>
References: <1411113739-1934-1-git-send-email-zyw@rock-chips.com>
	<1411113739-1934-2-git-send-email-zyw@rock-chips.com>
Date: Fri, 19 Sep 2014 13:22:54 -0700
X-Google-Sender-Auth: GR4e7byLivApDf0p82mUQRf6244
Message-ID: <CAD=FV=Vm-XgNvfQjtaXML3_1ROoir5Kv2fosSr94jkcG6K3P6A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] regulator: st-pwm: get voltage and duty table from dts
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Fri, Sep 19, 2014 at 1:02 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Get voltage & duty table from device tree might be better, other platforms can also use this
> driver without any modify.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v3:
> Adviced by Doug Anderson
> - Make Kconfig & Makefile alphabetical
> - remove pwm_reg_period from pwm_regulator_data
> - modify the calculation in pwm_regulator_set_voltage_sel
> - add length validity check
>
> Changes in v2:
> Adviced by Lee Jones
> - rename the file
> - remove all the prefix st_
> - add depend on PWM in Kconfig
>
>  drivers/regulator/Kconfig         |   13 +--
>  drivers/regulator/Makefile        |    2 +-
>  drivers/regulator/pwm-regulator.c |  197 +++++++++++++++++++++++++++++++++++++
>  drivers/regulator/st-pwm.c        |  190 -----------------------------------
>  4 files changed, 205 insertions(+), 197 deletions(-)
>  create mode 100644 drivers/regulator/pwm-regulator.c
>  delete mode 100644 drivers/regulator/st-pwm.c
>
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index fb32bab..320751a 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -449,6 +449,13 @@ config REGULATOR_PFUZE100
>           Say y here to support the regulators found on the Freescale
>           PFUZE100/PFUZE200 PMIC.
>
> +config REGULATOR_PWM
> +       tristate "PWM voltage regulator"
> +       depends on PWM
> +       help
> +         This driver supports PWM controlled voltage regulators. Config PWM
> +         duty can increasing or decreasing the voltage.

Slightly more proper English:
        This driver supports PWM controlled voltage regulators. PWM
        duty cycle can increase or decrease the voltage.


> +static struct regulator_desc pwm_regulator_desc = {
> +       .name           = "pwm-regulator",
> +       .ops            = &pwm_regulator_voltage_ops,
> +       .type           = REGULATOR_VOLTAGE,
> +       .owner          = THIS_MODULE,
> +       .supply_name    = "pwm",
> +};

nit: the pwm_regulator_desc can now be "const".


Neither of those is huge.  If you get no other feedback, Mark could
maybe give advice on whether you should spin your series or whether
he'd like to fix them when he applies.

Reviewed-by: Doug Anderson <dianders@chromium.org>

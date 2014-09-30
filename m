Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaI3Qnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:43:50 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:38301 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaI3Qns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
References: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 30 Sep 2014 09:43:47 -0700
X-Google-Sender-Auth: HhhFOTMXthaEDk_D62PTWNcSthY
Message-ID: <CAD=FV=XViSBFyMEY9kQBMggnn+uA0wYarbseFOuZeakzBxZeqA@mail.gmail.com>
Subject: Re: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Sep 30, 2014 at 2:44 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> The min_uv in DCDC1 & DCDC2 should be 712.5mv
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
>  drivers/regulator/rk808-regulator.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
> index e305416..196a5c8 100644
> --- a/drivers/regulator/rk808-regulator.c
> +++ b/drivers/regulator/rk808-regulator.c
> @@ -44,7 +44,7 @@ static const int rk808_buck_config_regs[] = {
>  };
>
>  static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
> -       REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
> +       REGULATOR_LINEAR_RANGE(712500, 0, 63, 12500),
>  };

I have no problem with this (and the current "dts" file I see don't go
this low anyway), but it doesn't match the datasheet I have right now
which says "0.700 V" is the min.

-Doug

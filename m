Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaISU3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:29:39 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:41508 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966AbaISU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <1411113739-1934-3-git-send-email-zyw@rock-chips.com>
References: <1411113739-1934-1-git-send-email-zyw@rock-chips.com>
	<1411113739-1934-3-git-send-email-zyw@rock-chips.com>
Date: Fri, 19 Sep 2014 13:29:34 -0700
X-Google-Sender-Auth: Ghvo51wyayffFu9Wl6fgxo9tOx0
Message-ID: <CAD=FV=Utonj4PJXMwbs7pJKOqdr3ztAd62OUabj_uMcYXdZkjg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dt-bindings: add devicetree bindings for st-pwm regulator
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Fri, Sep 19, 2014 at 1:02 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Document the st-pwm regulator
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v3:
> Adviced by Doug Anderson
> - update the Example
>
> Changes in v2:
> Adviced by Lee Jones
> - rename the documentation
> Adviced by Doug Anderson
> - update the example
> Adviced by Mark Rutland
> - remove pwm-reg-period
>
>  .../bindings/regulator/pwm-regulator.txt           |   29 ++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulator.txt
>
> diff --git a/Documentation/devicetree/bindings/regulator/pwm-regulator.txt b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> new file mode 100644
> index 0000000..eb46f7b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> @@ -0,0 +1,29 @@
> +pwm regulator bindings
> +
> +Required properties:
> +- compatible: Should be "pwm-regulator"
> +- pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
> +- voltage-table: voltage and duty table, include 2 merbers in each set of
> +  brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
> +
> +Any property defined as part of the core regulator binding defined in
> +regulator.txt can also be used.
> +
> +Example:
> +       pwm_regulator {
> +               compatible = "pwm-regulator;
> +               pwms = <&pwm1 0 8448 0>;
> +
> +               voltage-table = <1114000 0>,
> +                               <1095000 10>,
> +                               <1076000 20>,
> +                               <1056000 30>,
> +                               <1036000 40>,
> +                               <1016000 50>;
> +
> +               regulator-always-on;
> +               regulator-boot-on;

I think Mark suggested that the two properties above were not useful
on a regulator that is always enabled.  That seems to match the code:

/* If we don't know then assume that the regulator is always on */
if (!rdev->desc->ops->is_enabled)
  return 1;

...so I'd remove them from your example...

Again, if there's no additional feedback you'd need Mark's advice
about whether he wants a respin.

Reviewed-by: Doug Anderson <dianders@chromium.org>

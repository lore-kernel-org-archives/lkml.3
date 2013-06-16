Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3FPKfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:35:45 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:45073 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3FPKfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <201306141744.21117.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306141744.21117.heiko@sntech.de>
Date: Sun, 16 Jun 2013 12:35:43 +0200
Message-ID: <CACRpkdY6pmS=5rphvYdt_8yKYJq8ADu0omy48ncZ3LFtEUf7yg@mail.gmail.com>
Subject: Re: [PATCH 5/5] pinctrl: rockchip: correctly handle arguments of
 pinconf options
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 5:44 PM, Heiko Stübner <heiko@sntech.de> wrote:

> Change the rockchip pinctrl driver to handle the arguments of 0 or 1 to
> the pull pinconfig options correctly, so that the pull gets disabled when
> either the bias_disable options is set or the pull option has the argument 0.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied so we can move ahead but:

>         case PIN_CONFIG_BIAS_PULL_UP:
>         case PIN_CONFIG_BIAS_PULL_DOWN:
>         case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
> +               if (!rockchip_pinconf_pull_valid(info->ctrl, param))
> +                       return -ENOTSUPP;
> +
> +               if (!arg)
> +                       param = PIN_CONFIG_BIAS_DISABLE;

This is what I think is counter-intuitive.

Can't you rely on the bias-disable here instead?

> -               *config = 0;
> +               pull = rockchip_get_pull(bank, pin - bank->pin_base);
> +               *config = (pull == param) ? 1 : 0;

And then I guess you should emit PIN_CONFIG_BIAS_DISABLE
here as well.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaAWInJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:43:09 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58520 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaAWInH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:43:07 -0500
MIME-Version: 1.0
In-Reply-To: <1390458701-30238-1-git-send-email-linux@prisktech.co.nz>
References: <1390458701-30238-1-git-send-email-linux@prisktech.co.nz>
Date: Thu, 23 Jan 2014 09:43:07 +0100
Message-ID: <CACRpkdaFJphJdf6hyKoYEZ_wXikwRiwzMgtL=hY+3B8WrBnQaw@mail.gmail.com>
Subject: Re: [PATCH] vt8500: pinctrl: Change devicetree data parsing
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 7:31 AM, Tony Prisk <linux@prisktech.co.nz> wrote:

> Due to an assumption in the VT8500 pinctrl driver, the value passed
> from devicetree for 'wm,pull' was not explicitly translated before
> being passed to pinconf.
>
> With changes to 'enum pin_config_param', PIN_CONFIG_BIAS_PULL_(UP/DOWN)
> no longer map 1-to-1 with the expected values in devicetree.
>
> This patch adds a small translation between the devicetree values (0..2)
> and the enum pin_config_param equivalent values.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Isn't this a regression fix for stable?

> +       switch (pull) {
> +       case 0:
> +               pull = PIN_CONFIG_BIAS_DISABLE;
> +               break;
> +       case 1:
> +               pull = PIN_CONFIG_BIAS_PULL_DOWN;
> +               break;
> +       case 2:
> +               pull = PIN_CONFIG_BIAS_PULL_UP;
> +               break;
> +       }
>         configs[0] = pull;

1. You're not adding a default: clause (I bet the static checkers will
warn about this!)

2. Please conjure a different variable name for the thing that
actually gets set in the config so we see we are mapping one
thing to another and not just altering an existing variable.

Yours,
Linus Walleij

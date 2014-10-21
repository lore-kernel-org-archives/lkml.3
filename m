Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaJUQcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:32:15 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41666 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaJUQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <1413847670-12245-2-git-send-email-dianders@chromium.org>
References: <1413847670-12245-1-git-send-email-dianders@chromium.org>
	<1413847670-12245-2-git-send-email-dianders@chromium.org>
Date: Tue, 21 Oct 2014 09:32:11 -0700
X-Google-Sender-Auth: 8x3UZSYjtdi586B0Mv3BVLiotZ4
Message-ID: <CAD=FV=X4ZC9Nh2z6vtGwH1v3pGefGgeDw-JjA6R06XJmmvOFGQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: rockchip: Don't call pinctrl_gpio_direction_output()
 in pin_config_set()
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 20, 2014 at 4:27 PM, Doug Anderson <dianders@chromium.org> wrote:
> @@ -959,9 +968,10 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
>                                 return rc;
>                         break;
>                 case PIN_CONFIG_OUTPUT:
> -                       rc = rockchip_gpio_direction_output(&bank->gpio_chip,
> -                                                           pin - bank->pin_base,
> -                                                           arg);
> +                       rockchip_gpio_set(&bank->gpio_chip,
> +                                         pin - bank->pin_base, arg);
> +                       rc = _rockchip_pmx_gpio_set_direction(&bank->gpio_chip,
> +                                         pin - bank->pin_base, false);

I think something here is not quite right.  I did more testing today
and noticed that I'm getting failures in some cases.  I think I've got
the offset wrong, but I'm digging.  Please hold off review of this
patch till the next version.

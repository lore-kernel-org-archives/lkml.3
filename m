Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaJVETg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:19:36 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45956 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaJVETe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <1413933557-25684-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
	<1413933557-25684-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 21 Oct 2014 21:19:33 -0700
X-Google-Sender-Auth: dJ5PvrCvT-CnN02Z6UtyyosvZ78
Message-ID: <CAD=FV=WZtcOcAQDyMDNPFdMz6P9ZSqkUPZ52UgecZbSXU92mzg@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] pinctrl: rockchip: add suspend/resume functions
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Oct 21, 2014 at 4:19 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> From: Chris <zyw@rock-chips.com>

I think your git is misconfigured.  The above "From" line will make
the author end up without your last name.  Heiko mentioned this in v4.

> diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
> index 016f457..c4a988d 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1770,6 +1770,25 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
>         return ctrl;
>  }
>
> +#ifdef CONFIG_PM_SLEEP
> +static int rockchip_pinctrl_suspend(struct device *dev)

Why didn't you take Dmitry's suggestion from v3?  I think you can get
rid of the #ifdef and add the "__maybe_unused" annotation to avoid
errors when PM_SLEEP isn't defined.

This does work, though, so:

Tested-by: Doug Anderson <dianders@chromium.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbaIWQGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:06:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38199 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaIWQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <1411473545-3290-4-git-send-email-heiko@sntech.de>
References: <1411473545-3290-1-git-send-email-heiko@sntech.de>
	<1411473545-3290-4-git-send-email-heiko@sntech.de>
Date: Tue, 23 Sep 2014 09:06:34 -0700
X-Google-Sender-Auth: uhtjOFGslbTrUCyp0gygjtMr_qo
Message-ID: <CAD=FV=UNK4oGP9Vj7TeKMDqAPmEvbqRfVE8uu9ZtO4pfDbE=cQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] power: gpio-charger: do not use gpio value directly
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: sre@kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Heiko Stuebner <heiko.stuebner@bq.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Sep 23, 2014 at 4:59 AM, Heiko Stuebner <heiko@sntech.de> wrote:
> From: Heiko Stuebner <heiko.stuebner@bq.com>
>
> Some gpio implementations return interesting values for gpio_get_value when
> the value is not 0 - as seen on a imx6sl board. Therefore do not use the
> value returned from gpio_get_value directly but simply check for 0 or not 0.
>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
> ---
>  drivers/power/gpio-charger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 22f084a..7d4eab2 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -57,7 +57,7 @@ static int gpio_charger_get_property(struct power_supply *psy,
>
>         switch (psp) {
>         case POWER_SUPPLY_PROP_ONLINE:
> -               val->intval = gpio_get_value_cansleep(pdata->gpio);
> +               val->intval = !!gpio_get_value_cansleep(pdata->gpio);
>                 val->intval ^= pdata->gpio_active_low;

...so I guess the interface is that gpio_active_low must be exactly 1
or 0.  Oh, and that's actually defined in gpio-charger.h!  I should
have checked that before.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3AZObB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:31:01 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44678 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3AZObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:31:00 -0500
MIME-Version: 1.0
In-Reply-To: <1359192670-22543-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359192670-22543-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Sat, 26 Jan 2013 11:30:59 -0300
Message-ID: <CALF0-+UT+dX=a6NAufEsQ9HgWQevnKW4W26fSHLq1FRuVHht9w@mail.gmail.com>
Subject: Re: [PATCHv3] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Sat, Jan 26, 2013 at 6:31 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> The IP responsible for the muxing on the Allwinner SoCs are also
> handling the GPIOs on the system. This patch adds the needed driver that
> relies on the pinctrl driver for most of its operations.
>
> The number of pins available for GPIOs operations are already declared
> in the pinctrl driver, we only need to probe a generic driver to handle
> the banks available for each SoC.
>
> This driver has been tested on a A13-Olinuxino.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
> Changes from v2:
>   - Removed the call to kzalloc to build the pin name
>
>  drivers/pinctrl/pinctrl-sunxi.c |  134 ++++++++++++++++++++++++++++++++++++++-
>  drivers/pinctrl/pinctrl-sunxi.h |   25 +++++++-
>  2 files changed, 156 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
> index 6f02e34..4ed0e7e 100644
> --- a/drivers/pinctrl/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/pinctrl-sunxi.c
> @@ -11,6 +11,7 @@
>   */
>
>  #include <linux/io.h>
> +#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> @@ -609,11 +610,53 @@ static int sunxi_pmx_enable(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> +static int
> +sunxi_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> +                       struct pinctrl_gpio_range *range,
> +                       unsigned offset,
> +                       bool input)
> +{
> +       struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +       struct sunxi_desc_function *desc;
> +       char pin_name[SUNXI_PIN_NAME_MAX_LEN];
> +       char *func;

Nitpick: const char *func.

-- 
    Ezequiel

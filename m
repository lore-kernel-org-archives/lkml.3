Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaKVNiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 08:38:19 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:50668 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaKVNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 08:38:16 -0500
MIME-Version: 1.0
In-Reply-To: <1416576954-11997-2-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com> <1416576954-11997-2-git-send-email-gautam.vivek@samsung.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Sat, 22 Nov 2014 19:07:35 +0530
Message-ID: <CAGOxZ53d_Vk1cF8Y2LNgMNeuCFeQJKmHQeN19pO5HfAdp4hx8A@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: exynos: Add BUS1 pin controller for exynos7
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com, linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, robh+dt@kernel.org,
        stern@rowland.harvard.edu, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Fri, Nov 21, 2014 at 7:05 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> USB and Power regulator on Exynos7 require gpios available
> in BUS1 pin controller block.
> So adding the BUS1 pinctrl support.
>
> Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/samsung/pinctrl-exynos.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
> index d5d4cfc..caca5b5 100644
> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
> @@ -1300,6 +1300,13 @@ static const struct samsung_pin_bank_data exynos7_pin_banks7[] __initconst = {
>         EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr3", 0x0c),
>  };
>
> +/* pin banks of exynos7 pin-controller - BUS1 */
> +static const struct samsung_pin_bank_data exynos7_pin_banks8[] __initconst = {
> +       EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpf0", 0x00),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpf4", 0x10),
> +       EXYNOS_PIN_BANK_EINTG(6, 0x120, "gph1", 0x20),
> +};
> +
Looks like you are just trying to touch pin banks only related to USB
stuffs, but as this patch does not have any dependencies on other
patches in this series, will you consider adding other pin banks of
BUS1, just for completeness of BUS1 pin-controller.

>  const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
>         {
>                 /* pin-controller instance 0 Alive data */
> @@ -1342,5 +1349,10 @@ const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
>                 .pin_banks      = exynos7_pin_banks7,
>                 .nr_banks       = ARRAY_SIZE(exynos7_pin_banks7),
>                 .eint_gpio_init = exynos_eint_gpio_init,
> +       }, {
> +               /* pin-controller instance 8 BUS1 data */
> +               .pin_banks      = exynos7_pin_banks8,
> +               .nr_banks       = ARRAY_SIZE(exynos7_pin_banks8),
> +               .eint_gpio_init = exynos_eint_gpio_init,
>         },
>  };
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim

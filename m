Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552AbaDJCJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 22:09:37 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63319 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbaDJCJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 22:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <1396960063-30552-1-git-send-email-linus.walleij@linaro.org>
References: <1396960063-30552-1-git-send-email-linus.walleij@linaro.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 10 Apr 2014 10:08:50 +0800
X-Google-Sender-Auth: xBtFRLAUG3FLLeCwCsyluCAgWvQ
Message-ID: <CAGsJ_4wTq5R+Mt1N+3Fh6e_6XBigCKz=WiMx+e-Z6W9DE7YakA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: sirf: rename inlined accessor
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        linux-gpio@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-08 20:27 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
> The sirfsoc_irqchip_to_bank() is obviously misnamed, as it is
> not converting an irqchip to a bank but converts a gpiochip
> to a bank so rename it sirfsoc_gpiochip_to_bank().
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Barry Song <Baohua.Song@csr.com>

Thanks, linus.

> ---
>  drivers/pinctrl/sirf/pinctrl-sirf.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
> index 76502aab2cb1..2c3eb207ff87 100644
> --- a/drivers/pinctrl/sirf/pinctrl-sirf.c
> +++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
> @@ -483,7 +483,7 @@ static inline struct sirfsoc_gpio_bank *sirfsoc_gpio_to_bank(unsigned int gpio)
>         return &sgpio_bank[gpio / SIRFSOC_GPIO_BANK_SIZE];
>  }
>
> -static inline struct sirfsoc_gpio_bank *sirfsoc_irqchip_to_bank(struct gpio_chip *chip)
> +static inline struct sirfsoc_gpio_bank *sirfsoc_gpiochip_to_bank(struct gpio_chip *chip)
>  {
>         return container_of(to_of_mm_gpio_chip(chip), struct sirfsoc_gpio_bank, chip);
>  }
> @@ -675,7 +675,7 @@ static inline void sirfsoc_gpio_set_input(struct sirfsoc_gpio_bank *bank, unsign
>
>  static int sirfsoc_gpio_request(struct gpio_chip *chip, unsigned offset)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_irqchip_to_bank(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(chip);
>         unsigned long flags;
>
>         if (pinctrl_request_gpio(chip->base + offset))
> @@ -697,7 +697,7 @@ static int sirfsoc_gpio_request(struct gpio_chip *chip, unsigned offset)
>
>  static void sirfsoc_gpio_free(struct gpio_chip *chip, unsigned offset)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_irqchip_to_bank(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(chip);
>         unsigned long flags;
>
>         spin_lock_irqsave(&bank->lock, flags);
> @@ -712,7 +712,7 @@ static void sirfsoc_gpio_free(struct gpio_chip *chip, unsigned offset)
>
>  static int sirfsoc_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_irqchip_to_bank(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(chip);
>         int idx = sirfsoc_gpio_to_offset(gpio);
>         unsigned long flags;
>         unsigned offset;
> @@ -751,7 +751,7 @@ static inline void sirfsoc_gpio_set_output(struct sirfsoc_gpio_bank *bank, unsig
>
>  static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio, int value)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_irqchip_to_bank(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(chip);
>         int idx = sirfsoc_gpio_to_offset(gpio);
>         u32 offset;
>         unsigned long flags;
> @@ -769,7 +769,7 @@ static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
>
>  static int sirfsoc_gpio_get_value(struct gpio_chip *chip, unsigned offset)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_irqchip_to_bank(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(chip);
>         u32 val;
>         unsigned long flags;
>
> @@ -785,7 +785,7 @@ static int sirfsoc_gpio_get_value(struct gpio_chip *chip, unsigned offset)
>  static void sirfsoc_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>         int value)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_irqchip_to_bank(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(chip);
>         u32 ctrl;
>         unsigned long flags;
>
> --
> 1.9.0
>

-barry

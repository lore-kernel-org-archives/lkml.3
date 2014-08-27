Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022AbaH0VY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:24:58 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35735 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935917AbaH0VYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:24:55 -0400
MIME-Version: 1.0
In-Reply-To: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 27 Aug 2014 14:24:53 -0700
Message-ID: <CAJAp7OhnUD3oSLfcRMD3veSJhVQLZdW1FPb8grOYqN5Gh3Oagw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: Release pin ranges when
 gpiochip_irqchip_add fails
From: Bjorn Andersson <bjorn@kryo.se>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:57 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
> This patches adds a call to gpiochip_remove_pin_ranges when
> gpiochip_irqchip_add fails to release memory allocated for pin_ranges.
>
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -845,6 +845,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>                                    IRQ_TYPE_NONE);
>         if (ret) {
>                 dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
> +               gpiochip_remove_pin_ranges(chip);
>                 return -ENOSYS;
>         }

Good catch, I guess this was lost in the introduction of gpiochip_irqchip...


Rather than just releasing the pin_ranges of the gpio_chip you should
probably add a gpiochip_remove() both here and in the case of
gpiochip_add_pin_range() failing.

Regards,
Bjorn

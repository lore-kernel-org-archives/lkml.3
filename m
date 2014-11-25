Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaKYTz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:55:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60777 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKYTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:55:55 -0500
MIME-Version: 1.0
In-Reply-To: <1386295805-13708-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1386295805-13708-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 25 Nov 2014 13:55:53 -0600
Message-ID: <CAOZdJXW_udiy6zYEUqJGqvdd5r4OuSzHk=u1f+tgZhRgoHNLCg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] pinctrl: Add Qualcomm TLMM driver
From: Timur Tabi <timur@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, linux-doc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 8:10 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
>
> +static int msm_gpio_init(struct msm_pinctrl *pctrl)
> +{
> +       struct gpio_chip *chip;
> +       int irq;
> +       int ret;
> +       int i;
> +       int r;
> +
> +       chip = &pctrl->chip;
> +       chip->base = 0;
> +       chip->ngpio = pctrl->soc->ngpios;

I know this patch is a year old, but I'm wondering if this line is correct.

The original version of your patch from 11/23/13 said this:

+       chip->ngpio = pctrl->soc->gpio_range->npins;

and today, the line is this:

    unsigned ngpio = pctrl->soc->ngpios;

I'm wondering if this line should be instead:

    unsigned ngpio = pctrl->soc->npins;

I'm confused about the difference between msm_pinctrl_soc_data.npins
and msm_pinctrl_soc_data.ngpios.  Variable "ngpio" is used by
gpiochip_add(), so I think it's not concerned with pin control.
msm_pinctrl_soc_data.npins appears to be the number of GPIOs, whereas
msm_pinctrl_soc_data.ngpios appears to be the number of pin groups.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

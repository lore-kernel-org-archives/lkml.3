Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3FXL3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:29:41 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51235 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXL3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:29:40 -0400
MIME-Version: 1.0
In-Reply-To: <1371737145-27662-2-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
	<1371737145-27662-2-git-send-email-patrice.chotard.st@gmail.com>
Date: Mon, 24 Jun 2013 13:29:39 +0200
Message-ID: <CACRpkdaAT4vEtthPgfd=yptpoK9GPdMx5w6VaQNe0+2WySwy1g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pinctrl: abx500: suppress hardcoded value
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice Chotard <patrice.chotard.st@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 4:05 PM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> Replace hardcoded value by corresponding #define's.
>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

This is not so good. The commit message is saying it
replaces values by #defines but is actually replacing it
by an enum.

Then you're in each instance calling

abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
                unsigned offset, int val)

The last argument is a hardware register value, but here you
case an enum abx500_gpio_direction to an integer and pass
to this function.

It would be better if the patch did what it says: create a
#define for ABX500_GPIO_INPUT and ABX500_GPIO_OUTPUT
locally in drivers/pinctrl/pinctrl-abx500.c and use it locally
instead of touching <mfd/abx500/ab8500-gpio.h>.

Thanks,
Linus Walleij

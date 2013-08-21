Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3HUVmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:42:12 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:57771 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:42:11 -0400
MIME-Version: 1.0
In-Reply-To: <1376878066.10251.4.camel@phoenix>
References: <1376877989.10251.2.camel@phoenix>
	<1376878066.10251.4.camel@phoenix>
Date: Wed, 21 Aug 2013 23:42:09 +0200
Message-ID: <CACRpkdauvk4Gw_k6TaYSH32nA66M_MHHksx6ESrqYx1PetWdug@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: core: Add proper mutex lock in pinctrl_request_gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Patrice Chotard <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 4:07 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This one is missed in commit 42fed7ba "pinctrl: move subsystem mutex to
> pinctrl_dev struct".

I think this was never there.

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 53c40d9..92f86ab 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -562,11 +562,15 @@ int pinctrl_request_gpio(unsigned gpio)
>                 return ret;
>         }
>
> +       mutex_lock(&pctldev->mutex);
> +
>         /* Convert to the pin controllers number space */
>         pin = gpio_to_pin(range, gpio);
>
>         ret = pinmux_request_gpio(pctldev, range, pin, gpio);
>
> +       mutex_unlock(&pctldev->mutex);
> +
>         return ret;

What is this protecting against?

I'm not sure I follow this so better ask.

Yours,
Linus Walleij

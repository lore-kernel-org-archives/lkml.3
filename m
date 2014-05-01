Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaEAGCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:02:30 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:59276 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEAGC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <1398438606-19718-2-git-send-email-thierry.reding@gmail.com>
References: <1398438606-19718-1-git-send-email-thierry.reding@gmail.com> <1398438606-19718-2-git-send-email-thierry.reding@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 1 May 2014 15:02:07 +0900
Message-ID: <CAAVeFuJCMyqJAY40QJZjn8igjzc1dcRLusiDQ3b4znQFKfvwRA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: Add helpers for optional GPIOs
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 12:10 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> Introduce gpiod_get_optional() and gpiod_get_index_optional() helpers
> that make it easier for drivers to handle optional GPIOs.
>
> Currently in order to handle optional GPIOs, a driver needs to special
> case error handling for -ENOENT, such as this:
>
>         gpio = gpiod_get(dev, "foo");
>         if (IS_ERR(gpio)) {
>                 if (PTR_ERR(gpio) != -ENOENT)
>                         return PTR_ERR(gpio);
>
>                 gpio = NULL;
>         }
>
>         if (gpio) {
>                 /* set up GPIO */
>         }
>
> With these new helpers the above is reduced to:
>
>         gpio = gpiod_get_optional(dev, "foo");
>         if (IS_ERR(gpio))
>                 return PTR_ERR(gpio);
>
>         if (gpio) {
>                 /* set up GPIO */
>         }
>
> While at it, device-managed variants of these functions are also
> provided.

Patch is sound and the introduced functions are useful indeed.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

It makes me wonder whether this should not have been the behavior of
gpiod_get() directly... My aversion for IS_ERR_OR_NULL drove the
current design, which may not have been optimal.

Oh, well.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab3BNDBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:01:16 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35462 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3BNDBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:01:15 -0500
MIME-Version: 1.0
In-Reply-To: <511C187D.7040305@gmail.com>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
 <1360738983-22436-2-git-send-email-gnurou@gmail.com> <511C187D.7040305@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 14 Feb 2013 12:00:54 +0900
Message-ID: <CAAVeFuKz5BzqW7QTgmNKM_jFkZBNNbF0D7t6QjSoasre5nih-A@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpiolib: check descriptors validity before use
To: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 7:49 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> Is it really useful to use the same pr_debug for the error case? Why not do:
>
>         desc = gpio_to_desc(gpio);
>         if (!desc) {
>                 pr_debug("%s - Invalid gpio %d\n", __func__, gpio);
>                 return -EINVAL;
>         }
>
>         ...
>
> At this point desc is known valid, though you could just use the gpio
> number that was passed in (assuming that it is always the same as
> desc_to_gpio).
>
>         pr_debug("%s: gpio%d status %d\n", __func__,
>                  desc_to_gpio(desc), status);
>         return status;
>
> That provides more information (the original gpio number and the reason
> for the -EINVAL) if the gpio is not valid, and removes the ugly ternary
> operator from the pr_debug. Same goes for the other functions.

That's mainly a style issue - I tried to preserve the code's behavior
as much as possible with these patches. But indeed the invalid GPIO
case is special, and on second thought identifying invalid GPIOs are
"gpio-1" is confusing. One could also say horrible.

Guess this deserves to be fixed in a v2. Thanks.

Alex.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3BERA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:00:59 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:39148 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3BERA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:00:57 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-3-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-3-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 18:00:56 +0100
Message-ID: <CACRpkdZDtJ3AN+Pgxy9nNgVx_YYTC=7AuDC48w7kDbDAeqdufw@mail.gmail.com>
Subject: Re: [PATCH 1/9] gpiolib: link all gpio_chips using a list
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Add a list member to gpio_chip that allows all chips to be parsed
> quickly. The current method requires parsing the entire GPIO integer
> space, which is painfully slow. Using a list makes many chip operations
> that involve lookup or parsing faster, and also simplifies the code. It
> is also necessary to eventually get rid of the global gpio_desc[] array.
>
> The list of gpio_chips is always ordered by base GPIO number to ensure
> chips traversal is done in the right order.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

OK!

> + * Return -EBUSY if the new chip overlaps with some other chip's integer
> + * space.
(...)
> +       /* are we stepping on the chip right before? */
> +       if (pos != &gpio_chips && pos->prev != &gpio_chips) {
> +               _chip = list_entry(pos->prev, struct gpio_chip, list);
> +               if (_chip->base + _chip->ngpio > chip->base) {
> +                       dev_err(chip->dev,
> +                              "GPIO integer space overlap, cannot add chip\n");
> +                       err = -EBUSY;
> +               }
> +       }

This robustness change on its own is a merit for merging the patch.
And keeping a list of gpiochips available is great for stuff like
debugfs.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

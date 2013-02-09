Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3BIKKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:10:12 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37409 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3BIKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:10:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/9] gpiolib: link all gpio_chips using a list
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
In-Reply-To: <CACRpkdZDtJ3AN+Pgxy9nNgVx_YYTC=7AuDC48w7kDbDAeqdufw@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-3-git-send-email-acourbot@nvidia.com> <CACRpkdZDtJ3AN+Pgxy9nNgVx_YYTC=7AuDC48w7kDbDAeqdufw@mail.gmail.com>
Date: Sat, 09 Feb 2013 09:20:38 +0000
Message-Id: <20130209092039.0C5D23E2548@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 18:00:56 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > Add a list member to gpio_chip that allows all chips to be parsed
> > quickly. The current method requires parsing the entire GPIO integer
> > space, which is painfully slow. Using a list makes many chip operations
> > that involve lookup or parsing faster, and also simplifies the code. It
> > is also necessary to eventually get rid of the global gpio_desc[] array.
> >
> > The list of gpio_chips is always ordered by base GPIO number to ensure
> > chips traversal is done in the right order.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> OK!
> 
> > + * Return -EBUSY if the new chip overlaps with some other chip's integer
> > + * space.
> (...)
> > +       /* are we stepping on the chip right before? */
> > +       if (pos != &gpio_chips && pos->prev != &gpio_chips) {
> > +               _chip = list_entry(pos->prev, struct gpio_chip, list);
> > +               if (_chip->base + _chip->ngpio > chip->base) {
> > +                       dev_err(chip->dev,
> > +                              "GPIO integer space overlap, cannot add chip\n");
> > +                       err = -EBUSY;
> > +               }
> > +       }
> 
> This robustness change on its own is a merit for merging the patch.
> And keeping a list of gpiochips available is great for stuff like
> debugfs.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.


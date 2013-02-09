Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526Ab3BINwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:52:09 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59023 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3BINwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:52:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <CAOh2x=ne_Oe7V=BzjQJtuPv20syorLTq-C89aKQDo4JK78Y8YA@mail.gmail.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de> <CAOh2x=ne_Oe7V=BzjQJtuPv20syorLTq-C89aKQDo4JK78Y8YA@mail.gmail.com>
Date: Sat, 09 Feb 2013 13:52:02 +0000
Message-Id: <20130209135202.C8EA73E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013 16:22:21 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On Mon, Jan 21, 2013 at 3:39 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
> > index 5f45fc4..7a4bf7c 100644
> > --- a/drivers/gpio/gpio-spear-spics.c
> > +++ b/drivers/gpio/gpio-spear-spics.c
> > @@ -140,11 +140,9 @@ static int spics_gpio_probe(struct platform_device *pdev)
> >                 return -ENOMEM;
> >         }
> >
> > -       spics->base = devm_request_and_ioremap(&pdev->dev, res);
> > -       if (!spics->base) {
> > -               dev_err(&pdev->dev, "request and ioremap fail\n");
> 
> can we keep it as is?

And this is why I dislike the ERR_PTR pattern so much. It goes against
every instinct about what is and is not a valid pointer.

I know people want error codes, but I think hoping that all users will
remember to do 'if (IS_ERR(ptr))' instead of 'if (!ptr)' makes things
worse not better.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3BKNxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:53:50 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:32775 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab3BKNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:53:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130209135202.C8EA73E30EC@localhost>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
	<CAOh2x=ne_Oe7V=BzjQJtuPv20syorLTq-C89aKQDo4JK78Y8YA@mail.gmail.com>
	<20130209135202.C8EA73E30EC@localhost>
Date: Mon, 11 Feb 2013 14:53:47 +0100
Message-ID: <CACRpkdaxxn9nWKjFF=XD5F2kus69-8uxqPWA1vt1RJ0aGJ-Mvw@mail.gmail.com>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 2:52 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, 21 Jan 2013 16:22:21 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>> > -       spics->base = devm_request_and_ioremap(&pdev->dev, res);
>> > -       if (!spics->base) {
>> > -               dev_err(&pdev->dev, "request and ioremap fail\n");
>>
>> can we keep it as is?
>
> And this is why I dislike the ERR_PTR pattern so much. It goes against
> every instinct about what is and is not a valid pointer.
>
> I know people want error codes, but I think hoping that all users will
> remember to do 'if (IS_ERR(ptr))' instead of 'if (!ptr)' makes things
> worse not better.

NB: among the error codes people want to propagate from
consumer interfaces such as say, clk_get(), regulator_get()
and pinctrl_get() is -EPROBE_DEFER. So just "something
failed" (return NULL) isn't enough.

We then obviously need to return an int as error code instead
and pass the pointer as argument, so do you mean we should
refactor all the *_get() things from e.g.:

struct clk *clk_get(struct device *dev, const char *id);

into something like:

int clk_get(struct clk **clk, struct device *dev, const char *id);

across the entire kernel?

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3K2UVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:21:47 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:46087 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3K2UVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:21:45 -0500
MIME-Version: 1.0
In-Reply-To: <201311281737.32696.arnd@arndb.de>
References: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
	<1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
	<201311281737.32696.arnd@arndb.de>
Date: Fri, 29 Nov 2013 21:21:44 +0100
Message-ID: <CACRpkda3bEmL+WRX1ct9SoUQOPXOT2mru0uz3-04nZB8G3DsvA@mail.gmail.com>
Subject: Re: [PATCH v6] gpio: Add MOXA ART GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 5:37 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 28 November 2013, Jonas Jensen wrote:
>> +static void __iomem *moxart_gpio_base;
>
> Just one comment: the usual way to do such a driver is to have
> a derived data structure like
>
> struct moxart_gpio_chip {
>         struct gpio_chip chip;
>         void __iomem *moxart_gpio_base;
> };
>
> and dynamically allocate that from probe(), using container_of() to
> get from the gpio_chip pointer to your own structure.

I see we make this comment a lot.

On my TODO there is an item to create
Documentation/driver-model/design-patterns.txt

And document things like this. And other fun stuff like
container_of().

What do you think about this idea?

Yours,
Linus Walleij

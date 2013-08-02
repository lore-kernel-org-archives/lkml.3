Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3HBPgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:36:35 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39793 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3HBPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:36:33 -0400
Message-ID: <51FBD1CA.1000202@ahsoftware.de>
Date: Fri, 02 Aug 2013 17:35:38 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <51F8CC35.1070704@collabora.co.uk> <51FB8292.9090000@ahsoftware.de>
In-Reply-To: <51FB8292.9090000@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.08.2013 11:57, schrieb Alexander Holler:

> There must have been a bug in the patch too. I've also added that
> iinterrupt-parent stuff (with the same flags as used by the driver) and
> just have let the driver call
> 
> request_threaded_irq(gpio_to_irq(gpio), flags);
> 
> without the gpio_request()/input() before. And request_threaded_irq()

Not to forget that it would/will be a big problem, if you will forbid
drivers to use gpio_request() when they use the gpio as irq (as it
was/is necessary now).

With my kernel 3.10.4 with some patches on top, I see
# git grep gpio_to_irq | wc -l
678

So there are a lot of places where

gpio_request();
gpio_direction_input()
request_irq();

would have been changed to

#ifdef CONFIG_OF_GPIO
gpio_request();
gpio_direction_input()
#endif
request_irq();

to not fail during runtime (hopefully with some descriptive error
message if it fails).

Regards,

Alexander Holler


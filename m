Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaI3OLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:11:32 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42390 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaI3OLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:11:30 -0400
MIME-Version: 1.0
In-Reply-To: <2923496.zl6JUbOQrZ@wuerfel>
References: <2923496.zl6JUbOQrZ@wuerfel>
Date: Tue, 30 Sep 2014 16:11:28 +0200
Message-ID: <CACRpkdYdwhujkP_66GCNktcvXFOzmGW=3t6BvCSXXMnHu03eEg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix callers of gpiochip_remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 3:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> A recent API change made gpiochip_remove return void instead of an
> error value, which broke drivers that use this return value:
>
> gpio/gpio-sch311x.c: In function 'sch311x_gpio_probe':
> gpio/gpio-sch311x.c:286:7: error: void value not ignored as it ought to be
>    if (gpiochip_remove(&priv->blocks[i].chip))
>        ^
>
> This changes the callers that I have found during randconfig testing
> so they no longer depend on the error code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: e1db1706c86e ("gpio: gpiolib: set gpiochip_remove retval to void")

Hm AFAICT these are already fixes in my GPIO tree
and linux-next...

Am I looking in the wrong place?

Yours,
Linus Walleij

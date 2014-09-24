Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaIXLKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:10:37 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:49972 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIXLKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:10:35 -0400
MIME-Version: 1.0
In-Reply-To: <a7c933339713dc1783770faf1eceb734@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
	<ff236f6dab7f3408551f8f4b0345e62b37fd99c5.1410020459.git.stefan@agner.ch>
	<CACRpkdaNbTj+hXtNFZ6DqosHPfHg2G+X2Cb_S_15mULpdebgrQ@mail.gmail.com>
	<a7c933339713dc1783770faf1eceb734@agner.ch>
Date: Wed, 24 Sep 2014 13:10:34 +0200
Message-ID: <CACRpkdbJePuG0g=AFGqjDS4=yW0CXnkpf1Yr_1P4e9Kkpu9n-g@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybird
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 1:51 PM, Stefan Agner <stefan@agner.ch> wrote:
> [Me]
>> postcore again. I don't like this, can you get rid of it?
>
> I guess we could load this driver easily a bit later. IMHO, since lots
> of other driver use GPIO's, we should it load before all the drivers
> gets loaded (before device_initcall).

Nope. We use deferred probing to control that today. Ideally
all drivers should be device_initcall() and deferred probe be used
to order things, not by playing around with initcalls.

> Most GPIO driver do this, some statistic again:
> $ grep -h -o ".*_initcall" drivers/gpio/*.c | sort | uniq -c | sort -n
> -r
>      33 subsys_initcall
>      14 postcore_initcall
>       2 device_initcall
>       2 arch_initcall
>       1 late_initcall
>       1 core_initcall

Yeah old legacy. There are patch attacks to get rid of this.

The reason we can't just change them is because sometimes
dependent drivers do not handle the errorpath very well can can't
defer cleanly.

With a new driver I expect deferred probe to be used.

Yours,
Linus Walleij

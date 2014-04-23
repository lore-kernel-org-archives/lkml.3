Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaDWNV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:21:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46666 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaDWNVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:21:55 -0400
MIME-Version: 1.0
In-Reply-To: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
Date: Wed, 23 Apr 2014 15:21:54 +0200
Message-ID: <CACRpkdbzoPNEEJ6UbisqHOiRwuxEb6XSrDL=MiUmDPgyY=rVuw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pl061: get gpio base from alias id
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: xuwei5@hisilicon.com, Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 3:35 AM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:

> If gpio base number isn't specified, the gpio base will be find from
> the end of gpio number. In order to keep with schematics, use alias
> to get the ID of gpio chip.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

The idea with GPIO numbers is not that these shall correspond
to schematics or data sheets or anything like that. It's a completely
Linux-internal number and has nothing to do with anything else.

The same is true for IRQ numbers.

The long term goal is to get rid of both GPIO and IRQ numbers
and deal only with descriptors in the kernel.

> +++ b/Documentation/devicetree/bindings/gpio/gpio-pl061.txt

A patch to add the device tree bindings is *very* welcome.

>         } else {
> -               chip->gc.base = -1;
> +               chip->gc.base = pl061_parse_gpio_base(dev);
>                 irq_base = 0;
>         }

I do not like a patch that changes the dynamic numbering to a
static one, that make things worse for our goals, not better :-(

Yours,
Linus Walleij

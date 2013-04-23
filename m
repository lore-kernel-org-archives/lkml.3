Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3DWK6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:58:54 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:47513 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3DWK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130404072907.GB3004@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdafSvT5Xb=7sqnkRHcc4UKkVzr8jzThMgWn6459RDmKGw@mail.gmail.com>
	<20130404072907.GB3004@gmail.com>
Date: Tue, 23 Apr 2013 12:58:52 +0200
Message-ID: <CACRpkdZWuw9O3-wr=g1AehZqmBR1YJ353w9ANfBTHhr5mRiwiw@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Supply a DTS file for the u8540 platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 9:29 AM, Lee Jones <lee.jones@linaro.org> wrote:

> This is a skeleton DTS file which only enables serial. Just using
> this simple file yields a terminal when booting u8540.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Now, wait... this doesn't work.

> +/ {
> +  model = "ST-Ericsson U8540 platform with Device Tree";
> +  compatible = "st-ericsson,u8540";
> +
> +       memory {
> +              reg = <0x00000000 0x20000000>;
> +              };

Funny whitespace. Use tabs ...

> +       soc-u9500 {

Please rename this not just "soc"

> +                 uart@80120000 {
> +                                       status = "okay";
> +                                              };
> +
> +               uart@80121000 {
> +                               status = "okay";
> +                                      };
> +
> +               uart@80007000 {
> +                               status = "okay";
> +                                      };
> +                                      };
> +};

The whitespace looks a bit funny compared to the
old patch, what happened here?

It also has the side effect that patch 5/9 does not
apply... By the way, since I already applied 4/9, please
squash 5/9 into this patch to avoid problems.

Finally, please patch arch/arm/boot/dts/Makefile
in the obvious way so that the DTB gets compiled.

Yours,
Linus Walleij

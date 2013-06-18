Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3FRFlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:41:42 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36013 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3FRFll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:41:41 -0400
MIME-Version: 1.0
In-Reply-To: <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl>
	<1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
Date: Tue, 18 Jun 2013 08:41:41 +0300
Message-ID: <CAHp75VdQXyRtfkNbnOyz36sADA_3tx=i4C+Ga5AevpMfo48XFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:59 PM, Oliver Schinagl
<oliver+list@schinagl.nl> wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs node.
>
> These fuses are most likly to be programmed at the factory, encoding
> things like Chip ID, some sort of serial number etc and appear to be
> reasonable unique.
> While in theory, these should be writeable by the user, it will probably
> be inconvinient to do so. Allwinner recommends that a certain input pin,
> labeled 'efuse_vddq', be connected to GND. To write these fuses, 2.5 V
> needs to be applied to this pin.
>
> Even so, they can still be used to generate a board-unique mac from, board
> unique RSA key and seed the kernel RNG.
>

> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -0,0 +1,147 @@

> +#include <linux/compiler.h>

I don't think you have to use this header explicitly.

> +#define DRV_NAME "sunxi-sid"

> +       if (size > (SID_SIZE - pos))

Useless internal braces.

> +static int sunxi_sid_remove(struct platform_device *pdev)
> +{
> +       device_remove_bin_file(&pdev->dev, &sid_bin_attr);
> +       dev_dbg(&pdev->dev, "%s driver unloaded\n", DRV_NAME);

It's useless to use DRV_NAME in conjunction with dev_* macros. dev_*
will print driver name as a prefix.

--
With Best Regards,
Andy Shevchenko

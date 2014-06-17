Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbaFQPoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:44:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37944 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbaFQPoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140615090932.GA29771@earth.universe>
References: <1402816289-7024-1-git-send-email-houcheng@gmail.com>
	<20140615090932.GA29771@earth.universe>
Date: Tue, 17 Jun 2014 23:44:20 +0800
Message-ID: <CAL8JtxByA0t+Nr-h1W6BZEobO9Gfqtm+7UUpp=yUBO67WRLSDg@mail.gmail.com>
Subject: Re: [PATCH] [RFC PATCH v2] power:reset: Add defer reset object to
 send board specific reset
From: Houcheng Lin <houcheng@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-06-15 17:09 GMT+08:00 Sebastian Reichel <sre@kernel.org>:
>
> I think this belongs to drivers/reset and not to drivers/power/reset.
> The drivers in drivers/power/reset are about board reboot / shutdown.
> This driver seems to be used for periphals.

Yes, this driver is for pherphials and I think it is reasonble
to placed it at drivers/reset. I'll moved it in next release.

> Alternatively you could do this via the duration. An infinite long
> reset signal basically means, that the line is never changed back.
>
> To give a few examples for the above comments:
>
> /* keep "gpx3 5" low for 5ms, change back to high afterwards */
> defer_reset_vbus {
>     compatible = "defer-reset";
>     reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
>     duration = <5>;
> };
>
> /* keep "gpx3 5" high for 5ms, change back to low afterwards */
> defer_reset_vbus {
>     compatible = "defer-reset";
>     reset-gpios = <&gpx3 5 GPIO_ACTIVE_HIGH>;
>     duration = <5>;
> };
>
> /* keep "gpx3 5" low */
> defer_reset_vbus {
>     compatible = "defer-reset";
>     reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
>     duration = <0>;

These DT properties looks simpler and better: Use of GPIO_ACTIVE_HIGH
and GPIO_ACTIVE_LOW increase readability for HW/SW developer, use
of <0> to indicate holding the reset signal. I'll updated code according
on this. Thanks for your comments.

-- 
Best regards,
Houcheng Lin

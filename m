Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaEIJGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:06:48 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39659 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaEIJGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <000001cf6b38$a6a3ffa0$f3ebfee0$%han@samsung.com>
References: <20140509012454.GL2198@atomide.com>
	<004701cf6b2d$e1a39c10$a4ead430$%han@samsung.com>
	<20140509030925.GN2198@atomide.com>
	<000001cf6b38$a6a3ffa0$f3ebfee0$%han@samsung.com>
Date: Fri, 9 May 2014 11:06:45 +0200
Message-ID: <CACRpkdZV647fx5j+a8ds_1eHffwnUijvX7qodH7LgJtYkqvvEw@mail.gmail.com>
Subject: Re: [PATCH] backlight: gpio-backlight: Fix warning when the GPIO is
 on a I2C chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 5:42 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Linus Walleij,
> Is there any reason to keep these two functions such as
> gpiod_set_raw_value_cansleep() and gpiod_set_raw_value()?

Yes, the former can *not* be called from interrupt context,
and thus erroneous usage can be detected with runtime checks.

Yours,
Linus Walleij

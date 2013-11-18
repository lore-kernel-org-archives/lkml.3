Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab3KRJPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:15:48 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65082 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3KRJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:15:38 -0500
MIME-Version: 1.0
In-Reply-To: <1384438956-31153-3-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
	<1384438956-31153-3-git-send-email-lee.jones@linaro.org>
Date: Mon, 18 Nov 2013 10:15:36 +0100
Message-ID: <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 3:22 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we provide the FSM's register addresses, register bit names/offsets
> and some commands which will prove useful as we start bulk the FMS's
> driver out with functionality.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

OK...

> +/*
> + * FSM SPI Controller Registers
> + */
> +#define SPI_CLOCKDIV                   0x0010
> +#define SPI_MODESELECT                 0x0018
> +#define SPI_CONFIGDATA                 0x0020
(...)

So what we want to know here is whether this is a general-purpose
SPI block, or if it's a special-purpose SPI block that can only be
used for accessing flashes.

If it's the former that part should be broken out into drivers/spi
of course...

But the register map seems a bit special-purpose so it could
very well be that this is for flash control only. So maybe you can
spill some beans from a datasheet here?

A clock divider at offset 0x10 already tells us that this is probably
a PL022 derivate, just that we don't know how much it has
been hacked with... does this thing contain AMBA identifiers
at the end of the IO-region, usually at 0x0fe0 thru 0x0fff?

Yours,
Linus Walleij

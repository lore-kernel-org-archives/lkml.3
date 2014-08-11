Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaHKHoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:44:24 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39155 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaHKHoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:44:23 -0400
MIME-Version: 1.0
In-Reply-To: <3923586.SsVg941346@diego>
References: <3923586.SsVg941346@diego>
Date: Mon, 11 Aug 2014 09:44:22 +0200
Message-ID: <CACRpkdaJS0PUDLaCnrhtiuXPf4ccx51uNTqYWVWm47mhOhGEbA@mail.gmail.com>
Subject: Re: io-domain voltages as regulators?
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 12:18 AM, Heiko Stübner <heiko@sntech.de> wrote:

[Adding Ulf Hansson to this discussion...]

> Hi Mark, Linus,
>
> I'd like to clarify what the appropriate way to handle pin output voltages is.
> On the Rockchip SoCs the voltage for some groups of pins can be set between
> 3.3V and 1.8V ... like the MMC/SD pins who need this to support UHS mode
> cards.

This is called "vqmmc" in the mmc/sd subsystem.

grep for mmc_set_signal_voltage() in drivers/mmc/core/*

In drivers/mmc/core/core.c, you find:

 mmc->supply.vqmmc = devm_regulator_get_optional(dev, "vqmmc");

Which gets the regulator to set the signal voltage, if such
a regulator is specified for the host.

Very simple and straight-forward, and handled by the MMC core.

> In [0] when talking about something different, Linus Walleij described a
> similar case as
>
> "I think we need to have a discussion with Mark Brown on how to
> handle this.
> We have previously had the case of MMC/SD level-shifters, where
> a certain setting gives a certain level of signals out, and another setting
> gives another level. Like two discrete levels.
> So we modeled that as a regulator provider inside the pin control
> driver eventually, see sh-pfc/pfc-sh73a0.c"
>
> As this sound like exactly the thing I'm trying to solve, is handling this via
> a regulator the correct general way?

Ithinkso.

Yours,
Linus Walleij

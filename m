Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab3HNPjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:39:23 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:56329 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab3HNPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <1373972146-12133-3-git-send-email-sonic.adi@gmail.com>
References: <1373972146-12133-1-git-send-email-sonic.adi@gmail.com>
	<1373972146-12133-3-git-send-email-sonic.adi@gmail.com>
Date: Wed, 14 Aug 2013 17:39:21 +0200
Message-ID: <CACRpkdYmW60Y5Kfb-4OmvHUoZQHhVib_7Kw9Z9HroVVkTLHu-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] blackfin: pinctrl-adi2: Add pin control device groups
 and function data.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        buildroot-devel@blackfin.uclinux.org,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:55 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Select PINCTRL_ADI2 for bf54x and bf60x by default.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

(...)
> +++ b/arch/blackfin/mach-bf548/include/mach/portmux.h
(...)
> +static const struct pinctrl_pin_desc adi_pads[] = {
> +       PINCTRL_PIN(0, "PA0"),
> +       PINCTRL_PIN(1, "PA1"),
> +       PINCTRL_PIN(2, "PA2"),
> +       PINCTRL_PIN(3, "PG3"),

The pattern we follow is not to pass the information about pins in a certain
SoC or package as platform data.

Instead we rely on plug-in subdrivers down in the pinctrl subsystem under
drivers/pinctrl/*.

Nominally you should write a central blackfind pinctrl driver such
as drivers/pinctrl/pinctrl-blackfin.c then have a local header such
as drivers/pinctrl/pinctrl-blackfin.h that enable SoC sub-drivers
such as drivers/pinctrl/pinctrl-blackfin-bf54x.c, pinctrl-blackfin-bf60f.c
to register to that.

Please read the current drivers such as pinctrl-nomadik.c
and pinctrl-nomadik-db8500.c for an idea of how this
plugin concept works.

In short: move all this data down into pinctrl.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3BMMvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:51:15 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:39678 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab3BMMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <201302131213.08631.poeschel@lemonage.de>
References: <1360583563-10707-1-git-send-email-larsi@wh2.tu-dresden.de>
	<20130211212551.1002A3E3530@localhost>
	<201302131213.08631.poeschel@lemonage.de>
Date: Wed, 13 Feb 2013 13:51:12 +0100
Message-ID: <CACRpkdbJ=KiwVoeK2TgO8kMuYQ2U-LaUOdL1d7w-q+9Ggb-JnA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: mcp23s08: convert driver to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:13 PM, Lars Poeschel <poeschel@lemonage.de> wrote:
> On Monday 11 February 2013 at 22:25:51, Grant Likely wrote:
>>
>> However, is the pullup selection per-gpio line? If so, then why not
>> encode it into the flags field of the gpio specifier?
>
> Yes, the pullup is per-gpio line. I am working on that. It turns out, that
> this is a bit difficult for me, as there is no real documentation and no
> other driver is doing it or something similar yet. Exception are very few
> gpio soc drivers where situation is a bit different. They seem to rely an
> fixed global gpio numbers and they are always memory mapped.
> But as I said I am working on it...

Part of your problem is that pull-up is pin control territory.

We invented that subsystem for a reason, and that reason
was that the GPIO subsystem had a hard time accomodating
things like this.

If you look in drivers/pinctrl/pinctrl-abx500.c which is my
latest submitted pinctrl driver you can see that this is basically
a quite simple GPIO chip, we just model it as a pin controller
with a GPIO front-end too exactly because it can do things
like multiplexing, pull-up and pull-down.

Have you considered this approach?

Yours,
Linus Walleij

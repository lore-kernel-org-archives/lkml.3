Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3FQP44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:56:56 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40596 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3FQP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:56:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130617072021.GB4465@atomide.com>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
	<51BA1FE7.4000900@wwwdotorg.org>
	<CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
	<51BB3A2C.608@wwwdotorg.org>
	<20130617072021.GB4465@atomide.com>
Date: Mon, 17 Jun 2013 17:56:54 +0200
Message-ID: <CACRpkdbZ6QCU1N_3no+rahjVFSUgYMrDqtXW=4AjaY4RhaF9Zw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 9:20 AM, Tony Lindgren <tony@atomide.com> wrote:

> Maybe let's again try to first list all the known cases where we need to
> do remuxing, and the pins we need to remux?

In the pinctrl documentation this is known as "runtime pinmuxing".
This is not common, it is much more common to change
pin config, i.e. all other electrical properties of the pins,
at runtime. Especially when going to sleep or idle.

> Below are the pin remuxing cases I'm aware of:
>
> 1. Remux UART RX pin of a device for a wake-up event
>
> 2. Remux whatever device interrupt line to a GPIO input for wake-up
>
> 3. Remux audio jack between UART RX and TX to provide a debug console
>
> 4. Remux MMC CMD and DAT lines for sleep with pulls to avoid device
>    from resetting with lines floating or to save power
>
> Please list any further use cases that I'm not familiar with. I'd like
> to hear how messed up this remuxing business can get :)

We have a debug port that can be muxed out on the keypad(!)
or the SD card, and some other variants...

Stephen added the I2C block switch thing that switch one
and the same IP core between different sets of pins (IIRC).

For runtime pin config I have many more examples, we
change a lot of those to so-called "GPIO mode" (basically
just turned into an input with wakeup,  or pulled to ground)
at sleep.

Yours,
Linus Walleij

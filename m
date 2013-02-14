Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886Ab3BNMWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:22:41 -0500
Received: from [212.90.139.82] ([212.90.139.82]:29224 "EHLO smtp2.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934463Ab3BNMWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:22:39 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.883
From: Lars Poeschel <poeschel@lemonage.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] gpio: mcp23s08: convert driver to DT
Date: Thu, 14 Feb 2013 13:22:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
References: <1360583563-10707-1-git-send-email-larsi@wh2.tu-dresden.de> <201302131213.08631.poeschel@lemonage.de> <CACRpkdbJ=KiwVoeK2TgO8kMuYQ2U-LaUOdL1d7w-q+9Ggb-JnA@mail.gmail.com>
In-Reply-To: <CACRpkdbJ=KiwVoeK2TgO8kMuYQ2U-LaUOdL1d7w-q+9Ggb-JnA@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201302141322.22263.poeschel@lemonage.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2013 at 13:51:12, Linus Walleij wrote:
> On Wed, Feb 13, 2013 at 12:13 PM, Lars Poeschel <poeschel@lemonage.de> 
wrote:
> > On Monday 11 February 2013 at 22:25:51, Grant Likely wrote:
> >> However, is the pullup selection per-gpio line? If so, then why not
> >> encode it into the flags field of the gpio specifier?
> > 
> > Yes, the pullup is per-gpio line. I am working on that. It turns out,
> > that this is a bit difficult for me, as there is no real documentation
> > and no other driver is doing it or something similar yet. Exception are
> > very few gpio soc drivers where situation is a bit different. They seem
> > to rely an fixed global gpio numbers and they are always memory mapped.
> > But as I said I am working on it...
> 
> Part of your problem is that pull-up is pin control territory.
> 
> We invented that subsystem for a reason, and that reason
> was that the GPIO subsystem had a hard time accomodating
> things like this.
> 
> If you look in drivers/pinctrl/pinctrl-abx500.c which is my
> latest submitted pinctrl driver you can see that this is basically
> a quite simple GPIO chip, we just model it as a pin controller
> with a GPIO front-end too exactly because it can do things
> like multiplexing, pull-up and pull-down.
> 
> Have you considered this approach?

No, I haven't. And although this doesn't solve all my problems, I like the 
idea very much! Thank you for this! But at the moment it looks to me that 
this could be a bit overkill for setting this single register and I don't 
think this is, what Grant meant me to do. 
Anyway, I will have a deeper look at this.

Thanks,
Lars

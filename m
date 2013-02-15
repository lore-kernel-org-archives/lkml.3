Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3BOToJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:44:09 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:43831 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3BOToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <201302141322.22263.poeschel@lemonage.de>
References: <1360583563-10707-1-git-send-email-larsi@wh2.tu-dresden.de>
	<201302131213.08631.poeschel@lemonage.de>
	<CACRpkdbJ=KiwVoeK2TgO8kMuYQ2U-LaUOdL1d7w-q+9Ggb-JnA@mail.gmail.com>
	<201302141322.22263.poeschel@lemonage.de>
Date: Fri, 15 Feb 2013 20:44:07 +0100
Message-ID: <CACRpkdZdPtDeD9GzB6Bfdko0mLCPMNq5_dqqOOzKA9a66qT-vw@mail.gmail.com>
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

On Thu, Feb 14, 2013 at 1:22 PM, Lars Poeschel <poeschel@lemonage.de> wrote:
> On Wednesday 13 February 2013 at 13:51:12, Linus Walleij wrote:

>> Have you considered this [pinctrl] approach?
>
> No, I haven't. And although this doesn't solve all my problems, I like the
> idea very much! Thank you for this! But at the moment it looks to me that
> this could be a bit overkill for setting this single register and I don't
> think this is, what Grant meant me to do.

So there is this corner case where some GPIO driver does some
pinctrl business, I mean, really really little of it. And then it may be
overkill. Sometimes though, the hardware actually can do a lot of
this biasing and muxing it just wasn't part of the driver yet or done
in e.g. boot loaders, and then it's usually better to use pinctrl.

Adding custom APIs to the GPIO drivers will however always
cause a maintenance burden on the GPIO maintainers, so that's
why pinctrl & GPIO is nice.

I don't know which case this would be though.

Yours,
Linus Walleij

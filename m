Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaGWIqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:46:53 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61368 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbaGWIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140723184507.30c4b211@canb.auug.org.au>
References: <20140723184507.30c4b211@canb.auug.org.au>
Date: Wed, 23 Jul 2014 10:46:49 +0200
Message-ID: <CACRpkdb=NgzC=1i96pbuHpUh+S9=6Jv+F1AQit+xf3CJf2q+tA@mail.gmail.com>
Subject: Re: linux-next: build warnings after merge of the gpio tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        abdoulaye berthe <berthe.ab@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:45 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the gpio tree, today's linux-next build (powerpc
> allyesconfig) produced these warnings:
>
> drivers/gpio/gpio-ucb1400.c: In function 'ucb1400_gpio_remove':
> drivers/gpio/gpio-ucb1400.c:92:2: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]
>   gpiochip_remove(&ucb->gc);
>   ^
>
> And lots of similar ones.
>
> Introduced by commit 9f5132ae82fd ("gpio: remove all usage of
> gpio_remove retval in driver/gpio").

Yes we're planning to get rid of the retval in the next merge window after first
purging all drivers.

> Maybe the __must_check attribute should be removed from the declaration
> of the function before removing the retval checking ...

Hey, good idea. I'll do this.

Yours,
Linus Walleij

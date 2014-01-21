Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaAUSLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:11:42 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:57104 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaAUSLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:11:40 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY8Dk=i1-=rKU6gTM+3YHQ286r1u4z2WhLDQtcqLpyM2Q@mail.gmail.com>
References: <CACRpkdY8Dk=i1-=rKU6gTM+3YHQ286r1u4z2WhLDQtcqLpyM2Q@mail.gmail.com>
Date: Tue, 21 Jan 2014 10:11:39 -0800
X-Google-Sender-Auth: Pmq4v9Zc_HeXJ7QHSqdOaHwXuQs
Message-ID: <CA+55aFzpF87hNgpFDsqLXYyiuTADe1xB2KUhOVd=atYASOLNFw@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO bulk changes for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:36 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
>
> here is the big GPIO pull request for the v3.14 series.

Ugh. It does not compile for me. The problem seems to be that the
gpio-mcp23s08.c driver only compiles in OF environments, but isn't
properly restricted to them:

  drivers/gpio/gpio-mcp23s08.c: In function ‘mcp23s08_irq_setup’:
  drivers/gpio/gpio-mcp23s08.c:482:46: error: ‘struct gpio_chip’ has
no member named ‘of_node’
    mcp->irq_domain = irq_domain_add_linear(chip->of_node, chip->ngpio,

and similar other errors.

Introduced by commit 4e47f91bf741 ("gpio: mcp23s08: Add irq
functionality for i2c chips") as far as I can tell.

>  It's big this time but has been brewing in linux-next for
> some time and it's all good stuff IMO

The fact that it doesn't even compile makes me doubt your statement
that it has been in linux-next. It doesn't even pass a basic
allmodconfig build.

I see that you tried to fix it in commit 01d7004181c8 ("gpio:
mcp23s08: depend on OF_GPIO") but screwed up the order of operations.

I fixed it up properly in the merge, but please try to figure out how
the hell this passed through the cracks.

             Linus

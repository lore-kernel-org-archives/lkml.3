Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab3BLMfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:35:32 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64067 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108Ab3BLMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAMo8BfKo=N_O=O0y74zy+orAn3nNb-OuS9fC92ebbN7bN_CQPg@mail.gmail.com>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
	<1358495866-9329-1-git-send-email-shawn.guo@linaro.org>
	<CACRpkdZA9O6N7hmtU-6R1Ff6hW5vjD_ar9RLG1dbkd+MWyoKiw@mail.gmail.com>
	<CAMo8BfJ=6WbAHoCpftRHW1iMtG8robyYUEqqCG2SecixDTgC+g@mail.gmail.com>
	<CACRpkdbT2eAZR2Ud5f9h0TFsA5M0RpysE9SqMgoL-hcB8fS+Ew@mail.gmail.com>
	<CAMo8BfKo=N_O=O0y74zy+orAn3nNb-OuS9fC92ebbN7bN_CQPg@mail.gmail.com>
Date: Tue, 12 Feb 2013 13:35:29 +0100
Message-ID: <CACRpkdYpAqXQY-K9euyiBaEei2+=2VbNeCaD0-ThJWbWX3MN-Q@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: devm_gpio_* support should not depend on GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 5:50 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:

> FWIW I see that the issue is caused by building drivers/gpio/devres.c
> with CONFIG_GPIOLIB=n. Should I just turn GPIO_DEVRES off too?

Hm. Shawn just added:

+config GPIO_DEVRES
+       def_bool y
+       depends on HAS_IOMEM

Can you please patch the last line like so:

        depends on (HAS_IOMEM && GPIOLIB)

I think that's the actual problem... Maybe also move this
config option below the GPIOLIB entry. Or move it under
the #if GPIOLIB even.

Can you send a patch that works for you?

Yours,
Linus Walleij

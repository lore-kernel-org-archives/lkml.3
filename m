Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaBEOe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:34:27 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:59383 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBEOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:34:25 -0500
MIME-Version: 1.0
In-Reply-To: <1391529538-21685-15-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-15-git-send-email-ulf.hansson@linaro.org>
Date: Wed, 5 Feb 2014 15:34:24 +0100
Message-ID: <CACRpkdZwoXf5ovmQEAN6Ugvz91+_i5uGqStR3MGXQeJGHitj3Q@mail.gmail.com>
Subject: Re: [PATCH 14/17] i2c: nomadik: Fixup deployment of runtime PM
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Wolfram Sang <wsa@the-dreams.de>,
        Chris Ball <chris@printf.net>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        linux-spi@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 4:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

> Since the device is active while a successful probe has been completed,
> the reference counting for the clock will be screwed up and never reach
> zero.
>
> The issue is resolved by implementing runtime PM callbacks and let them
> handle the resources accordingly, including the clock.
>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Hm do I read it right as patch 13 breaks runtime PM by leaving
the device active after probe() and this patch
14 fixes it again? Maybe these two patches should be squashed
then.

Yours,
Linus Walleij

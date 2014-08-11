Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaHKH0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:26:51 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33029 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaHKH0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <1406808468-12559-1-git-send-email-broonie@kernel.org>
References: <1406808468-12559-1-git-send-email-broonie@kernel.org>
Date: Mon, 11 Aug 2014 09:26:49 +0200
Message-ID: <CACRpkdaD2K4L+dF3iaXqQTsYJpoVRnRnp-4La38BWC3cRVUm7g@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Don't allow drivers to specify a base with DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 2:07 PM, Mark Brown <broonie@kernel.org> wrote:

> From: Mark Brown <broonie@linaro.org>
>
> DT based systems should have no reason to use fixed GPIO numbers but some
> drivers that work on both DT and non-DT platforms specify them anyway. In
> order to improve robustness in cases where drivers use gpio_is_valid() to
> check for a valid GPIO on data initialized to zero as a default and avoid
> bugs due to assuptions about fixed numbers creeping in ignore any specified
> base when DT is in use.

Hm in principle you are right...

> -       if (base < 0) {
> +       if (base < 0 || of_have_populated_dt()) {
>                 base = gpiochip_find_base(chip->ngpio);

But here I worry about breaking in-transition systems, e.g.
defining part of the peripherals through DT but adding a
GPIO device with AUXDATA, setting up base that way.

Not that it should stay that way for sure, but it does need
some consideration...

Yours,
Linus Walleij

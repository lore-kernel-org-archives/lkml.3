Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936765Ab3DJUye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:54:34 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37520 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935970Ab3DJUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <1365010814-3263-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1365010814-3263-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Wed, 10 Apr 2013 22:54:31 +0200
Message-ID: <CACRpkdY=gJMCQ-qskDwXFg9cQH02+fZ00zU+=2cRdHE71cT9hw@mail.gmail.com>
Subject: Re: [PATCH] gpio: pca953x: fix irq_domain_add_simple usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 7:40 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> We actually have to pass chip as the host_data parameter of
> irq_domain_add_simple() as later on, it is used to initialize chip_data
> in pca953x_gpio_irq_map(). Failing to do so is leading to a NULL pointer
> dereference after calling irq_data_get_irq_chip_data() in
> pca953x_irq_mask(), pca953x_irq_unmask(), pca953x_irq_bus_lock(),
> pca953x_irq_bus_sync_unlock() and pca953x_irq_set_type().
>
> Fixes regression introduced by commit
> 0e8f2fdacf1d44651aa7e57063c76142d1f4988b (gpio: pca953x: use simple
> irqdomain)
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>
> This would probably be good to introduce that patch in the next 3.9 rc as the
> regression leads to a lot of breakage (and cursing).

OK patch applied let's see if I get it to Torvalds in time.

Can I have some ACK from Maxime?

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3FJNK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:10:59 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53575 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3FJNK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:10:58 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [EXAMPLE PATCH] pinctrl: add pinctrl driver for Rockchip SoCs
Date: Mon, 10 Jun 2013 15:10:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201306090159.05383.heiko@sntech.de> <201306090201.17739.heiko@sntech.de> <CACRpkdaEcZZ3NZzwKOhUPjvFg+bSZ=UbpyPT2EBcAfVv1-EsKA@mail.gmail.com>
In-Reply-To: <CACRpkdaEcZZ3NZzwKOhUPjvFg+bSZ=UbpyPT2EBcAfVv1-EsKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306101510.51961.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. Juni 2013, 15:00:41 schrieb Linus Walleij:
> On Sun, Jun 9, 2013 at 2:01 AM, Heiko Stübner <heiko@sntech.de> wrote:
> 
> (...)
> 
> > +#include <linux/irqchip/chained_irq.h>
> > +#include <linux/clk-provider.h>
> > +#include <dt-bindings/pinctrl/rockchip.h>
> 
> Hm I don't know if we're supposed to do things like this actually.
> 
> It depends on whether the <dt-bindings/*> hierarchy is supposed
> to stay in the kernel after the device trees are moved out to a
> separate repo.
> 
> Grant/Rob, shall we do this in drivers?

we can get rid of it, if it's controversial.

The only constant that gets used is RK_FUNC_GPIO in 
rockchip_pmx_gpio_set_direction and rockchip_irq_set_type to not have arbitary 
"0"-values when switching to the gpio function.

So it wouldn't be problem to simply keep this constant in the driver itself 
instead of including the dt-binding constants.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3DYLJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:09:41 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:44782 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3DYLJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-17-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-17-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:09:39 +0200
Message-ID: <CACRpkdbQpiEZ4etyE=mveH8HFughVe_oa81P3QEWWJHPtrxn0g@mail.gmail.com>
Subject: Re: [PATCH 16/32] dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> All configuration left in d40_phy_cfg() is runtime configurable and
> there is already a call into it from d40_runtime_config(), so let's
> rely on that.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

NAK. Have you really tested this with memcpy()?

The runtime config function is *not* called when doing memcpy
DMA, still the channels used for memcpy need to be configured
obviously. Now you're assuming that every time anyone is using
a DMA channel they will first allocate it, then call the runtime
config. This is not true.

Runtime config is only used when doing dev->mem and
mem->dev DMA.

You may just as well compile in the test program that is there right
in the kernel and run it ... it's good! (DMA Test Client in
menuconfig under drivers/dma engine support...)

There was this other patch not taking the memcpy channels
into the array that I think will also cause a crash when doing
memcpy so I'm pretty sure you're not testing this.

When I test these patches I will run it, and just report
that memcpy doesn't work if it doesn't and then you'll
have to figure it out anyway, so enjoy...

Yours,
Linus Walleij

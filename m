Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502Ab3ECTkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:40:52 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:41208 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763396Ab3ECTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-8-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-8-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:40:50 +0200
Message-ID: <CACRpkdYUo+uApXMzFpYe74CMP+2r=+OiignXrkL9UgJoL7CLXg@mail.gmail.com>
Subject: Re: [PATCH 07/63] dmaengine: ste_dma40: Assign memcpy channels in the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The channels reserved for memcpy are the same for all currently
> supported platforms. With this in mind, we can ease the platform
> data passing requirement by moving these assignments out from
> platform code and place them directly into the driver.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

(...)
> -/* Reserved event lines for memcpy only */
> -static int dma40_memcpy_event[] = {
> -       DB8500_DMA_MEMCPY_TX_0,
> -       DB8500_DMA_MEMCPY_TX_1,
> -       DB8500_DMA_MEMCPY_TX_2,
> -       DB8500_DMA_MEMCPY_TX_3,
> -       DB8500_DMA_MEMCPY_TX_4,
> -       DB8500_DMA_MEMCPY_TX_5,
> -};
(...)
> +/* Reserved event lines for memcpy only. */
> +static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };

I'm still not OK with named numbers being replaced with hardcoded
numbers.

Apparently this is a hard review comment so I will go in and patch
it myself with a separate patch on top of this.

Yours,
Linus Walleij

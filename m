Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3DXNpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 09:45:39 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39884 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3DXNpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 09:45:38 -0400
MIME-Version: 1.0
In-Reply-To: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 24 Apr 2013 15:45:37 +0200
Message-ID: <CACRpkdYUT+5J-phV=ez-EkmA9EdfxwmDMApTssi+P3=mSE3cew@mail.gmail.com>
Subject: Re: [PATCH 1/8] dmaengine: ste_dma40: Assign memcpy channels in the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 8:39 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The channels reserved for memcpy are the same for all currently
> supported platforms. With this in mind, we can ease the platform
> data passing requirement by moving these assignments out from
> platform code and place them directly into the driver.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
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

So what's so bad with using the #defines?

I would prefer if you took the entire content of
arch/arm/mach-ux500/ste-dma40-db8500.h
and copied into the DMA driver, so you atleast
have a chance of understanding what these numbers
are about.

Yours,
Linus Walleij

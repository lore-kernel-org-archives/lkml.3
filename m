Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3FQPmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:42:50 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45793 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3FQPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:42:49 -0400
MIME-Version: 1.0
In-Reply-To: <1371131763-6288-1-git-send-email-fabio.baltieri@linaro.org>
References: <1371131763-6288-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 17 Jun 2013 17:42:48 +0200
Message-ID: <CACRpkdYOP0xTJo3sLbRz5D=b4Vb1484a1qfE3aVAKRTM4+Y7QQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: set coherent_dma_mask for dma40
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 3:56 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Set coherent_dma_mask to DMA_BIT_MASK(32) for dma40 platform_device, as
> without this DMA allocations were failing with the error:
>
> dma40 dma40.0: coherent DMA mask is unset
>
> when booting without device-tree.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>
> Hi Linus, Lee,
>
> I found this while removing the last hack I was keeping in my ASoC tree.
> I originally thought that I had to set this on the driver's pdata, but
> it turns out it's needed on the DMA controller one instead.
>
> When booting with device-tree enabled the mask seems to be set
> automatically.
>
> Would you consider applying this with the other dma40 patches?

Those are now upstream in the ARM SoC tree, you'd have to send it
to arm@kernel.org and ask Olof/Arnd to apply it directly to
the next/drivers branch (I think).

I have also queued it on ux500-fixes so it won't be lost.

Yours,
Linus Walleij

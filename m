Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3DYLzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:55:41 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:60316 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3DYLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <1366280825-31136-3-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-3-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:55:39 +0200
Message-ID: <CACRpkda0sE+KgdagN0CsRsoDFR+VoUzh2jaipB_1BtShYpBCcg@mail.gmail.com>
Subject: Re: [PATCH 2/9] crypto: ux500/hash - Set DMA configuration though dma_slave_config()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        magnus.p.persson@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pls include Magnus.p.persson@stericsson.com on all these crypto/hash
postings.

On Thu, Apr 18, 2013 at 12:26 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The DMA controller currently takes configuration information from
> information passed though dma_channel_request(), but it shouldn't.
> Using the API, the DMA channel should only be configured during
> a dma_slave_config() call.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

(...)
>  #define HASH_BLOCK_SIZE                        64
> +#define HASH_DMA_FIFO                  4

This is an address so write 0x0004 here please. Some hex notation atleast.

>  /**
>   * struct hash_device_data - structure for a hash device.
> - * @base:              Pointer to the hardware base address.
> + * @base:              Pointer to virtual base address of the hash device.
> + * @phybase:           Pointer to physical memory location of the hash device.
>   * @list_node:         For inclusion in klist.
>   * @dev:               Pointer to the device dev structure.
>   * @ctx_lock:          Spinlock for current_ctx.
> @@ -361,6 +363,7 @@ struct hash_req_ctx {
>   */
>  struct hash_device_data {
>         struct hash_register __iomem    *base;
> +       phys_addr_t             phybase;

What you pass to the config function is a dma_addr_t actually.

This is the same thing on the platform, but generally:

phys_addr_t = in the address space as the memory controller sees it.
dma_addr_t = in the address space as the DMA controller sees it.

Often the same. Not always. So use dma_addr_t.

Apart from this a real nice patch!

Yours,
Linus Walleij

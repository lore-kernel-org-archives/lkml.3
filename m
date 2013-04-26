Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab3DZJOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:14:33 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48710 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab3DZJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:14:32 -0400
Date: Fri, 26 Apr 2013 10:14:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmaengine: use phys_addr_t for slave configuration
Message-ID: <20130426091426.GA31899@gmail.com>
References: <1366967214-20776-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366967214-20776-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Linus Walleij wrote:

> The documentation already says these are physical addresses, and
> we have concluded that any translation into the DMA address space
> needs to reside in the dmaengine driver, so change the type of
> the passed arguments.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/dmaengine.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 91ac8da..681df5f9 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -361,8 +361,8 @@ enum dma_slave_buswidth {
>   */
>  struct dma_slave_config {
>  	enum dma_transfer_direction direction;
> -	dma_addr_t src_addr;
> -	dma_addr_t dst_addr;
> +	phys_addr_t src_addr;
> +	phys_addr_t dst_addr;
>  	enum dma_slave_buswidth src_addr_width;
>  	enum dma_slave_buswidth dst_addr_width;
>  	u32 src_maxburst;

Makes a lot more sense.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

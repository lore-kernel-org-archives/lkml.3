Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaDVNwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:52:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:60342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbaDVNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:52:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 14/28] nios2: DMA mapping API
Date: Tue, 22 Apr 2014 15:52:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <1397845149-3141-1-git-send-email-lftan@altera.com> <1397845149-3141-4-git-send-email-lftan@altera.com>
In-Reply-To: <1397845149-3141-4-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221552.00501.arnd@arndb.de>
X-Provags-ID: V02:K0:OQ8BkBe5OoTYdWVnbyJo2tBU9x8XAlw8SNCvC8XrpuR
 WrnBKFTkeVTpBJvZ8cgdREWNcxVgFQ1ZeRJKlnZsdwd0jMgrzn
 j5PEXq51FCiB29geOmn1VVJhoQ7YXAKUCg6G0V/KQs08puiB+w
 fukSoGRzbD0ApOpwfeaQ7mKHLCnqV1yoIOhJ9gVP0o9c6uWHoD
 FlcMvTCWTlvUdiMS2tJnllq0XEnDuAwF3xnh2RhY6I/QVMFQEl
 fWoX77PKmnkzblWe9Ao0MGFeY+u9zHqlko44FfpgkB82mL42b6
 QguC8I8dp744ZB5dp5n2xpak/EI1odHSu+Akqn11ar86bGCckH
 93gg9InBg0rwXjWLp2aI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014, Ley Foon Tan wrote:

> +static inline int dma_supported(struct device *dev, u64 mask)
> +{
> +	/* we fall back to GFP_DMA when the mask isn't all 1s,
> +	 * so we can't guarantee allocations that must be
> +	 * within a tighter range than GFP_DMA.
> +	 */
> +	if (mask < 0x00ffffff)
> +		return 0;
> +
> +	return 1;
> +}

> +void *dma_alloc_coherent(struct device *dev, size_t size,
> +			    dma_addr_t *dma_handle, gfp_t gfp)
> +{
> +	void *ret;
> +
> +	/* ignore region specifiers */
> +	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
> +
> +	/* optimized page clearing */
> +	gfp |= __GFP_ZERO;
> +
> +	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
> +		gfp |= GFP_DMA;

What is the significance of ZONE_DMA on this architecture?

Do you actually have DMA masters with a 0x00ffffff mask?

	Arnd


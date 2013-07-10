Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3GJJbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:31:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36284 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:31:42 -0400
Date: Wed, 10 Jul 2013 10:30:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com, arnd@arndb.de
Subject: Re: [PATCH] dmaengine: Add MOXA ART DMA engine driver
Message-ID: <20130710093055.GW24642@n2100.arm.linux.org.uk>
References: <1373446263-7772-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373446263-7772-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:51:03AM +0200, Jonas Jensen wrote:
> +#include "virt-dma.h"
...
> +struct moxart_dma_chan {
> +	struct virt_dma_chan		vchan;
...
> +static inline struct moxart_dma_chan *to_moxart_dma_chan(struct dma_chan *c)
> +{
> +	return container_of(c, struct moxart_dma_chan, vchan.chan);
> +}
...
> +	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, mchan++) {
> +		mchan->ch_num = i;
> +		mchan->reg = (struct moxart_dma_reg *)(dma_base_addr + 0x80
> +			     + i * sizeof(struct moxart_dma_reg));
> +		mchan->callback = NULL;
> +		mchan->allocated = 0;
> +		mchan->callback_param = NULL;
> +		vchan_init(&mchan->vchan, &mdc->dma_slave);

Do you actually make any use what so ever of the vchan support?

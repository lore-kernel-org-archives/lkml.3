Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab3CDKMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:12:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53460 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CDKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:12:23 -0500
Date: Mon, 4 Mar 2013 10:11:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Cooks <acooks@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] check for allocation failure in ioat_dma_self_test
Message-ID: <20130304101142.GJ17833@n2100.arm.linux.org.uk>
References: <1362386358-3556-1-git-send-email-acooks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362386358-3556-1-git-send-email-acooks@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 04:39:16PM +0800, Andrew Cooks wrote:
> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
> index 1879a59..1f706c4 100644
> --- a/drivers/dma/ioat/dma.c
> +++ b/drivers/dma/ioat/dma.c
> @@ -832,7 +832,18 @@ int ioat_dma_self_test(struct ioatdma_device *device)
>  	}
>  
>  	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
> +	err = dma_mapping_error(dev, dma_src);
> +	if (err) {
> +		dev_err(dev, "dma mapping failed: -%d\n", err);
> +		goto free_resources;
> +	}

NAK.  Please take the time to check what the functions you're using return
rather than assuming what they return.

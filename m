Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3CFRjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:39:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55374 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3CFRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:39:35 -0500
Date: Wed, 6 Mar 2013 17:39:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Cooks <acooks@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] check for dma mapping error in ioat_dma_self_test
Message-ID: <20130306173910.GU17833@n2100.arm.linux.org.uk>
References: <CAJtEV7bGjdJdCsKZ05+FbzoNDeMd2YUh=B=qc=ev_Z2ESg7vPQ@mail.gmail.com> <1362536245-4708-1-git-send-email-acooks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362536245-4708-1-git-send-email-acooks@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for redoing the patch, but...

On Wed, Mar 06, 2013 at 10:17:22AM +0800, Andrew Cooks wrote:
> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
> index 1879a59..5431ba8 100644
> --- a/drivers/dma/ioat/dma.c
> +++ b/drivers/dma/ioat/dma.c
> @@ -832,7 +832,18 @@ int ioat_dma_self_test(struct ioatdma_device *device)
>  	}
>  
>  	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
> +	if (dma_mapping_error(dev, dma_src)) {
> +		dev_err(dev, "dma mapping failed.\n");
> +		goto free_resources;

Won't this result in 'err' still being zero here, and cause this function
to apparantly return success?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbbAMUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:03:18 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51039 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbAMUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:03:16 -0500
MIME-Version: 1.0
In-Reply-To: <1419262509-9811-1-git-send-email-m-karicheri2@ti.com>
References: <1419262509-9811-1-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 14:02:54 -0600
Message-ID: <CAL_JsqJb2ufqwgHNUepiNs8NRa57caxacoEfVa6-RYT8HUfS5g@mail.gmail.com>
Subject: Re: [PATCH] dma-mapping: fix debug print to display correct dma_pfn_offset
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 9:35 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> fix the dev_dbg to display the offset which is the calculated
> dma_pfn_offset value and set later in the code.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Applied for 3.20. Thanks.

> ---
>  drivers/of/platform.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 5b33c6a..a54ec10 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -188,7 +188,7 @@ static void of_dma_configure(struct device *dev)
>                 size = dev->coherent_dma_mask;
>         } else {
>                 offset = PFN_DOWN(paddr - dma_addr);
> -               dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> +               dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
>         }
>         dev->dma_pfn_offset = offset;
>
> --
> 1.7.9.5
>

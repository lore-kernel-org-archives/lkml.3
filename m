Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab3ECU1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:27:10 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47458 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934204Ab3ECU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-21-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-21-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:27:07 +0200
Message-ID: <CACRpkdbx_-wcatRaUpRw5LJY6qsoqDc3iqwk+UVmoBWR1M35KQ@mail.gmail.com>
Subject: Re: [PATCH 20/63] dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
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

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> All configuration left in d40_phy_cfg() is runtime configurable and
> there is already a call into it from d40_runtime_config(), so let's
> rely on that.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
(...)

> @@ -2027,6 +2027,14 @@ static int d40_config_memcpy(struct d40_chan *d40c)
>         } else if (dma_has_cap(DMA_MEMCPY, cap) &&
>                    dma_has_cap(DMA_SLAVE, cap)) {
>                 d40c->dma_cfg = dma40_memcpy_conf_phy;
> +
> +               /* Generate interrrupt at end of transfer or relink. */
> +               d40c->dst_def_cfg |= BIT(D40_SREG_CFG_TIM_POS);
> +
> +               /* Generate interrupt on error. */
> +               d40c->src_def_cfg |= BIT(D40_SREG_CFG_EIM_POS);
> +               d40c->dst_def_cfg |= BIT(D40_SREG_CFG_EIM_POS);
> +

This hunk looks like it's fixing a bug introduced in patch 19/63.

Do you try to run a memcpy test after patch 19?

Breaking the drive in one patch and fixing it in the next is
a no-no because of bisection.

Maybe things work fine if you just move this hunk of the
patch over to 19/63?

Apart from this the patch looks fine.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3JJNya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:54:30 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:37199 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JJNy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:54:29 -0400
MIME-Version: 1.0
In-Reply-To: <1381297228-2443-2-git-send-email-zhouqiao@marvell.com>
References: <1381297228-2443-1-git-send-email-zhouqiao@marvell.com>
	<1381297228-2443-2-git-send-email-zhouqiao@marvell.com>
Date: Thu, 10 Oct 2013 21:54:28 +0800
Message-ID: <CAMj5BkgVw+uSCKzvY5tJY68NHUo_Ty-nvyhDQ+PGQo-kL7suWA@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_tdma: add multiple burst size support for 910-squ
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        chao.xie@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 1:40 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
> add multiple burst size support for 910-squ.
>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> ---
>  drivers/dma/mmp_tdma.c |   25 ++++++++++++++++++++++++-
>  1 files changed, 24 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
> index 38cb517..d84354b 100644
> --- a/drivers/dma/mmp_tdma.c
> +++ b/drivers/dma/mmp_tdma.c
> @@ -228,8 +228,31 @@ static int mmp_tdma_config_chan(struct mmp_tdma_chan *tdmac)
>                         return -EINVAL;
>                 }
>         } else if (tdmac->type == PXA910_SQU) {
> -               tdcr |= TDCR_BURSTSZ_SQU_32B;
>                 tdcr |= TDCR_SSPMOD;
> +
> +               switch (tdmac->burst_sz) {
> +               case 1:
> +                       tdcr |= TDCR_BURSTSZ_SQU_1B;
> +                       break;
> +               case 2:
> +                       tdcr |= TDCR_BURSTSZ_SQU_2B;
> +                       break;
> +               case 4:
> +                       tdcr |= TDCR_BURSTSZ_SQU_4B;
> +                       break;
> +               case 8:
> +                       tdcr |= TDCR_BURSTSZ_SQU_8B;
> +                       break;
> +               case 16:
> +                       tdcr |= TDCR_BURSTSZ_SQU_16B;
> +                       break;
> +               case 32:
> +                       tdcr |= TDCR_BURSTSZ_SQU_32B;
> +                       break;
> +               default:
> +                       dev_err(tdmac->dev, "mmp_tdma: unknown burst size.\n");
> +                       return -EINVAL;
> +               }

Sorry, do I make mistake,
Not find definition TDCR_BURSTSZ_SQU_16B ~
Only find
#define TDCR_BURSTSZ_SQU_32B    (0x7 << 6)

Thanks

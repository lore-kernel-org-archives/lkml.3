Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595Ab3E1Pn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:43:29 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54412 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374Ab3E1Pn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
References: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
Date: Tue, 28 May 2013 18:43:26 +0300
Message-ID: <CAHp75VfdJ3RhXc0PJNvBwcxzoGh5MYHcPSmiX_-wR778L4XtSA@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_pdma: fix a memory alloc error
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 3:05 PM, Xiang Wang <wangxfdu@gmail.com> wrote:
> From: Xiang Wang <wangx@marvell.com>
>
> pdev->phy is of type "struct mmp_pdma_phy *". But when
> allocating memory for it, "struct mmp_pdma_chan" is used
> by mistake.

Have you tested it?

> Signed-off-by: Xiang Wang <wangx@marvell.com>
> ---
>  drivers/dma/mmp_pdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c26699f..76a8dcf 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>         }
>
>         pdev->phy = devm_kzalloc(pdev->dev,
> -               dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
> +               dma_channels * sizeof(struct mmp_pdma_phy), GFP_KERNEL);

For me it seems you did get how it works.

--
With Best Regards,
Andy Shevchenko

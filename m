Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3AXEs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:48:28 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:60291 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3AXEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:48:23 -0500
MIME-Version: 1.0
In-Reply-To: <1358955452-20960-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358955452-20960-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 24 Jan 2013 10:10:03 +0530
X-Google-Sender-Auth: wh2tBZcMFqZeLWIvDnYST7Jq56E
Message-ID: <CAOh2x=n5BN5Y8RSPCEyWO6QZSQBaSaWuKdF958mGGDAHGQ-fQA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] dw_dmac: fill individual length of descriptor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 9:07 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> It will be useful to have the length of the transfer in the descriptor. The
> cyclic transfer functions remained untouched.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c3062a5..026a3c7 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -756,6 +756,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>                 desc->lli.dar = dest + offset;
>                 desc->lli.ctllo = ctllo;
>                 desc->lli.ctlhi = xfer_count;
> +               desc->len = xfer_count << src_width;
>
>                 if (!first) {
>                         first = desc;
> @@ -852,8 +853,8 @@ slave_sg_todev_fill_desc:
>                                 dlen = len;
>                                 len = 0;
>                         }
> -

:(

>                         desc->lli.ctlhi = dlen >> mem_width;
> +                       desc->len = dlen;
>
>                         if (!first) {
>                                 first = desc;
> @@ -912,6 +913,7 @@ slave_sg_fromdev_fill_desc:
>                                 len = 0;
>                         }
>                         desc->lli.ctlhi = dlen >> reg_width;
> +                       desc->len = dlen;
>
>                         if (!first) {
>                                 first = desc;

After fixing that.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3CSSay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab3CSSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:30:53 -0400
Date: Tue, 19 Mar 2013 15:30:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Prabhakar lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v2] davinci: vpif: Fix module build for capture and
 display
Message-ID: <20130319153043.23f7d127@redhat.com>
In-Reply-To: <1362739747-4166-1-git-send-email-prabhakar.lad@ti.com>
References: <1362739747-4166-1-git-send-email-prabhakar.lad@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri,  8 Mar 2013 16:19:07 +0530
Prabhakar lad <prabhakar.csengg@gmail.com> escreveu:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> export the symbols which are used by two modules vpif_capture and
> vpif_display.
> 
> This patch fixes following error:
> ERROR: "ch_params" [drivers/media/platform/davinci/vpif_display.ko] undefined!
> ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_display.ko] undefined!
> ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_display.ko] undefined!
> ERROR: "ch_params" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
> ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
> ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> Reported-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Changes for v2:
>  1: use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL() as pointed by
>     Sekhar.
> 
>  drivers/media/platform/davinci/vpif.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 28638a8..42c7eba 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -44,6 +44,8 @@ static struct resource	*res;
>  spinlock_t vpif_lock;
>  
>  void __iomem *vpif_base;
> +EXPORT_SYMBOL_GPL(vpif_base);
> +
>  struct clk *vpif_clk;
>  
>  /**
> @@ -220,8 +222,10 @@ const struct vpif_channel_config_params ch_params[] = {
>  		.stdid = V4L2_STD_625_50,
>  	},
>  };
> +EXPORT_SYMBOL_GPL(ch_params);

Please don't use simple names like that. It would be very easy that some
other driver could try to declare the same symbol. Instead, prefix it
with the driver name (vpif_ch_params).

>  
>  const unsigned int vpif_ch_params_count = ARRAY_SIZE(ch_params);
> +EXPORT_SYMBOL_GPL(vpif_ch_params_count);
>  
>  static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
>  {

Regards,
Mauro

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab3CHJXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:23:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36318 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab3CHJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:23:10 -0500
Message-ID: <5139ADF5.2050307@ti.com>
Date: Fri, 8 Mar 2013 14:53:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH] davinci: vpif: Fix module build for capture and display
References: <1362640461-29106-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1362640461-29106-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 3/7/2013 12:44 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
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
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> ---
>  drivers/media/platform/davinci/vpif.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 28638a8..8fbb4a2 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -44,6 +44,8 @@ static struct resource	*res;
>  spinlock_t vpif_lock;
>  
>  void __iomem *vpif_base;
> +EXPORT_SYMBOL(vpif_base);

Should be EXPORT_SYMBOL_GPL() as nothing except GPL code would be
needing this internal symbol.

Also exporting this shows that the driver is written for only one
instance. It seems to me that the driver modules can use much better
abstractions so all these exports wont be needed but having broken
module build is bad as well.

Thanks,
Sekhar

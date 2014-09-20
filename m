Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaITRwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:52:00 -0400
Received: from mout.gmx.net ([212.227.17.20]:55579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044AbaITRv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:51:58 -0400
Date: Sat, 20 Sep 2014 19:51:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Pramod Gurav <pramod.gurav@smartplayin.com>
cc: linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: usdhi6rol0: Remove unnecessary header files
In-Reply-To: <1411234994-25520-1-git-send-email-pramod.gurav@smartplayin.com>
Message-ID: <Pine.LNX.4.64.1409201948520.25711@axis700.grange>
References: <1411234994-25520-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:WorbYGFb3faDYpj83RgXkPiAKwL6OOsDLnEOt7QqkxiB96sO9eY
 g/+nBYVNbhDMj3TsRfpV/9h1xWUXPOUUCQ852tLd73HmdC+42r1SCGziLXh3JwdwMem8na0
 tZ7qhAiLgRKTEcgjHmeeY2uroHCdjrJmrkevJtkFN0lRNQpZoi6yKX9mY/Ukvb3Okjttirg
 mfHXsjV79bdCr5T/72B7g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2014, Pramod Gurav wrote:

> These headers are not required hence this change removes them from
> the driver.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

NAK. The fact, that code builds without certain headers doesn't mean, they 
aren't needed. E.g. string.h is needed for memcpy(), scatterlist.h is 
needed for struct scatterlist etc.

Thanks
Guennadi

> ---
>  drivers/mmc/host/usdhi6rol0.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
> index f0a39eb..4094d8f 100644
> --- a/drivers/mmc/host/usdhi6rol0.c
> +++ b/drivers/mmc/host/usdhi6rol0.c
> @@ -12,21 +12,14 @@
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/dmaengine.h>
> -#include <linux/highmem.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> -#include <linux/log2.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/mmc.h>
> -#include <linux/mmc/sd.h>
>  #include <linux/mmc/sdio.h>
>  #include <linux/module.h>
>  #include <linux/pagemap.h>
>  #include <linux/platform_device.h>
> -#include <linux/scatterlist.h>
> -#include <linux/string.h>
> -#include <linux/time.h>
> -#include <linux/virtio.h>
>  #include <linux/workqueue.h>
>  
>  #define USDHI6_SD_CMD		0x0000
> -- 
> 1.8.3.2
> 

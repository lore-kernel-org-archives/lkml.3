Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579Ab3DQUFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:05:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935448Ab3DQUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:05:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 29/30] spi: s3c64xx: move to generic dmaengine API
Date: Wed, 17 Apr 2013 22:05:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Padma Venkat <padma.kvr@gmail.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-30-git-send-email-arnd@arndb.de>
In-Reply-To: <1365638712-1028578-30-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304172205.35526.arnd@arndb.de>
X-Provags-ID: V02:K0:OJYCGGwdTSin+oVl9x0mD2fbv70lRvdzfd8AlGOrMRZ
 8f6md3G+sIdifwHdcZe8JXapbcFG+zq1j+mUB9GGfZuXxvtR+Z
 8kjWLK9frQ8rcNQe1R8S3w7MBJGWqMKy9o8eYqjTN61PVxAcri
 ZVDHWb+rdgEbFrgX8ejyBh6Y3E2jMFTZOjf3I+wc9wa2L1Qqzy
 mCDzhZBXWUUm2IrN4xes8ubdiFV3a0O8QeLVhpUH9vt2VGYCTc
 jqqMEBXA0QpyZUpmQXow6UVDC+KXdJ61q7uEKmjzkogk8DBzxG
 OGSgVwp5w8zc1S1fG1zkOrw8NrICAmGNZH2yQw8js+3wO9QVaU
 hVk64FlKOlCBthGjfW0s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Arnd Bergmann wrote:
> @@ -713,9 +836,9 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
>                 }
>  
>                 /* Polling method for xfers not bigger than FIFO capacity */
> -               if (xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
> -                       use_dma = 0;
> -               else
> +               use_dma = 0;
> +               if (sdd->rx_dma.ch && sdd->tx_dma.ch &&
> +                   (xfer->len > ((FIFO_LVL_MASK(sdd) >> 1) + 1)))
>                         use_dma = 1;
>  
>                 spin_lock_irqsave(&sdd->lock, flags);

Can you try just reverting this hunk? It's actually not required and
comes from an earlier version of the patch. I assumed it was harmless,
but it's the only think I see that should actually make a difference
in my patch for the case of !CONFIG_SAMSUNG_DMADEV.

	Arnd

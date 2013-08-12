Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3HLHS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:18:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50986 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3HLHSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:18:24 -0400
Message-ID: <52088BFA.8090004@ti.com>
Date: Mon, 12 Aug 2013 12:47:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 03/12] dma: edma: remove limits on number of slots
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-4-git-send-email-joelf@ti.com>
In-Reply-To: <1375719297-12871-4-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
> With this series, this check is no longer required and
> we shouldn't need to reject drivers DMA'ing more than the
> MAX number of slots.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  drivers/dma/edma.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 7b0853c..b6d609c 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -247,12 +247,6 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  		return NULL;
>  	}
>  
> -	if (sg_len > MAX_NR_SG) {
> -		dev_err(dev, "Exceeded max SG segments %d > %d\n",
> -			sg_len, MAX_NR_SG);
> -		return NULL;
> -	}

This patch comes too early. Should be moved to the end of the series
when the support you rely on is actually present.

Thanks,
Sekhar


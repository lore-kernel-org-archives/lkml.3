Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3HLL14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:27:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3HLL1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:27:53 -0400
Message-ID: <52087921.8040101@ti.com>
Date: Mon, 12 Aug 2013 11:26:49 +0530
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
Subject: Re: [PATCH v3 08/12] dma: edma: Add one more required slot to MAX
 slots
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-9-git-send-email-joelf@ti.com>
In-Reply-To: <1375719297-12871-9-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
> We'd now need a separate slot just for the channel and separate
> ones for the 2 linked sets, so we make adjustments to allocate
> an extra channel accordingly.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>

No need for a separate patch for this, just do this in the patch where
you include the two linked sets.

> ---
>  drivers/dma/edma.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index a242269..df50a04 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -48,7 +48,7 @@
>  
>  /* Max of 16 segments per channel to conserve PaRAM slots */
>  #define MAX_NR_SG		16
> -#define EDMA_MAX_SLOTS		MAX_NR_SG
> +#define EDMA_MAX_SLOTS		(MAX_NR_SG+1)
>  #define EDMA_DESCRIPTORS	16
>  
>  struct edma_desc {
> @@ -311,6 +311,9 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  
>  	num_slots_needed = sg_len > MAX_NR_SG ? MAX_NR_SG : sg_len;
>  
> +	/* Allocate one extra to account for the channel itself */
> +	num_slots_needed++;

You can do:

	nslots = min(MAX_NR_SG, sg_len) + 1;

Thanks,
Sekhar


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3GXICw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:02:52 -0400
Received: from smtp-out-124.synserver.de ([212.40.185.124]:1127 "EHLO
	smtp-out-124.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GXICs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:02:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26856
Message-ID: <51EF8A52.90902@metafoo.de>
Date: Wed, 24 Jul 2013 10:03:30 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Balaji TK <balajitk@ti.com>, Matt Porter <matt@ohporter.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] dma: edma: add device_slave_caps() support
References: <1374597804-3961-1-git-send-email-joelf@ti.com>
In-Reply-To: <1374597804-3961-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 06:43 PM, Joel Fernandes wrote:
> Implement device_slave_caps(). EDMA has a limited number of slots.
> Slave drivers such as omap_hsmmc will query the driver to make
> sure they don't pass in more than these many scatter segments.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
> Vinod, or Dan- If this patch looks ok, can you please merge in for
> -rc cycle? This patch is required to fix MMC support on AM33xx. This
> patch is blocking 3 other patches which fix various MMC things. Thanks!
> 
> Notes:
> (1) this approach is temporary and only for -rc cycle to fix MMC on
> AM335x. It will be replace by the RFC series in future kernels:
> http://www.spinics.net/lists/arm-kernel/msg260094.html
> 
> (2) Patch depends Vinod's patch at:
> http://permalink.gmane.org/gmane.linux.kernel/1525112
> 
>  drivers/dma/edma.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 7222cbe..81d5429 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -517,6 +517,14 @@ static void edma_issue_pending(struct dma_chan *chan)
>  	spin_unlock_irqrestore(&echan->vchan.lock, flags);
>  }
>  
> +static inline int edma_slave_caps(struct dma_chan *chan,
> +	struct dma_slave_caps *caps)
> +{
> +	caps->max_sg_nr = MAX_NR_SG;

Hm, what about the other fields?

- Lars


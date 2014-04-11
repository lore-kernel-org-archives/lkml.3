Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaDKIRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:17:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35404 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaDKIRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:17:30 -0400
Message-ID: <5347A4FD.1030803@ti.com>
Date: Fri, 11 Apr 2014 13:47:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default
 when booted with DT
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2014 06:36 PM, Peter Ujfalusi wrote:
> Use the EVENTQ_1 for default and leave the EVENTQ_0 to be used by high
> priority channels, like audio.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Sekhar Nori <nsekhar@ti.com>

> ---
>  arch/arm/common/edma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 86a8b263278f..19520e2519d9 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1546,7 +1546,8 @@ static int edma_of_parse_dt(struct device *dev,
>  
>  	pdata->queue_priority_mapping = queue_priority_map;
>  
> -	pdata->default_queue = 0;
> +	/* select queue 1 as default */

It will be nice to expand the comment with explanation of why this is
being chosen as default (lower priority queue by default for typical
bulk data transfer).

Thanks,
Sekhar


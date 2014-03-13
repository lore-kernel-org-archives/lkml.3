Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCMNEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:04:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:5672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbaCMNEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:04:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,647,1389772800"; 
   d="scan'208";a="471611778"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "joelf@ti.com" <joelf@ti.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "nsekhar@ti.com" <nsekhar@ti.com>, Jyri Sarha <jsarha@ti.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 13/18] dma: edma: Print the direction value as well when
 it is not supported
Thread-Topic: [PATCH 13/18] dma: edma: Print the direction value as well
 when it is not supported
Thread-Index: AQHPPryYos0186e9ykK9XzFefk2qIw==
Date: Thu, 13 Mar 2014 13:03:14 +0000
Message-ID: <1394715793.28803.240.camel@smile.fi.intel.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
	 <1394702320-21743-14-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1394702320-21743-14-git-send-email-peter.ujfalusi@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <41A220705C2C6041A5907B14F67B3C4B@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DD4dso009297

On Thu, 2014-03-13 at 11:18 +0200, Peter Ujfalusi wrote:
> In case of not supported direction it is better to print the direction also.
> It is unlikely, but in such an event it helps with the debugging.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/edma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 47abaac7eb18..69dd4e3de67e 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -426,7 +426,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  		dev_width = echan->cfg.dst_addr_width;
>  		burst = echan->cfg.dst_maxburst;
>  	} else {
> -		dev_err(dev, "%s: bad direction?\n", __func__);
> +		dev_err(dev, "%s: bad direction: %d\n", __func__, direction);

Is it possible to have direction less than zero? Maybe %u?

>  		return NULL;
>  	}
>  
> @@ -519,7 +519,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>  		dev_width = echan->cfg.dst_addr_width;
>  		burst = echan->cfg.dst_maxburst;
>  	} else {
> -		dev_err(dev, "%s: bad direction?\n", __func__);
> +		dev_err(dev, "%s: bad direction: %d\n", __func__, direction);

Ditto.

>  		return NULL;
>  	}
>  


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

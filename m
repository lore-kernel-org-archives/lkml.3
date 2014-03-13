Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaCMMyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:54:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50181 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaCMMyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,647,1389772800"; 
   d="scan'208";a="499155227"
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
Subject: Re: [PATCH 10/18] dma: edma: Reduce debug print verbosity for non
 verbose debugging
Thread-Topic: [PATCH 10/18] dma: edma: Reduce debug print verbosity for non
 verbose debugging
Thread-Index: AQHPPrs9scX03rm1vUGLeGHgT19EDA==
Date: Thu, 13 Mar 2014 12:53:32 +0000
Message-ID: <1394715211.28803.239.camel@smile.fi.intel.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
	 <1394702320-21743-11-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1394702320-21743-11-git-send-email-peter.ujfalusi@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA549397B971CB4A9B3CE0783EBD2F9A@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DCseg3009242

On Thu, 2014-03-13 at 11:18 +0200, Peter Ujfalusi wrote:
> Do not print the paRAM information when verbose debugging is not asked and
> also reduce the number of lines printed in edma_prep_dma_cyclic()
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/edma.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index e4f4a0cef58c..e2aa42b8342f 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -141,7 +141,7 @@ static void edma_execute(struct edma_chan *echan)
>  	for (i = 0; i < nslots; i++) {
>  		j = i + edesc->processed;
>  		edma_write_slot(echan->slot[i], &edesc->pset[j]);
> -		dev_dbg(echan->vchan.chan.device->dev,
> +		dev_vdbg(echan->vchan.chan.device->dev,
>  			"\n pset[%d]:\n"
>  			"  chnum\t%d\n"
>  			"  slot\t%d\n"

I believe you may move this code to separate function and reuse it
later.
Moreover %d is not good specifier for unsigned types, maybe %u?

> @@ -554,9 +554,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>  	edesc->cyclic = 1;
>  	edesc->pset_nr = nslots;
>  
> -	dev_dbg(dev, "%s: nslots=%d\n", __func__, nslots);
> -	dev_dbg(dev, "%s: period_len=%d\n", __func__, period_len);
> -	dev_dbg(dev, "%s: buf_len=%d\n", __func__, buf_len);
> +	dev_dbg(dev, "%s: channel=%d nslots=%d period_len=%d buf_len=%d\n",
> +		__func__, echan->ch_num, nslots, period_len, buf_len);

Consider to use proper specifiers for size_t types, namely %zd.

>  
>  	for (i = 0; i < nslots; i++) {
>  		/* Allocate a PaRAM slot, if needed */
> @@ -590,8 +589,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>  		else
>  			src_addr += period_len;
>  
> -		dev_dbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
> -		dev_dbg(dev,
> +		dev_vdbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
> +		dev_vdbg(dev,

See the first comment.

>  			"\n pset[%d]:\n"
>  			"  chnum\t%d\n"
>  			"  slot\t%d\n"


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

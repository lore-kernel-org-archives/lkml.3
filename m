Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaB0ItQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:49:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:20350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaB0ItO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:49:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,553,1389772800"; 
   d="scan'208";a="482768922"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: George Cherian <george.cherian@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "msmucr@gmail.com" <msmucr@gmail.com>
Subject: Re: [PATCH 1/2] dma: cppi41: start tear down only if channel is busy
Thread-Topic: [PATCH 1/2] dma: cppi41: start tear down only if channel is
 busy
Thread-Index: AQHPM5iTO8fLMKA/lkyF5JVoK0j/sQ==
Date: Thu, 27 Feb 2014 08:47:42 +0000
Message-ID: <1393490862.28803.40.camel@smile.fi.intel.com>
References: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
	 <1393478081-14226-2-git-send-email-george.cherian@ti.com>
In-Reply-To: <1393478081-14226-2-git-send-email-george.cherian@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DFADB4AF6F9094D8C0F09AAC57CD7BB@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1R8nQeF005334

On Thu, 2014-02-27 at 10:44 +0530, George Cherian wrote:
> Start the channel tear down only if the channel is busy, else just
> bail out. In some cases its seen that by the time the tear down is
> initiated the cppi completes the DMA, especially in ISOCH transfers.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/dma/cppi41.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
> index c18aebf..d028f36 100644
> --- a/drivers/dma/cppi41.c
> +++ b/drivers/dma/cppi41.c
> @@ -620,12 +620,15 @@ static int cppi41_stop_chan(struct dma_chan *chan)
>  	u32 desc_phys;
>  	int ret;
>  
> +	desc_phys = lower_32_bits(c->desc_phys);
> +	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
> +	if (!cdd->chan_busy[desc_num])
> +		return 0;
> +
>  	ret = cppi41_tear_down_chan(c);
>  	if (ret)
>  		return ret;
>  
> -	desc_phys = lower_32_bits(c->desc_phys);
> -	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
>  	WARN_ON(!cdd->chan_busy[desc_num]);

Do you still need this WARN_ON?

>  	cdd->chan_busy[desc_num] = NULL;
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

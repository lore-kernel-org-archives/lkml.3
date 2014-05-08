Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaEHQJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:09:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:16585 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbaEHQJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="537162083"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] dmaengine: sa11x0: remove broken #ifdef
Thread-Topic: [PATCH 2/2] dmaengine: sa11x0: remove broken #ifdef
Thread-Index: AQHPatfFAFKK6QqdXEq+jdpkqtNSmg==
Date: Thu, 8 May 2014 16:08:37 +0000
Message-ID: <1399565317.9018.4.camel@smile.fi.intel.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
	 <1399560990-1402858-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1399560990-1402858-2-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CF71209FF0DB34EB73765C629F6DE94@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s48G9BHe028748

On Thu, 2014-05-08 at 16:56 +0200, Arnd Bergmann wrote:
> The sa11x0_dma_pm_ops unconditionally reference sa11x0_dma_resume
> and sa11x0_dma_suspend, which currently breaks if CONFIG_PM_SLEEP
> is disabled.
> 
> There is probably a better way to remove the reference in this
> case, but the safe choice is to have the suspend/resume code always
> built in the driver.

Maybe you could create a macro in pm.h for *_noirq version of
suspend/resume? However, like we discussed with Vinod it's much better
to use suspend_late/resume_early for DMAC device drivers, though I have
no idea if it works for sa11x0.

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: dmaengine@vger.kernel.org
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dma/sa11x0-dma.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
> index ab26d46..5ebdfbc 100644
> --- a/drivers/dma/sa11x0-dma.c
> +++ b/drivers/dma/sa11x0-dma.c
> @@ -113,11 +113,9 @@ struct sa11x0_dma_phy {
>  	struct sa11x0_dma_desc	*txd_load;
>  	unsigned		sg_done;
>  	struct sa11x0_dma_desc	*txd_done;
> -#ifdef CONFIG_PM_SLEEP
>  	u32			dbs[2];
>  	u32			dbt[2];
>  	u32			dcsr;
> -#endif
>  };
>  
>  struct sa11x0_dma_dev {
> @@ -984,7 +982,6 @@ static int sa11x0_dma_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
>  static int sa11x0_dma_suspend(struct device *dev)
>  {
>  	struct sa11x0_dma_dev *d = dev_get_drvdata(dev);
> @@ -1054,7 +1051,6 @@ static int sa11x0_dma_resume(struct device *dev)
>  
>  	return 0;
>  }
> -#endif
>  
>  static const struct dev_pm_ops sa11x0_dma_pm_ops = {
>  	.suspend_noirq = sa11x0_dma_suspend,


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

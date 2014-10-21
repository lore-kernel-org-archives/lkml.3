Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaJULLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:11:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:38769 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbaJULLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:11:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,761,1406617200"; 
   d="scan'208";a="617799179"
Date: Tue, 21 Oct 2014 16:03:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mark Brown <broonie@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Herve Codina <Herve.CODINA@celad.com>, Bo Shen <voice.shen@atmel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Huang Shijie <shijie8@gmail.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH 1/2] mtd: atmel_nand: use __iowrite32_copy for 32 bit
 copy
Message-ID: <20141021103336.GI28745@intel.com>
References: <1413821173-18347-1-git-send-email-vinod.koul@intel.com>
 <54462F6C.1030307@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54462F6C.1030307@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:03:24PM +0800, Josh Wu wrote:
> Hi, Vinod
> 
> On 10/21/2014 12:06 AM, Vinod Koul wrote:
> >The driver was also using own method to do 32bit copy, turns out
> >we have a kernel API so use that instead
> >
> >Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> 
> Thanks for the patch.
> Acked-by: Josh Wu <josh.wu@atmel.com>
> 
> BTW, is there any similar kernel API that is for the read from io?
I have not stumbled out on that yet, if someone know of it pls yell!!
If there seems to be lack of it, I would suggest we add a similar API in
core like __iowrite32_copy()

-- 
~Vinod

> 
> Best Regards,
> Josh Wu
> 
> >---
> >  drivers/mtd/nand/atmel_nand.c |   10 +++-------
> >  1 files changed, 3 insertions(+), 7 deletions(-)
> >
> >diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> >index e321c56..b03e80d 100644
> >--- a/drivers/mtd/nand/atmel_nand.c
> >+++ b/drivers/mtd/nand/atmel_nand.c
> >@@ -265,14 +265,10 @@ static void memcpy32_fromio(void *trg, const void __iomem  *src, size_t size)
> >  		*t++ = readl_relaxed(s++);
> >  }
> >-static void memcpy32_toio(void __iomem *trg, const void *src, int size)
> >+static inline void memcpy32_toio(void __iomem *trg, const void *src, int size)
> >  {
> >-	int i;
> >-	u32 __iomem *t = trg;
> >-	const u32 *s = src;
> >-
> >-	for (i = 0; i < (size >> 2); i++)
> >-		writel_relaxed(*s++, t++);
> >+	/* __iowrite32_copy use 32bit size values so divide by 4 */
> >+	__iowrite32_copy(trg, src, size/4);
> >  }
> >  /*
> 

-- 

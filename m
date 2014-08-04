Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaHDVRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:17:42 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51862 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHDVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:17:41 -0400
Date: Mon, 4 Aug 2014 14:17:37 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Raphael Poggi <poggi.raph@gmail.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: atmel_nand: increase chip_delay
Message-ID: <20140804211737.GY3711@ld-irv-0074>
References: <1406640447-9080-1-git-send-email-poggi.raph@gmail.com>
 <53D8BC92.4050907@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D8BC92.4050907@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 05:36:18PM +0800, Josh Wu wrote:
> On 7/29/2014 9:27 PM, Raphael Poggi wrote:
> >Some nand with 8k page size like Micron MT29F32G08ABAAAWP need more than 20us.
> >
> >Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
> >---
> >  drivers/mtd/nand/atmel_nand.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> >index e321c56..77bd877 100644
> >--- a/drivers/mtd/nand/atmel_nand.c
> >+++ b/drivers/mtd/nand/atmel_nand.c
> >@@ -2099,7 +2099,7 @@ static int atmel_nand_probe(struct platform_device *pdev)
> >  	}
> >  	nand_chip->ecc.mode = host->board.ecc_mode;
> >-	nand_chip->chip_delay = 20;		/* 20us command delay time */
> >+	nand_chip->chip_delay = 40;		/* 40us command delay time */
> >  	if (host->board.bus_width_16)	/* 16-bit bus width */
> >  		nand_chip->options |= NAND_BUSWIDTH_16;
> 
> I just post a patch [1] days ago which does almost the same thing to
> support 4k-page nand flash.
> personally I am fine with your patch.
> 
> Brain, you only need to take care this patch. And drop my patch [1].
> 
> [1] http://patchwork.ozlabs.org/patch/372406/

OK, queued to l2-mtd.git/next. Thanks!

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaIHIbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:31:42 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39548 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaIHIbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:31:40 -0400
X-Originating-IP: 50.43.15.134
Date: Mon, 8 Sep 2014 01:30:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mtd: denali: remove a set-but-unused variable
Message-ID: <20140908083057.GB5361@thin>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
 <1410163813-31783-6-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410163813-31783-6-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:10:11PM +0900, Masahiro Yamada wrote:
> The variable "retry" in wait_for_irq() is set, but not referenced.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Sure enough.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> 
>  drivers/mtd/nand/denali.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
> index 259ca0ba..d37c2e1 100644
> --- a/drivers/mtd/nand/denali.c
> +++ b/drivers/mtd/nand/denali.c
> @@ -697,7 +697,6 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
>  {
>  	unsigned long comp_res;
>  	uint32_t intr_status;
> -	bool retry = false;
>  	unsigned long timeout = msecs_to_jiffies(1000);
>  
>  	do {
> @@ -717,7 +716,6 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
>  			 * need to wait again
>  			 */
>  			spin_unlock_irq(&denali->irq_lock);
> -			retry = true;
>  		}
>  	} while (comp_res != 0);
>  
> -- 
> 1.9.1
> 

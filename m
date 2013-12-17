Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3LQJY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:24:57 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48086 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3LQJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:24:54 -0500
Date: Tue, 17 Dec 2013 01:24:49 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, grygorii.strashko@ti.com,
        dwmw2@infradead.org
Subject: Re: [PATCH v3 1/9] mtd: nand: davinci: fix driver registration
Message-ID: <20131217092449.GL12034@norris-Latitude-E6410>
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1386264358-9738-2-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386264358-9738-2-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 07:25:49PM +0200, Ivan Khoronzhuk wrote:
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -877,6 +877,7 @@ static int __exit nand_davinci_remove(struct platform_device *pdev)
>  }
>  
>  static struct platform_driver nand_davinci_driver = {
> +	.probe		= nand_davinci_probe,
>  	.remove		= __exit_p(nand_davinci_remove),

I believe you need to drop the __exit_p() here. And now that you're
using module_platform_driver(), you need to drop the __init and __exit
from the probe() and remove() routines, to avoid section mismatch
warnings.

>  	.driver		= {
>  		.name	= "davinci_nand",

So on second thought, please resubmit the series with the requested
changes.

Thanks,
Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3E3OAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:00:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50521 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3E3OAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:00:15 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 May 2013 07:00:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/3] watchdog: xilinx: Setup the origin compatible string
Message-ID: <20130530140041.GA28232@roeck-us.net>
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
 <eef4939944768b2d8cbed2bcb4cf75954b86fc27.1369916757.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef4939944768b2d8cbed2bcb4cf75954b86fc27.1369916757.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:26:03PM +0200, Michal Simek wrote:
> Watchdog 1.01.a is also compatible with 1.00.a.
> Setup the origin version to compatible list.
> If you want to use newer watchdog version, please
> extend your compatible list.
> 
> For example:
> compatible = "xlnx,xps-timebase-wdt-1.02.a", "xlnx,xps-timebase-wdt-1.00.a";
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/watchdog/of_xilinx_wdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
> index d4a35ab..79f358c 100644
> --- a/drivers/watchdog/of_xilinx_wdt.c
> +++ b/drivers/watchdog/of_xilinx_wdt.c
> @@ -384,7 +384,7 @@ static int xwdt_remove(struct platform_device *dev)
> 
>  /* Match table for of_platform binding */
>  static struct of_device_id xwdt_of_match[] = {
> -	{ .compatible = "xlnx,xps-timebase-wdt-1.01.a", },
> +	{ .compatible = "xlnx,xps-timebase-wdt-1.00.a", },

Is this really a good idea ? It means every existing device tree binding which
specifies 1.01a will now fail. If the code is compatible to 1.00a, I think it
would make more sense to add that to the driver as additional entry instead of
deleting the existing entry for 1.01a.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3E3OHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:07:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51634 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3E3OH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:07:28 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 May 2013 07:07:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: xilinx: Add WDIOC_SETTIMEOUT ioctl function
Message-ID: <20130530140754.GB28232@roeck-us.net>
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
 <595eb49b34909318959fe6825c209a7d635ed849.1369916757.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <595eb49b34909318959fe6825c209a7d635ed849.1369916757.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:26:04PM +0200, Michal Simek wrote:
> Standard watchdog programs try to setup timeout
> via ioctl and this functionality should be implemented.
> Timeout value is hardcoded in the hardware but
> based on Documentation/watchdog/watchdog-api.txt
> can return the real timeout used in the same variable.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/watchdog/of_xilinx_wdt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
> index 79f358c..a3bbe72 100644
> --- a/drivers/watchdog/of_xilinx_wdt.c
> +++ b/drivers/watchdog/of_xilinx_wdt.c
> @@ -253,6 +253,7 @@ static long xwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		xwdt_keepalive();
>  		return 0;
> 
> +	case WDIOC_SETTIMEOUT:
>  	case WDIOC_GETTIMEOUT:
>  		if (no_timeout)
>  			return -ENOTTY;

Watchdog programs should check ident.options before trying to set the timeout.
If they don't, there is an application bug. I don't think it is a good idea
to start hacking the kernel to work around application bugs.

Guenter

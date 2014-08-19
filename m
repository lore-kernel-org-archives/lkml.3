Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaHSO70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:59:26 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42757 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHSO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:59:25 -0400
Date: Tue, 19 Aug 2014 07:59:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: ts72xx_wdt: Kill superfluous variable in remove
Message-ID: <20140819145916.GC18536@roeck-us.net>
References: <1408449432-25274-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408449432-25274-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:57:12PM +0300, Mika Westerberg wrote:
> There is no need to store the return value of misc_deregister() in a
> variable. Instead we can just return the value directly.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/watchdog/ts72xx_wdt.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
> index afa9d6ef353a..dee9c6cbe6df 100644
> --- a/drivers/watchdog/ts72xx_wdt.c
> +++ b/drivers/watchdog/ts72xx_wdt.c
> @@ -428,11 +428,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
>  
>  static int ts72xx_wdt_remove(struct platform_device *pdev)
>  {
> -	int error;
> -
> -	error = misc_deregister(&ts72xx_wdt_miscdev);
> -
> -	return error;
> +	return misc_deregister(&ts72xx_wdt_miscdev);

Is that worth it, and does it even reduce code size ?
Converting the driver to use the watchdog infrastructure would make much more sense
(if someone can test the result).

Guenter

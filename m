Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3JCQrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:47:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55495 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3JCQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:47:08 -0400
Date: Thu, 3 Oct 2013 09:47:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 8/9] watchdog: sp805_wdt: Remove unnecessary
 amba_set_drvdata()
Message-ID: <20131003164701.GB31605@roeck-us.net>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
 <7a51da3b47e0dd14d9ad13853f649463dba9350f.1380793579.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a51da3b47e0dd14d9ad13853f649463dba9350f.1380793579.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:46:30AM +0200, Michal Simek wrote:
> Driver core clears the driver data to NULL after device_release
> or on probe failure, so just remove it from here.
> 
> Driver core change:
> "device-core: Ensure drvdata = NULL when no driver is bound"
> (sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/watchdog/sp805_wdt.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
> index 58df98a..3f786ce 100644
> --- a/drivers/watchdog/sp805_wdt.c
> +++ b/drivers/watchdog/sp805_wdt.c
> @@ -268,7 +268,6 @@ static int sp805_wdt_remove(struct amba_device *adev)
>  	struct sp805_wdt *wdt = amba_get_drvdata(adev);
> 
>  	watchdog_unregister_device(&wdt->wdd);
> -	amba_set_drvdata(adev, NULL);
>  	watchdog_set_drvdata(&wdt->wdd, NULL);

This one is quite unnecessary as well. The wdt data structure will be freed
as part of the removal. That could be a separate patch, though, so still

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

If you like, feel free to resubmit with the watchdog_set_drvdata() removed
and keep my Reviewed-by.

Thanks,
Guenter

> 
>  	return 0;
> --
> 1.8.2.3
> 



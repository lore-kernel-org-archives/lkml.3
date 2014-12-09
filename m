Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaLIIqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:46:37 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:45192 "EHLO
	spo001.leaseweb.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752530AbaLIIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:46:36 -0500
X-Greylist: delayed 1619 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 03:46:35 EST
Date: Tue, 9 Dec 2014 09:19:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Robert Yang <hachyang@gmail.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        ryang <ryang@hach.com>
Subject: Re: [PATCH 1/1] Watchdog: Fixed the watchdog close/stop logic - only close the watchdog if the magic character was received and the magic close is supported.
Message-ID: <20141209081934.GN8811@spo001.leaseweb.nl>
References: <1418060711-47872-1-git-send-email-hachyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418060711-47872-1-git-send-email-hachyang@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryang,

> From: ryang <ryang@hach.com>
> 
> Signed-off-by: ryang <ryang@hach.com>
> ---
>  drivers/watchdog/watchdog_dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index 6aaefba..73793d8 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -471,8 +471,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
>  	 */
>  	if (!test_bit(WDOG_ACTIVE, &wdd->status))
>  		err = 0;
> -	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
> -		 !(wdd->info->options & WDIOF_MAGICCLOSE))
> +	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) &&
> +		(wdd->info->options & WDIOF_MAGICCLOSE))
>  		err = watchdog_stop(wdd);
>  
>  	/* If the watchdog was not stopped, send a keepalive ping */
> -- 

There is no reason for this change; you either have:
1) WDIOF_MAGICCLOSE is not supported and thus watchog may be stopped.
2) If a watchdog daemon crashes and thus closes the watchdog device (and thus it did not sent a Magic Char) then the watchdog should not be stopped but needs to reboot the system.

Kind regards,
Wim.


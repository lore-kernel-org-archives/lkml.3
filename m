Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaLHUMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:12:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35075 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaLHUMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:12:07 -0500
Date: Mon, 8 Dec 2014 12:11:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Robert Yang <hachyang@gmail.com>
Cc: Wim Van Seroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryang <ryang@hach.com>
Subject: Re: [PATCH 1/1] Watchdog: Fixed the watchdog close/stop logic - only
 close the watchdog if the magic character was received and the magic close
 is supported.
Message-ID: <20141208201158.GA29618@roeck-us.net>
References: <1418060711-47872-1-git-send-email-hachyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418060711-47872-1-git-send-email-hachyang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54860617.0004,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:45:11AM -0700, Robert Yang wrote:
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
Why ?

Guenter

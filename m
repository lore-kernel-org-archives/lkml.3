Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaJYUhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:37:19 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:55426 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJYUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:37:17 -0400
Date: Sat, 25 Oct 2014 13:36:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, zajec5@gmail.com,
        arend@broadcom.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcma: fix build when CONFIG_OF_ADDRESS is not set
Message-ID: <20141025203653.GA10716@roeck-us.net>
References: <5436D3CF.2030506@hauke-m.de>
 <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.544C09FC.0191,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 9
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

On Thu, Oct 09, 2014 at 11:39:41PM +0200, Hauke Mehrtens wrote:
> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> introduces a hard dependency on OF_ADDRESS into the bcma driver.
> OF_ADDRESS is specifically disabled for the sparc architecture.
> This results in the following error when building sparc64:allmodconfig.
> 
> drivers/bcma/main.c: In function 'bcma_of_find_child_device':
> drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'
> 
> Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

The upstream kernel still does not include this patch, and the sparc64 build
is still broken.

Is this patch on its way upstream ?

Guenter

> ---
>  drivers/bcma/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index d1656c2..1000955 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -132,7 +132,7 @@ static bool bcma_is_core_needed_early(u16 core_id)
>  	return false;
>  }
>  
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_OF_ADDRESS)
>  static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
>  						     struct bcma_device *core)
>  {
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

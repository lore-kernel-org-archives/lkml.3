Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaLOVa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:30:26 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38124 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaLOVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:30:25 -0500
Date: Mon, 15 Dec 2014 13:29:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Martin Kepplinger <martink@posteo.de>
Cc: peterz@infradead.org, mingo@kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] hwmon: jc42: use bitops' sign_extend16
Message-ID: <20141215212948.GA23765@roeck-us.net>
References: <1418660317-21750-1-git-send-email-martink@posteo.de>
 <1418660317-21750-4-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418660317-21750-4-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010201.548F52F0.05C7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On Mon, Dec 15, 2014 at 05:18:34PM +0100, Martin Kepplinger wrote:
> ---

Some description would be nice. Also, please consider adding
relevant subsystem mailing lists and maintainers to your patches.

>  drivers/hwmon/jc42.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
> index 388f8bc..335a2de 100644
> --- a/drivers/hwmon/jc42.c
> +++ b/drivers/hwmon/jc42.c
> @@ -31,6 +31,7 @@
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/bitops.h>
>  
>  /* Addresses to scan */
>  static const unsigned short normal_i2c[] = {
> @@ -215,9 +216,7 @@ static int jc42_temp_from_reg(s16 reg)
>  {
>  	reg &= 0x1fff;
>  
If I understand the code in sign_extend16 correctly, the above mask
should no longer be necessary.

Thanks,
Guenter

> -	/* sign extend register */
> -	if (reg & 0x1000)
> -		reg |= 0xf000;
> +	reg = sign_extend16(reg, 12);
>  
>  	/* convert from 0.0625 to 0.001 resolution */
>  	return reg * 125 / 2;
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

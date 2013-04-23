Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3DWO0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:26:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41717 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab3DWO0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:26:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] isapnp: remove debug leftovers
Date: Tue, 23 Apr 2013 16:34:17 +0200
Message-ID: <1983314.2qby4ZxK48@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1366724239-24734-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1366724239-24734-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 23, 2013 04:37:18 PM Andy Shevchenko wrote:
> There are couple of #if 0's to avoid debug printing. Let's remove them as
> Rafael suggested.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Both patches applied.

Thanks,
Rafael


> ---
>  drivers/pnp/isapnp/core.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
> index 918d5f0..cf88f9b6 100644
> --- a/drivers/pnp/isapnp/core.c
> +++ b/drivers/pnp/isapnp/core.c
> @@ -379,10 +379,6 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
>  		*type = (tag >> 3) & 0x0f;
>  		*size = tag & 0x07;
>  	}
> -#if 0
> -	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type,
> -	       *size);
> -#endif
>  	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
>  		return -1;
>  	return 0;
> @@ -813,13 +809,6 @@ static int __init isapnp_build_device_list(void)
>  		if (!card)
>  			continue;
>  
> -#if 0
> -		dev_info(&card->dev,
> -		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
> -		       header[0], header[1], header[2], header[3], header[4],
> -		       header[5], header[6], header[7], header[8]);
> -		dev_info(&card->dev, "checksum = %#x\n", checksum);
> -#endif
>  		INIT_LIST_HEAD(&card->devices);
>  		card->serial =
>  		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966193Ab3E2Nhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:37:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966078Ab3E2Nhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:37:37 -0400
Date: Wed, 29 May 2013 15:37:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pktcdvd: silence static checker warning
In-Reply-To: <20130516081108.GC7494@elgon.mountain>
Message-ID: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz>
References: <20130516081108.GC7494@elgon.mountain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013, Dan Carpenter wrote:

> Static checkers complain about widening the binary "not" operations here
> because sectors are u64 and "(pd)->settings.size" is unsigned int.
> It unintentionally clears the high 32 bits of the sector.  This means
> that the driver won't work for devices with over 2TB of space.  Since
> this is a DVD drive, we're unlikely to reach that limit, but we may as
> well silence the warning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 898fa74..09142c4 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -83,7 +83,8 @@
>  
>  #define MAX_SPEED 0xffff
>  
> -#define ZONE(sector, pd) (((sector) + (pd)->offset) & ~((pd)->settings.size - 1))
> +#define ZONE(sector, pd) (((sector) + (pd)->offset) & \
> +			~(sector_t)((pd)->settings.size - 1))
>  
>  static DEFINE_MUTEX(pktcdvd_mutex);
>  static struct pktcdvd_device *pkt_devs[MAX_WRITERS];

Makes sense. Applied, thanks Dan.

-- 
Jiri Kosina
SUSE Labs

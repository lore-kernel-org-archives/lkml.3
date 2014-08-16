Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaHPLhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 07:37:23 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:56039 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaHPLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 07:37:21 -0400
Date: Sat, 16 Aug 2014 07:37:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: propagate return value of scc_wait_after_reset
Message-ID: <20140816113718.GA9305@htj.dyndns.org>
References: <1408184238-1733-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408184238-1733-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 16, 2014 at 03:47:17PM +0530, Arjun Sreedharan wrote:
> scc_bus_softreset not necessarily should return zero.
> Propagate the error code.
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/ata/pata_scc.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
> index 4e006d7..5618c4518 100644
> --- a/drivers/ata/pata_scc.c
> +++ b/drivers/ata/pata_scc.c
> @@ -585,7 +585,7 @@ static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
>   *	Note: Original code is ata_bus_softreset().
>   */
>  
> -static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
> +static int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
>                                        unsigned long deadline)
>  {
>  	struct ata_ioports *ioaddr = &ap->ioaddr;
> @@ -599,9 +599,7 @@ static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,

scc_bus_softreset() should return int too, right?

>  	udelay(20);
>  	out_be32(ioaddr->ctl_addr, ap->ctl);
>  
> -	scc_wait_after_reset(&ap->link, devmask, deadline);
> -
> -	return 0;
> +	return scc_wait_after_reset(&ap->link, devmask, deadline);
>  }
>  
>  /**
> @@ -618,7 +616,8 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
>  {
>  	struct ata_port *ap = link->ap;
>  	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
> -	unsigned int devmask = 0, err_mask;
> +	unsigned int devmask = 0;
> +	int err_mask;

@rc or @ret would be a better name for it.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095Ab3CHSnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:43:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575Ab3CHSnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:43:05 -0500
Date: Fri, 8 Mar 2013 13:43:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xen-blkback: Change statistics counter types to
 unsigned
Message-ID: <20130308184301.GA31104@phenom.dumpdata.com>
References: <1362506372-19079-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362506372-19079-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 05:59:32PM +0000, Zoltan Kiss wrote:
> These values shouldn't be negative, but after an overflow their value
> can turn into negative, if they are signed. xentop can show bogus
> values in this case.

I get this during compilation:

/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_oo_req’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:233: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_rd_req’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:234: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_wr_req’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:235: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_f_req’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:236: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_ds_req’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:237: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_rd_sect’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:238: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_wr_sect’:
/home/konrad/linux/drivers/block/xen-blkback/xenbus.c:239: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
  CC      block/bsg-lib.o
  CC      mm/dmapool.o
  CC      kernel/debug/debug_core.o
  CC      mm/hugetlb.o
  CC      mm/mempolicy.o
  CC      drivers/acpi/sleep.o
/home/konrad/linux/drivers/block/xen-blkback/blkback.c: In function ‘print_stats’:
/home/konrad/linux/drivers/block/xen-blkback/blkback.c:384: warning: format ‘%3d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/blkback.c:384: warning: format ‘%4d’ expects type ‘int’, but argument 4 has type ‘long long unsigned int’
/home/konrad/linux/drivers/block/xen-blkback/blkback.c:384: warning: format ‘%4d’ expects type ‘int’, but argument 5 has type ‘lo

Could you fix it up please as one big patch if possible?

> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Reported-by: Ichiro Ogino <ichiro.ogino@citrix.co.jp>
> ---
>  drivers/block/xen-blkback/common.h |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 6072390..72d09ac 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -208,13 +208,13 @@ struct xen_blkif {
>  
>  	/* statistics */
>  	unsigned long		st_print;
> -	int			st_rd_req;
> -	int			st_wr_req;
> -	int			st_oo_req;
> -	int			st_f_req;
> -	int			st_ds_req;
> -	int			st_rd_sect;
> -	int			st_wr_sect;
> +	unsigned long long			st_rd_req;
> +	unsigned long long			st_wr_req;
> +	unsigned long long			st_oo_req;
> +	unsigned long long			st_f_req;
> +	unsigned long long			st_ds_req;
> +	unsigned long long			st_rd_sect;
> +	unsigned long long			st_wr_sect;
>  
>  	wait_queue_head_t	waiting_to_free;
>  };
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

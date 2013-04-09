Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936526Ab3DIOrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:47:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40340 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936365Ab3DIOrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:47:48 -0400
Date: Tue, 9 Apr 2013 10:47:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH v1 1/7] xen-blkback: print stats about persistent grants
Message-ID: <20130409144741.GB3158@phenom.dumpdata.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-2-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1364382643-3711-2-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:10:37PM +0100, Roger Pau Monne wrote:
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Looks good.
> ---
>  drivers/block/xen-blkback/blkback.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index dd5b2fe..f7526db 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -382,10 +382,12 @@ irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
>  static void print_stats(struct xen_blkif *blkif)
>  {
>  	pr_info("xen-blkback (%s): oo %3llu  |  rd %4llu  |  wr %4llu  |  f %4llu"
> -		 "  |  ds %4llu\n",
> +		 "  |  ds %4llu | pg: %4u/%4u\n",
>  		 current->comm, blkif->st_oo_req,
>  		 blkif->st_rd_req, blkif->st_wr_req,
> -		 blkif->st_f_req, blkif->st_ds_req);
> +		 blkif->st_f_req, blkif->st_ds_req,
> +		 blkif->persistent_gnt_c,
> +		 max_mapped_grant_pages(blkif->blk_protocol));
>  	blkif->st_print = jiffies + msecs_to_jiffies(10 * 1000);
>  	blkif->st_rd_req = 0;
>  	blkif->st_wr_req = 0;
> -- 
> 1.7.7.5 (Apple Git-26)
> 

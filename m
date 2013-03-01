Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab3CANnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:43:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16953 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CANnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:43:41 -0500
Date: Fri, 1 Mar 2013 08:43:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Jan Beulich <JBeulich@suse.com>, roger.pau@citrix.com,
        stefano.stabellini@eu.citrix.com, dgdegra@tycho.nsa.gov,
        xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used without
 initialized
Message-ID: <20130301134316.GA3733@phenom.dumpdata.com>
References: <512EC22F.5020404@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512EC22F.5020404@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:34:23AM +0800, Chen Gang wrote:
> 
>   if call xen_vbd_translate failed, the preq.dev will be not initialized.
>   so use blkif->vbd.pdevice instead (still better to print relative info).
> 
> additional information:
>   before commit 01c681d4c70d64cb72142a2823f27c4146a02e63, the value printed
>   here was bogus, as it was the guest provided value from req->u.rw.handle
>   rather than the actual device.

applied with some changes to the description.

> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Acked-by: Jan Beulich <JBeulich@suse.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index de1f319..6d1cc3d 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -904,7 +904,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  		pr_debug(DRV_PFX "access denied: %s of [%llu,%llu] on dev=%04x\n",
>  			 operation == READ ? "read" : "write",
>  			 preq.sector_number,
> -			 preq.sector_number + preq.nr_sects, preq.dev);
> +			 preq.sector_number + preq.nr_sects,
> +			 blkif->vbd.pdevice);
>  		goto fail_response;
>  	}
>  
> -- 
> 1.7.7.6

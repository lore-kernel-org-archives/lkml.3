Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3B0Jt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:49:27 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:57446 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3B0Jt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:49:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,746,1355097600"; 
   d="scan'208";a="1943243"
Message-ID: <512DD6DA.5010706@citrix.com>
Date: Wed, 27 Feb 2013 10:50:18 +0100
From: =?GB2312?B?Um9nZXIgUGF1IE1vbm6opg==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "dgdegra@tycho.nsa.gov" <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used without initialized
References: <512D90F2.9070200@asianux.com>
In-Reply-To: <512D90F2.9070200@asianux.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/13 05:52, Chen Gang wrote:
> 
>   if call xen_vbd_translate failed, the preq.dev will be not initialized.
>   so use blkif->vbd.pdevice instead (still better to print relative info).

preq.dev is initialized a a couple of lines prior to calling
xen_vbd_translate:

preq.dev           = req->u.rw.handle;

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
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
> 


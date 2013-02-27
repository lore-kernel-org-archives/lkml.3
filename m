Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3B0J6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:58:01 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43128 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3B0J56 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 27 Feb 2013 04:57:58 -0500
Message-Id: <512DE6B302000078000C1631@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 27 Feb 2013 09:57:55 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Chen Gang" <gang.chen@asianux.com>
Cc: <roger.pau@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used
 without initialized
References: <512D90F2.9070200@asianux.com>
In-Reply-To: <512D90F2.9070200@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.02.13 at 05:52, Chen Gang <gang.chen@asianux.com> wrote:
>   if call xen_vbd_translate failed, the preq.dev will be not initialized.
>   so use blkif->vbd.pdevice instead (still better to print relative info).

You also could have mentioned that even before commit 
01c681d4c70d64cb72142a2823f27c4146a02e63 the value printed
here was bogus, as it was the guest provided value from
req->u.rw.handle rather than the actual device.

Jan

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c 
> b/drivers/block/xen-blkback/blkback.c
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




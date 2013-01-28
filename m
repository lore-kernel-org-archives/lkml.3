Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3A1LJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:09:22 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:48045 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3A1LJT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 28 Jan 2013 06:09:19 -0500
Message-Id: <51066A6B02000078000BA034@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 28 Jan 2013 11:09:15 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/blkback: Don't trust the
 handle from the frontend.
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1359135152-30688-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.01.13 at 18:32, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> The 'handle' is the device that the request is from. For the life-time
> of the ring we copy it from a request to a response so that the frontend
> is not surprised by it. But we do not need it - when we start processing
> I/Os we have our own 'struct phys_req' which has only most essential
> information about the request. In fact the 'vbd_translate' ends up
> over-writing the preq.dev with a value from the backend.
> 
> This assignment of preq.dev with the 'handle' value is superfluous
> so lets not do it.
> 
> Cc: stable@vger.kernel.org 

Is this really stable material? It fixes nothing but the (wrong)
impression that the driver might be using frontend provided data
without checking.

Jan

> Acked-by: Jan Beulich <jbeulich@suse.com>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c 
> b/drivers/block/xen-blkback/blkback.c
> index 742871d..2de3da9 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -890,7 +890,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  		goto fail_response;
>  	}
>  
> -	preq.dev           = req->u.rw.handle;
>  	preq.sector_number = req->u.rw.sector_number;
>  	preq.nr_sects      = 0;
>  
> -- 
> 1.8.0.2
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 




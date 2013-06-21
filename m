Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707Ab3FULuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:50:03 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38976 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965568Ab3FULuB (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 21 Jun 2013 07:50:01 -0400
Message-Id: <51C45A0602000078000DFA4C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 21 Jun 2013 12:49:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/4] xen-blkfront: increase the default
 number of indirect segments
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
 <1371812216-17093-5-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1371812216-17093-5-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.06.13 at 12:56, Roger Pau Monne <roger.pau@citrix.com> wrote:
> When using certain storage devices (like RAID) having a bigger number
> of segments per request provides better performance.

And there's no drawback (higher memory foot print if nothing else)
on "certain other storage devices"? Adjusting defaults just because
it is beneficial for some devices, but may adversely affect others
is not really a good thing - in such an event, you'd be better off
determining the default dynamically per device.

Jan

> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Reported-by: Steven Haigh <netwiz@crc.id.au>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkfront.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2e1ee34..4e3ab34 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -94,9 +94,9 @@ static const struct block_device_operations xlvbd_block_fops;
>   * by the backend driver.
>   */
>  
> -static unsigned int xen_blkif_max_segments = 32;
> +static unsigned int xen_blkif_max_segments = 64;
>  module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
> -MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests 
> (default is 32)");
> +MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests 
> (default is 64)");
>  
>  #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
>  
> -- 
> 1.7.7.5 (Apple Git-26)
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



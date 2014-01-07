Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaAGLVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:21:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24189 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaAGLVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:21:16 -0500
Message-ID: <52CBE321.4050906@oracle.com>
Date: Tue, 07 Jan 2014 19:21:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>, dchinner@fromorbit.com,
        bpm@sgi.com
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
 INIT_WORK_ONSTACK()
References: <1389084605.3650.66.camel@cliu38-desktop-build> <1389084814.3650.70.camel@cliu38-desktop-build>
In-Reply-To: <1389084814.3650.70.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuansheng,

On 01/07 2014 16:53 PM, Chuansheng Liu wrote:
> 
> In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> call destroy_work_on_stack() which frees the debug object to pair
> with INIT_WORK_ONSTACK().
> 
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> ---
>  fs/xfs/xfs_bmap_util.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 1394106..82e0dab 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -287,6 +287,7 @@ xfs_bmapi_allocate(
>  	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
>  	queue_work(xfs_alloc_wq, &args->work);
>  	wait_for_completion(&done);
> +	destroy_work_on_stack(&args->work);
>  	return args->result;
>  }

Thanks for your patch and it work fine for my testing.  I missed this in an
old commit: [ 3b876c8f2a xfs: fix debug_object WARN at xfs_alloc_vextent() ] 

Just out of curious, do you notice memory leaks or other hints which help you
finding out this problem?   

Thanks,
-Jeff

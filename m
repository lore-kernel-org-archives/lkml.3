Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3G3OKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:10:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab3G3OKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:10:47 -0400
Subject: Re: [PATCH 6/9] gfs2: WQ_NON_REENTRANT is meaningless and going
 away
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, shli@kernel.org,
        cluster-devel@redhat.com
In-Reply-To: <1375188028-11910-7-git-send-email-tj@kernel.org>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
	 <1375188028-11910-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 30 Jul 2013 15:10:18 +0100
Message-ID: <1375193418.2725.25.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-07-30 at 08:40 -0400, Tejun Heo wrote:
> Hello,
> 
> Please route this through the subsystem tree.  As written in the
> description, this shouldn't make any functional difference and just
> prepares for the removal of WQ_NON_REENTRANT which is already noop.
> 
> Thanks.
> 
Now in the GFS2 -nmw tree. Thanks,

Steve.

> ------ 8< -------
> dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
> WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>  fs/gfs2/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
> index e04d0e0..7b0f504 100644
> --- a/fs/gfs2/main.c
> +++ b/fs/gfs2/main.c
> @@ -155,7 +155,7 @@ static int __init init_gfs2_fs(void)
>  		goto fail_wq;
>  
>  	gfs2_control_wq = alloc_workqueue("gfs2_control",
> -			       WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE, 0);
> +					  WQ_UNBOUND | WQ_FREEZABLE, 0);
>  	if (!gfs2_control_wq)
>  		goto fail_recovery;
>  



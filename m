Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaBKRur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:50:47 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46360 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:50:46 -0500
Date: Tue, 11 Feb 2014 12:50:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 8/9] workqueue: Replace hardcoding of -20 and 19 with
 MIN_NICE and MAX_NICE.
Message-ID: <20140211175041.GH24490@htj.dyndns.org>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <6d85138180c00ce86975addab6e34b24b84f00a5.1392103744.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d85138180c00ce86975addab6e34b24b84f00a5.1392103744.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:34:52PM +0800, Dongsheng Yang wrote:
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Tejun Heo <tj@kernel.org>
> cc: Peter Zijlstra <peterz@infradead.org>
> cc: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/workqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 82ef9f3..e4f5905 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3218,7 +3218,7 @@ static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
>  		return -ENOMEM;
>  
>  	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
> -	    attrs->nice >= -20 && attrs->nice <= 19)
> +	    attrs->nice >= MIN_NICE && attrs->nice <= MAX_NICE)

No objection.  If this gets accepted, it will be routed through -tip,
I suppose?  Please feel free to add

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

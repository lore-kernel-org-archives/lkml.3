Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3KOEu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:50:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3KOEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:50:51 -0500
Message-ID: <5285A7FF.1000901@oracle.com>
Date: Fri, 15 Nov 2013 12:50:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: shaggy@kernel.org
CC: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us,
        gregkh@linuxfoundation.org, oleg@redhat.com,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com,
        linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] jfs: simplify lmLogSync() via list_last_entry_or_null()
References: <5285A483.3040009@oracle.com>
In-Reply-To: <5285A483.3040009@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave and all,

Please ignore this patch from this series.

On 11/15 2013 12:35 PM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Simplify the code in lmLogSync() via list_last_entry_or_null().
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/jfs/jfs_logmgr.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 7b565d0..2f90779 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -963,13 +963,9 @@ static int lmLogSync(struct jfs_log * log, int hard_sync)
>  
>  	if (log->sync == log->syncpt) {
>  		LOGSYNC_LOCK(log, flags);
> -		if (list_empty(&log->synclist))
> -			log->sync = log->lsn;
> -		else {
> -			lp = list_entry(log->synclist.next,
> -					struct logsyncblk, synclist);
> -			log->sync = lp->lsn;
> -		}
> +		lp = list_last_entry_or_null(&log->synclist, struct logsyncblk,
> +					     synclist);
Here it could be simplified via list_first_entry_or_null(), my apology for this mistake.
> +		log->sync = lp ? lp->lsn : log->lsn;
>  		LOGSYNC_UNLOCK(log, flags);
>  
>  	}
> 

Thanks,
-Jeff

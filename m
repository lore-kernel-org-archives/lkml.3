Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaDWFF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:05:56 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50296 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaDWFFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:05:53 -0400
Message-ID: <53574888.4090602@gmail.com>
Date: Wed, 23 Apr 2014 06:58:48 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: mtk.manpages@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] ipc/shm.c: check for overflows of shm_tot
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com> <1398090397-2397-2-git-send-email-manfred@colorfullife.com> <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 04:26 PM, Manfred Spraul wrote:
> shm_tot counts the total number of pages used by shm segments.
> 
> If SHMALL is ULONG_MAX (or nearly ULONG_MAX), then the number
> can overflow.  Subsequent calls to shmctl(,SHM_INFO,) would return
> wrong values for shm_tot.
> 
> The patch adds a detection for overflows.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/shm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 382e2fb..2dfa3d6 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -493,7 +493,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  	if (size < SHMMIN || size > ns->shm_ctlmax)
>  		return -EINVAL;
>  
> -	if (ns->shm_tot + numpages > ns->shm_ctlall)
> +	if (ns->shm_tot + numpages < ns->shm_tot ||
> +			ns->shm_tot + numpages > ns->shm_ctlall)
>  		return -ENOSPC;
>  
>  	shp = ipc_rcu_alloc(sizeof(*shp));
> 

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

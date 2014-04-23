Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaDWFG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:06:28 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41071 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaDWFF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:05:56 -0400
Message-ID: <535748AD.9000804@gmail.com>
Date: Wed, 23 Apr 2014 06:59:25 +0200
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
Subject: Re: [PATCH 3/4] ipc/shm.c: check for integer overflow during shmget.
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com> <1398090397-2397-2-git-send-email-manfred@colorfullife.com> <1398090397-2397-3-git-send-email-manfred@colorfullife.com> <1398090397-2397-4-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1398090397-2397-4-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 04:26 PM, Manfred Spraul wrote:
> SHMMAX is the upper limit for the size of a shared memory segment,
> counted in bytes. The actual allocation is that size, rounded up to
> the next full page.
> Add a check that prevents the creation of segments where the
> rounded up size causes an integer overflow.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/shm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 2dfa3d6..f000696 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -493,6 +493,9 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  	if (size < SHMMIN || size > ns->shm_ctlmax)
>  		return -EINVAL;
>  
> +	if (numpages << PAGE_SHIFT < size)
> +		return -ENOSPC;
> +
>  	if (ns->shm_tot + numpages < ns->shm_tot ||
>  			ns->shm_tot + numpages > ns->shm_ctlall)
>  		return -ENOSPC;
> 

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538AbaLECGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:06:33 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:46501 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933503AbaLECGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:06:32 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44534256"
Message-ID: <5481140F.60607@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 10:10:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wq/for-3.19] workqueue: cosmetic update in rescuer_thread()
References: <20141204151413.GF15219@htj.dyndns.org>
In-Reply-To: <20141204151413.GF15219@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 11:14 PM, Tejun Heo wrote:
> rescuer_thread() caches &rescuer->scheduled in a local variable
> scheduled for convenience.  There's one WARN_ON_ONCE() which was using
> &rescuer->scheduled directly.  Replace it with the local variable.
> 
> This patch causes no functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>


> Applying to wq/for-3.19.
> 
> Thanks.
> 
>  kernel/workqueue.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2246,7 +2246,7 @@ repeat:
>  		 * Slurp in all works issued via this workqueue and
>  		 * process'em.
>  		 */
> -		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> +		WARN_ON_ONCE(!list_empty(scheduled));
>  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
>  			if (get_work_pwq(work) == pwq)
>  				move_linked_works(work, scheduled, &n);
> 


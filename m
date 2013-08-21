Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3HUUzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:55:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38243 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3HUUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:55:49 -0400
Message-ID: <52152948.6080302@infradead.org>
Date: Wed, 21 Aug 2013 13:55:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: tj@kernel.org, linux-kernel@vger.kernel.org, wangyijing@huawei.com,
        guohanjun@huawei.com
Subject: Re: [PATCH v2 3/3] workqueue: Correct/Drop references to gcwq in
 Documentation
References: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com> <1377046241-18516-4-git-send-email-huawei.libin@huawei.com>
In-Reply-To: <1377046241-18516-4-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/13 17:50, Libin wrote:
> No functional changes. This patch fixes the post gcwq comments in
> Documentation/workqueue.txt.
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>
> ---
>  Documentation/workqueue.txt | 72 ++++++++++++++++++++++-----------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
> index a6ab4b6..5e65b1c 100644
> --- a/Documentation/workqueue.txt
> +++ b/Documentation/workqueue.txt
> @@ -85,16 +85,16 @@ workqueue.
>  Special purpose threads, called worker threads, execute the functions
>  off of the queue, one after the other.  If no work is queued, the
>  worker threads become idle.  These worker threads are managed in so
> -called thread-pools.
> +called worker-pools.
>  
>  The cmwq design differentiates between the user-facing workqueues that
>  subsystems and drivers queue work items on and the backend mechanism
> -which manages thread-pools and processes the queued work items.
> +which manages worker-pools and processes the queued work items.
>  
> -The backend is called gcwq.  There is one gcwq for each possible CPU
> -and one gcwq to serve work items queued on unbound workqueues.  Each
> -gcwq has two thread-pools - one for normal work items and the other
> -for high priority ones.
> +There are two worker-pools, one for normal work items and the other
> +for high priority ones, for each possible CPU and some extra worker-pools
> +to serve work items queued on unbound workqueues - the number of these
> +baking pools is dynamic.

   backing ?

>  
>  Subsystems and drivers can create and queue work items through special
>  workqueue API functions as they see fit. They can influence some



-- 
~Randy

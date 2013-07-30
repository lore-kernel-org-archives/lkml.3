Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3G3Nwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:52:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55251 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3G3Nwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:52:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 30 Jul 2013 15:52:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, shli@kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/9] firewire: WQ_NON_REENTRANT is meaningless and going
 away
Message-ID: <20130730155217.4e5bcbf0@stein>
In-Reply-To: <1375188028-11910-5-git-send-email-tj@kernel.org>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
	<1375188028-11910-5-git-send-email-tj@kernel.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 30 Tejun Heo wrote:
> Please route this through the subsystem tree.  As written in the
> description, this shouldn't make any functional difference and just
> prepares for the removal of WQ_NON_REENTRANT which is already noop.

Committed to linux1394.git and pushed out to the for-next branch.

> ------ 8< -------
> dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
> WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: linux1394-devel@lists.sourceforge.net
> ---
>  drivers/firewire/core-transaction.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
> index 28a94c7..e5af0e3 100644
> --- a/drivers/firewire/core-transaction.c
> +++ b/drivers/firewire/core-transaction.c
> @@ -1262,8 +1262,7 @@ static int __init fw_core_init(void)
>  {
>  	int ret;
>  
> -	fw_workqueue = alloc_workqueue("firewire",
> -				       WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
> +	fw_workqueue = alloc_workqueue("firewire", WQ_MEM_RECLAIM, 0);
>  	if (!fw_workqueue)
>  		return -ENOMEM;
>  

-- 
Stefan Richter
-=====-===-= -=== ====-
http://arcgraph.de/sr/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbaGRGyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:54:49 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65230 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbaGRGyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:54:47 -0400
Date: Fri, 18 Jul 2014 08:54:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, writeback: prevent race when calculating dirty limits
Message-ID: <20140718065444.GA21453@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1407161733200.23892@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407161733200.23892@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-07-14 17:36:49, David Rientjes wrote:
> Setting vm_dirty_bytes and dirty_background_bytes is not protected by any 
> serialization.
> 
> Therefore, it's possible for either variable to change value after the 
> test in global_dirty_limits() to determine whether available_memory needs 
> to be initialized or not.
> 
> Always ensure that available_memory is properly initialized.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: David Rientjes <rientjes@google.com>

Makes sense to me
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/page-writeback.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -261,14 +261,11 @@ static unsigned long global_dirtyable_memory(void)
>   */
>  void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
>  {
> +	const unsigned long available_memory = global_dirtyable_memory();
>  	unsigned long background;
>  	unsigned long dirty;
> -	unsigned long uninitialized_var(available_memory);
>  	struct task_struct *tsk;
>  
> -	if (!vm_dirty_bytes || !dirty_background_bytes)
> -		available_memory = global_dirtyable_memory();
> -
>  	if (vm_dirty_bytes)
>  		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
>  	else

-- 
Michal Hocko
SUSE Labs

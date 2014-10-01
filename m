Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaJAP4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:56:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52774 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaJAP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:56:38 -0400
Date: Wed, 1 Oct 2014 17:56:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH] mm: memcontrol Use #include <linux/uaccess.h>
Message-ID: <20141001155634.GB4405@dhcp22.suse.cz>
References: <1412178296-2972-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412178296-2972-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01-10-14 16:44:56, Paul McQuade wrote:
> Remove asm headers for linux headers

I think we do not need this header at all these days. There are no
direct operations on user memory in memcontrol.c.

> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 085dc6d..51dbe80 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -56,14 +56,14 @@
>  #include <linux/oom.h>
>  #include <linux/lockdep.h>
>  #include <linux/file.h>
> +#include <linux/uaccess.h>
> +
>  #include "internal.h"
>  #include <net/sock.h>
>  #include <net/ip.h>
>  #include <net/tcp_memcontrol.h>
>  #include "slab.h"
>  
> -#include <asm/uaccess.h>
> -
>  #include <trace/events/vmscan.h>
>  
>  struct cgroup_subsys memory_cgrp_subsys __read_mostly;
> -- 
> 1.9.1
> 

-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3FMROY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:14:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3FMROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:14:23 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=qHpfW7Yi68YA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=KGjhK52YXX0A:10 a=tOFwZ_onhCkA:10 a=pGLkceISAAAA:8 a=DfNHnWVPAAAA:8 a=BoIRH91AkcvU4gYo5kUA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=lBRciGGoxdUA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Thu, 13 Jun 2013 07:40:36 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/pid.c: Moving statement.
Message-ID: <20130613124036.GB28706@austin.hallyn.com>
References: <1370901160-3156-1-git-send-email-raphael.scarv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370901160-3156-1-git-send-email-raphael.scarv@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Raphael S. Carvalho (raphael.scarv@gmail.com):
> Moving statement to static initilization of init_pid_ns.
> 
> Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>

This seems innocuous enough.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/pid.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 0db3e79..c577d3c 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -75,6 +75,7 @@ struct pid_namespace init_pid_ns = {
>  		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
>  	},
>  	.last_pid = 0,
> +	.nr_hashed = PIDNS_HASH_ADDING,
>  	.level = 0,
>  	.child_reaper = &init_task,
>  	.user_ns = &init_user_ns,
> @@ -594,7 +595,6 @@ void __init pidmap_init(void)
>  	/* Reserve PID 0. We never call free_pidmap(0) */
>  	set_bit(0, init_pid_ns.pidmap[0].page);
>  	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
> -	init_pid_ns.nr_hashed = PIDNS_HASH_ADDING;
>  
>  	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
>  			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
> -- 
> 1.7.2.5

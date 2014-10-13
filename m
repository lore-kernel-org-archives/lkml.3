Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaJMNO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:14:58 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:40593
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaJMNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:14:56 -0400
Date: Mon, 13 Oct 2014 15:14:54 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        sgrubb@redhat.com, aviro@redhat.com, pmoore@redhat.com,
        arozansk@redhat.com, ebiederm@xmission.com, serge@hallyn.com
Subject: Re: [PATCH V5 09/13] fork: audit on creation of new namespace(s)
Message-ID: <20141013131454.GG24703@mail.hallyn.com>
References: <cover.1412543112.git.rgb@redhat.com>
 <b9607ab778a84381b4a82cf0110d031f19b17525.1412543112.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9607ab778a84381b4a82cf0110d031f19b17525.1412543112.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):
> When clone(2) is called to fork a new process creating one or more namespaces,
> audit the event to tie the new pid with the namespace IDs.
> 
> Signed-off-by: Richard Guy Briggs

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/fork.c    |    3 +++
>  kernel/nsproxy.c |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 6a13c46..a7fe4d5 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1624,6 +1624,9 @@ long do_fork(unsigned long clone_flags,
>  			get_task_struct(p);
>  		}
>  
> +		if (unlikely(clone_flags & CLONE_NEW_MASK)) {
> +			audit_log_ns_info(p);
> +		}
>  		wake_up_new_task(p);
>  
>  		/* forking complete and child started to run, tell ptracer */
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 0c2f25e..2cdc16b 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -25,6 +25,7 @@
>  #include <linux/proc_ns.h>
>  #include <linux/file.h>
>  #include <linux/syscalls.h>
> +#include <linux/audit.h>
>  
>  static struct kmem_cache *nsproxy_cachep;
>  
> -- 
> 1.7.1

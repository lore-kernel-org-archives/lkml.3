Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaBUWsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:48:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaBUWsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:48:15 -0500
Date: Fri, 21 Feb 2014 16:48:10 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Joe Perches <joe@perches.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] capability: Use current logging styles
Message-ID: <20140221224810.GA24302@sergelap>
References: <1393021170.2594.24.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393021170.2594.24.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joe Perches (joe@perches.com):
> Prefix logging output with "capability: " via pr_fmt.
> Convert printks to pr_<level>.
> Use pr_<level>_once instead of guard flags.
> Coalesce formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  kernel/capability.c | 29 ++++++++++-------------------
>  1 file changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 34019c5..a8d63df 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -7,6 +7,8 @@
>   * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/audit.h>
>  #include <linux/capability.h>
>  #include <linux/mm.h>
> @@ -42,15 +44,10 @@ __setup("no_file_caps", file_caps_disable);
>  
>  static void warn_legacy_capability_use(void)
>  {
> -	static int warned;
> -	if (!warned) {
> -		char name[sizeof(current->comm)];
> -
> -		printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
> -		       " (legacy support in use)\n",
> -		       get_task_comm(name, current));
> -		warned = 1;
> -	}
> +	char name[sizeof(current->comm)];
> +
> +	pr_info_once("warning: `%s' uses 32-bit capabilities (legacy support in use)\n",
> +		     get_task_comm(name, current));
>  }
>  
>  /*
> @@ -71,16 +68,10 @@ static void warn_legacy_capability_use(void)
>  
>  static void warn_deprecated_v2(void)
>  {
> -	static int warned;
> +	char name[sizeof(current->comm)];
>  
> -	if (!warned) {
> -		char name[sizeof(current->comm)];
> -
> -		printk(KERN_INFO "warning: `%s' uses deprecated v2"
> -		       " capabilities in a way that may be insecure.\n",
> -		       get_task_comm(name, current));
> -		warned = 1;
> -	}
> +	pr_info_once("warning: `%s' uses deprecated v2 capabilities in a way that may be insecure\n",
> +		     get_task_comm(name, current));
>  }
>  
>  /*
> @@ -380,7 +371,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
>  bool ns_capable(struct user_namespace *ns, int cap)
>  {
>  	if (unlikely(!cap_valid(cap))) {
> -		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
> +		pr_crit("capable() called with invalid cap=%u\n", cap);
>  		BUG();
>  	}
>  
> 
> 

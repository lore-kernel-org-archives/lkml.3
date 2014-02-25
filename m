Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaBYUFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:05:47 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:49936 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaBYUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:05:44 -0500
From: Paul Moore <paul@paul-moore.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 5/8] security: selinux: Use a more current logging style
Date: Tue, 25 Feb 2014 15:05:41 -0500
Message-ID: <2895078.vC4M4VjvUd@sifl>
User-Agent: KMail/4.12.2 (Linux/3.12.9-gentoo; KDE/4.12.2; x86_64; ; )
In-Reply-To: <637b2f31e31f2b0d7a67131f1db125cc0b2bb829.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com> <637b2f31e31f2b0d7a67131f1db125cc0b2bb829.1393279025.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 24, 2014 01:59:58 PM Joe Perches wrote:
> Convert printk to pr_<level>.
> Add pr_fmt.
> Coalesce formats, add missing space where appropriate.
> Standardize on one space after "SELinux: " prefix.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

A few minor comments inline ...

> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index fc3e662..f9bb683 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -13,6 +13,9 @@
>   *	it under the terms of the GNU General Public License version 2,
>   *	as published by the Free Software Foundation.
>   */
> +
> +#define pr_fmt(fmt) "SELinux: " KBUILD_MODNAME ": " fmt
> +

Wouldn't this result in "SELinux: selinux: ..."?  If not great, if so, let's 
just specify "avc" the old fashioned way.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index d07413d..49a4a3d 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c

>  	/* Set the security state for the initial task. */
>  	cred_init_security();
> @@ -5976,9 +5958,9 @@ static __init int selinux_init(void)
>  		panic("SELinux: Unable to register with kernel.\n");
> 
>  	if (selinux_enforcing)
> -		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
> +		printk(KERN_DEBUG "SELinux: Starting in enforcing mode\n");
>  	else
> -		printk(KERN_DEBUG "SELinux:  Starting in permissive mode\n");
> +		printk(KERN_DEBUG "SELinux: Starting in permissive mode\n");
> 
>  	return 0;
>  }

What about using 'pr_fmt("...")' in the printks above?  Seems like it would 
help with consistency.

> @@ -5990,10 +5972,10 @@ static void delayed_superblock_init(struct
> super_block *sb, void *unused)
> 
>  void selinux_complete_init(void)
>  {
> -	printk(KERN_DEBUG "SELinux:  Completing initialization.\n");
> +	printk(KERN_DEBUG "SELinux: Completing initialization\n");
> 
>  	/* Set up any superblocks initialized prior to the policy load. */
> -	printk(KERN_DEBUG "SELinux:  Setting up existing superblocks.\n");
> +	printk(KERN_DEBUG "SELinux: Setting up existing superblocks\n");
>  	iterate_supers(delayed_superblock_init, NULL);
>  }

Same.

> @@ -6055,7 +6037,7 @@ static int __init selinux_nf_ip_init(void)
>  	if (!selinux_enabled)
>  		goto out;
> 
> -	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks\n");
> +	printk(KERN_DEBUG "SELinux: Registering netfilter hooks\n");
> 
>  	err = nf_register_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
>  	if (err)
> @@ -6076,7 +6058,7 @@ __initcall(selinux_nf_ip_init);
>  #ifdef CONFIG_SECURITY_SELINUX_DISABLE
>  static void selinux_nf_ip_exit(void)
>  {
> -	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks\n");
> +	printk(KERN_DEBUG "SELinux: Unregistering netfilter hooks\n");

Same.

> diff --git a/security/selinux/netport.c b/security/selinux/netport.c
> index d353797..20a4ed0 100644
> --- a/security/selinux/netport.c
> +++ b/security/selinux/netport.c
> @@ -12,7 +12,6 @@
>   *   (see security/selinux/netif.c for more information)
>   *
>   */
> -
>  /*
>   * (c) Copyright Hewlett-Packard Development Company, L.P., 2008
>   *

Whitespace noise.

> diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
> index c0f4988..ff9e193 100644
> --- a/security/selinux/ss/policydb.c
> +++ b/security/selinux/ss/policydb.c
> @@ -25,6 +25,8 @@
>   *	the Free Software Foundation, version 2.
>   */
> 
> +#define pr_fmt(fmt) "SELinux: " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -515,14 +517,14 @@ static int policydb_index(struct policydb *p)
>  {
>  	int i, rc;
> 
> -	printk(KERN_DEBUG "SELinux:  %d users, %d roles, %d types, %d bools",
> +	printk(KERN_DEBUG "SELinux: %d users, %d roles, %d types, %d bools",
>  	       p->p_users.nprim, p->p_roles.nprim, p->p_types.nprim,
> p->p_bools.nprim); if (p->mls_enabled)
>  		printk(", %d sens, %d cats", p->p_levels.nprim,
>  		       p->p_cats.nprim);
>  	printk("\n");
> 
> -	printk(KERN_DEBUG "SELinux:  %d classes, %d rules\n",
> +	printk(KERN_DEBUG "SELinux: %d classes, %d rules\n",
>  	       p->p_classes.nprim, p->te_avtab.nel);

More potential 'pr_fmt(x)' uses ...

-- 
paul moore
www.paul-moore.com


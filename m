Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3GJBto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:49:44 -0400
Received: from ozlabs.org ([203.10.76.45]:51025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab3GJBtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:49:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>, khali@linux-fr.org,
        David.Woodhouse@intel.com
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/params.c: print failure information instead of 'KOBJ_ADD' to user space, when sysfs_create_file() fails.
In-Reply-To: <51DB8597.4090101@asianux.com>
References: <51DB8597.4090101@asianux.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 09 Jul 2013 17:37:48 +0930
Message-ID: <87y59gcg17.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
> When sysfs_create_file() fails, recommend to print the related failure
> information. And it is useless to still 'KOBJ_ADD' to user space.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

sysfs_create_file() should not fail during boot, should it?

Cheers,
Rusty.

> ---
>  kernel/params.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/params.c b/kernel/params.c
> index 440e65d..f5299c1 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -845,7 +845,13 @@ static void __init version_sysfs_builtin(void)
>  		mk = locate_module_kobject(vattr->module_name);
>  		if (mk) {
>  			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
> -			kobject_uevent(&mk->kobj, KOBJ_ADD);
> +			if (err)
> +				printk(KERN_WARNING
> +				       "%s (%d): sysfs_create_file fail for %s, err: %d\n",
> +				       __FILE__, __LINE__,
> +				       vattr->module_name, err);
> +			else
> +				kobject_uevent(&mk->kobj, KOBJ_ADD);
>  			kobject_put(&mk->kobj);
>  		}
>  	}
> -- 
> 1.7.7.6

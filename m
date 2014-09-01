Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaIABb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:31:29 -0400
Received: from ozlabs.org ([103.22.144.67]:54575 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbaIABb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:31:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] moduleparam: Resolve missing-field-initializer warning
In-Reply-To: <1409317709-5005-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1409317709-5005-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Sep 2014 10:22:00 +0930
Message-ID: <87ha0skvrj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher <jeffrey.t.kirsher@intel.com> writes:
> From: Mark Rustad <mark.d.rustad@intel.com>
>
> Resolve a missing-field-initializer warning, that is produced
> by every reference to module_param_call, by using designated
> initialization for the first field. That is enough to silence
> the complaint.
>
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  include/linux/moduleparam.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Strange, I haven't seen this warning.  Compiler version?  And it's good
to quote the error message, so people can google it.

Cheers,
Rusty.

> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 494f99e..d99a9e9 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -196,7 +196,7 @@ struct kparam_array
>  /* Obsolete - use module_param_cb() */
>  #define module_param_call(name, set, get, arg, perm)			\
>  	static struct kernel_param_ops __param_ops_##name =		\
> -		{ 0, (void *)set, (void *)get };			\
> +		{ .flags = 0, (void *)set, (void *)get };		\
>  	__module_param_call(MODULE_PARAM_PREFIX,			\
>  			    name, &__param_ops_##name, arg,		\
>  			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
> -- 
> 1.9.3

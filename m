Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3BVN2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:28:02 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51353 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab3BVN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:27:59 -0500
Date: Fri, 22 Feb 2013 14:27:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: Re: [RFC/PATCH 1/5] context tracking: conditionalize guest support
 based on CONFIG_KVM
Message-ID: <20130222132750.GE17948@somewhere.redhat.com>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
 <1361389302-11968-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361389302-11968-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:41:38AM -0800, Kevin Hilman wrote:
> So that it can build on !KVM systems too.
> 
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/context_tracking.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 74f68f4..6fe96b1 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -1,5 +1,7 @@
>  #include <linux/context_tracking.h>
> +#ifdef CONFIG_KVM
>  #include <linux/kvm_host.h>
> +#endif

The header should take care of the off-case, no need to ifdef its inclusion.

>  #include <linux/rcupdate.h>
>  #include <linux/sched.h>
>  #include <linux/hardirq.h>
> @@ -62,6 +64,7 @@ void user_exit(void)
>  	local_irq_restore(flags);
>  }
>  
> +#ifdef CONFIG_KVM
>  void guest_enter(void)
>  {
>  	if (vtime_accounting_enabled())
> @@ -79,6 +82,7 @@ void guest_exit(void)
>  		__guest_exit();
>  }
>  EXPORT_SYMBOL_GPL(guest_exit);
> +#endif

Kvm might be built as a module so we can't actually do this unfortunately.

Thanks.

>  
>  void context_tracking_task_switch(struct task_struct *prev,
>  			     struct task_struct *next)
> -- 
> 1.8.1.2
> 

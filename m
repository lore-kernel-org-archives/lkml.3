Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3JSQte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3JSQtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:49:33 -0400
Date: Sat, 19 Oct 2013 18:42:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/13] uprobes: allow arch-specific initialization
Message-ID: <20131019164223.GB7837@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-5-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381871068-27660-5-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, David Long wrote:
>
> Add a weak function for any architecture-specific initialization.  ARM
> will use this to register the handlers for the undefined instructions it
> uses to implement uprobes.

Could you explain why ARM can't simply do the necessary initialization in
arch/arm/kernel/uprobes-arm.c ?


> +int __weak __init arch_uprobes_init(void)
> +{
> +	return 0;
> +}
> +
>  static int __init init_uprobes(void)
>  {
> +	int ret;
>  	int i;
>  
>  	for (i = 0; i < UPROBES_HASH_SZ; i++)
> @@ -1870,6 +1876,10 @@ static int __init init_uprobes(void)
>  	if (percpu_init_rwsem(&dup_mmap_sem))
>  		return -ENOMEM;
>  
> +	ret = arch_uprobes_init();
> +	if (ret)
> +		return ret;
> +
>  	return register_die_notifier(&uprobe_exception_nb);
>  }
>  module_init(init_uprobes);

IOW, why do we need to call arch_uprobes_init() from init_uprobes().

Oleg.


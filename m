Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbaEOVPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:15:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaEOVPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:15:32 -0400
From: Paul Moore <pmoore@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, sds@tycho.nsa.gov,
        eparis@redhat.com
Subject: Re: [2/2] conditionally reschedule in hashtab_insert while loading selinux policy.
Date: Thu, 15 May 2014 17:15:29 -0400
Message-ID: <3386355.fA7X58KLEY@sifl>
Organization: Red Hat
User-Agent: KMail/4.13 (Linux/3.14.1-gentoo; KDE/4.13.0; x86_64; ; )
In-Reply-To: <20140515190353.GB16816@redhat.com>
References: <20140515190353.GB16816@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2014 03:03:53 PM Dave Jones wrote:
> After silencing the sleeping warning in mls_convert_context() I started
> seeing similar traces from hashtab_insert. Do a cond_resched there too.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Merged to the SELinux #next branch, thanks.

> diff --git a/security/selinux/ss/hashtab.c b/security/selinux/ss/hashtab.c
> index 933e735bb185..2cc496149842 100644
> --- a/security/selinux/ss/hashtab.c
> +++ b/security/selinux/ss/hashtab.c
> @@ -6,6 +6,7 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/errno.h>
> +#include <linux/sched.h>
>  #include "hashtab.h"
> 
>  struct hashtab *hashtab_create(u32 (*hash_value)(struct hashtab *h, const
> void *key), @@ -40,6 +41,8 @@ int hashtab_insert(struct hashtab *h, void
> *key, void *datum) u32 hvalue;
>  	struct hashtab_node *prev, *cur, *newnode;
> 
> +	cond_resched();
> +
>  	if (!h || h->nel == HASHTAB_MAX_NODES)
>  		return -EINVAL;

-- 
paul moore
security and virtualization @ redhat


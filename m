Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3BJSnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:43:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab3BJSnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:43:45 -0500
Date: Sun, 10 Feb 2013 19:42:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 05/45] percpu_rwlock: Make percpu-rwlocks IRQ-safe,
	optimally
Message-ID: <20130210184209.GA3041@redhat.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073400.13822.52336.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122073400.13822.52336.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only one cosmetic nit...

On 01/22, Srivatsa S. Bhat wrote:
>
> +#define READER_PRESENT		(1UL << 16)
> +#define READER_REFCNT_MASK	(READER_PRESENT - 1)
> +
>  #define reader_uses_percpu_refcnt(pcpu_rwlock, cpu)			\
>  		(ACCESS_ONCE(per_cpu(*((pcpu_rwlock)->reader_refcnt), cpu)))
>
>  #define reader_nested_percpu(pcpu_rwlock)				\
> -			(__this_cpu_read(*((pcpu_rwlock)->reader_refcnt)) > 1)
> +	(__this_cpu_read(*((pcpu_rwlock)->reader_refcnt)) & READER_REFCNT_MASK)
>
>  #define writer_active(pcpu_rwlock)					\
>  			(__this_cpu_read(*((pcpu_rwlock)->writer_signal)))

I think this all can go to lib/percpu-rwlock.c. Nobody needs to know
these implementation details.

Oleg.


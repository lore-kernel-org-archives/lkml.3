Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaATCff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:35:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:48593 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaATCfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:35:31 -0500
Date: Sun, 19 Jan 2014 18:35:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v7 6/6] MCS Lock: add Kconfig entries to allow
 arch-specific hooks
Message-ID: <20140120023524.GN10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
 <1389917316.3138.16.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389917316.3138.16.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012002-9332-0000-0000-000002D1630B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:08:36PM -0800, Tim Chen wrote:
> This patch adds Kconfig entries to allow architectures to hook into the
> MCS lock/unlock functions in the contended case.
> 
> From: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/Kconfig                 | 3 +++
>  include/linux/mcs_spinlock.h | 8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 80bbb8c..8a2a056 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -303,6 +303,9 @@ config HAVE_CMPXCHG_LOCAL
>  config HAVE_CMPXCHG_DOUBLE
>  	bool
> 
> +config HAVE_ARCH_MCS_LOCK
> +	bool
> +
>  config ARCH_WANT_IPC_PARSE_VERSION
>  	bool
> 
> diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
> index d54bb23..d2c02ad 100644
> --- a/include/linux/mcs_spinlock.h
> +++ b/include/linux/mcs_spinlock.h
> @@ -12,6 +12,14 @@
>  #ifndef __LINUX_MCS_SPINLOCK_H
>  #define __LINUX_MCS_SPINLOCK_H
> 
> +/*
> + * An architecture may provide its own lock/unlock functions for the
> + * contended case.
> + */
> +#ifdef CONFIG_HAVE_ARCH_MCS_LOCK
> +#include <asm/mcs_spinlock.h>
> +#endif
> +
>  struct mcs_spinlock {
>  	struct mcs_spinlock *next;
>  	int locked; /* 1 if lock acquired */
> -- 
> 1.7.11.7
> 
> 


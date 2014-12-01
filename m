Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaLAOF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:05:56 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:56629 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaLAOFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:05:55 -0500
Date: Mon, 1 Dec 2014 15:05:47 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 03/30] cputime: Introduce nsecs_to_cputime64()
Message-ID: <20141201150547.3521e8fa@mschwide>
In-Reply-To: <1417199040-21044-4-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
	<1417199040-21044-4-git-send-email-fweisbec@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120114-0013-0000-0000-0000020D107A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 19:23:33 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This will be needed for the conversion of kernel stat to nsecs.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/cputime.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/cputime.h b/include/linux/cputime.h
> index f2eb2ee..a225ab9 100644
> --- a/include/linux/cputime.h
> +++ b/include/linux/cputime.h
> @@ -13,4 +13,14 @@
>  	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
>  #endif
> 
> +#ifndef nsecs_to_cputime
> +# define nsecs_to_cputime(__nsecs)	\
> +	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
> +#endif
> +
> +#ifndef nsecs_to_cputime64
> +# define nsecs_to_cputime64(__nsecs)	\
> +	((__force cputime64_t) nsecs_to_cputime(__nsecs))
> +#endif
> +
>  #endif /* __LINUX_CPUTIME_H */

For any architecture with a cputime_t better than a micro-second
the conversion to micro seconds degrades the precision a lot.

I would prefer to see the compile fail for e.g. s390 instead
of silently introducing *broken* cputime values.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


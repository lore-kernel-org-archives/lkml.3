Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3EMVQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:16:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63231 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3EMVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:16:17 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] nohz: Select VIRT_CPU_ACCOUNTING_GEN from full dynticks config
References: <1366988007-30665-1-git-send-email-fweisbec@gmail.com>
	<1366988007-30665-2-git-send-email-fweisbec@gmail.com>
Date: Mon, 13 May 2013 14:16:14 -0700
In-Reply-To: <1366988007-30665-2-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Fri, 26 Apr 2013 16:53:26 +0200")
Message-ID: <87wqr21syp.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> Turn the full dynticks passive dependency on VIRT_CPU_ACCOUNTING_GEN
> to an active one.

[...]

> @@ -329,7 +329,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
>  
>  config VIRT_CPU_ACCOUNTING_GEN
>  	bool "Full dynticks CPU time accounting"
> -	depends on HAVE_CONTEXT_TRACKING && 64BIT
> +	depends on HAVE_CONTEXT_TRACKING && 64BIT && NO_HZ_FULL
>  	select VIRT_CPU_ACCOUNTING
>  	select CONTEXT_TRACKING
>  	help

Existing 64-bit dependency is here...

> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 1ea2bba..a2ddd65 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -104,11 +104,13 @@ config NO_HZ_FULL
>  	depends on SMP
>  	# RCU_USER_QS dependency
>  	depends on HAVE_CONTEXT_TRACKING
> -	depends on VIRT_CPU_ACCOUNTING_GEN
> +	# VIRT_CPU_ACCOUNTING_GEN dependency
> +	depends on 64BIT

...and another one added here?

Is there a new 64-bit dependency in NO_HZ_FULL not covered by the one
already in VIRT_CPU_ACCOUNTING_GEN?  Or do you have reasons to be doubly
paranoid about the non 64-bit usage?  ;)

Kevin

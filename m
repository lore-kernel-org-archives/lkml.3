Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbaGRU2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:28:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:11388 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755096AbaGRU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:27:59 -0400
Date: Fri, 18 Jul 2014 16:27:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 4/4] (RFC) X86: add IPI tracepoints
Message-ID: <20140718162750.62cbf965@gandalf.local.home>
In-Reply-To: <1405660735-13408-5-git-send-email-nicolas.pitre@linaro.org>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
	<1405660735-13408-5-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 01:18:55 -0400
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index be8e1bde07..e154d176cf 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -31,6 +31,12 @@
>  #include <asm/apic.h>
>  #include <asm/nmi.h>
>  #include <asm/trace/irq_vectors.h>
> +
> +#define CREATE_TRACE_POINTS
> +#undef TRACE_INCLUDE_PATH
> +#undef TRACE_INCLUDE_FILE

I'm curious to why you added the #undefs. I wouldn't think they were
needed.

-- Steve

> +#include <trace/events/ipi.h>
> +
>  /*
>   *	Some notes on x86 processor bugs affecting SMP operation:
>   *

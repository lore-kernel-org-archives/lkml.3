Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3FNTLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:11:37 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48461 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3FNTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:11:35 -0400
Message-ID: <51BB6AE3.8030903@gmail.com>
Date: Fri, 14 Jun 2013 12:11:31 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Parisc List <linux-parisc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] fix WARNING: at kernel/cpu/idle.c:96
References: <1371236142.2726.43.camel@dabdike>
In-Reply-To: <1371236142.2726.43.camel@dabdike>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 11:55 AM, James Bottomley wrote:
>>From 48bbf44a96676ce6f520a408378730c976e9a11e Mon Sep 17 00:00:00 2001
> From: James Bottomley <JBottomley@Parallels.com>
> Date: Wed, 8 May 2013 14:05:34 -0700
> Subject: [PATCH] [PARISC] fix WARNING: at kernel/cpu/idle.c:96
>
> On PA-RISC (and presumably any other arch that doesn't implement its own
> arch_cpu_idle), we get this spurious boot warning.  The problem is that the
> way the idle task is selected initially using the weak arch_cpu_idle() in
> idle.c causes us to enter this place once with interrupts enabled.  Fix this
> by disabling interrupts in the weak arch_cpu_idle() code.

Is this changelog correct?  It looks to me like you are enabling 
interrupts down there.

David Daney


>
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>
> ---
>
> Thomas, I'm getting a bit impatient: this is a clear bug in the cpu idle
> code and we keep getting reports of this as a boot crash on parisc.  If
> you don't push it through your tree, I'll take it through the parisc
> one.
>
>
> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
> index d5585f5..0a4d11e 100644
> --- a/kernel/cpu/idle.c
> +++ b/kernel/cpu/idle.c
> @@ -58,6 +58,7 @@ void __weak arch_cpu_idle_dead(void) { }
>   void __weak arch_cpu_idle(void)
>   {
>   	cpu_idle_force_poll = 1;
> +	local_irq_enable();

Here     ^^^^^^^^^^^^^^^^


>   }
>
>   /*
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaAMLMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:12:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36978 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbaAMLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:11:56 -0500
Date: Mon, 13 Jan 2014 11:11:13 +0000
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH] arm64: fix typo in entry.S
Message-ID: <20140113111112.GC1189@mudshark.cambridge.arm.com>
References: <1389603476-10494-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389603476-10494-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 08:57:56AM +0000, Neil Zhang wrote:
> Commit 64681787 (arm64: let the core code deal with preempt_count)
> changed the code, but left the comments unchanged, fix it.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  arch/arm64/kernel/entry.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 4d2c6f3..ffce55e 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -314,7 +314,7 @@ el1_irq:
>  
>  #ifdef CONFIG_PREEMPT
>  	get_thread_info tsk
> -	ldr	w24, [tsk, #TI_PREEMPT]		// restore preempt count
> +	ldr	w24, [tsk, #TI_PREEMPT]		// get preempt count
>  	cbnz	w24, 1f				// preempt count != 0
>  	ldr	x0, [tsk, #TI_FLAGS]		// get flags
>  	tbz	x0, #TIF_NEED_RESCHED, 1f	// needs rescheduling?

Makes sense:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

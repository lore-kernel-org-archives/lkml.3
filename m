Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3IZGSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:18:10 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:35922 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3IZGSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:18:09 -0400
Date: Thu, 26 Sep 2013 08:18:05 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: fix compiler warning
Message-ID: <20130926061805.GA18123@samfundet.no>
References: <1380138601-29902-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380138601-29902-1-git-send-email-juhosg@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 25 Sep 2013 21:50:01 +0200 or thereabout, Gabor Juhos wrote:

Tuning subject to

avr32: cast syscall_return to silence compiler warning

> The patch fixes the following compiler warning:
>     CC      arch/avr32/kernel/process.o
>   arch/avr32/kernel/process.c: In function 'copy_thread':
>   arch/avr32/kernel/process.c:292: warning: assignment makes integer \
>   from pointer without a cast

Thank you for fixing.

> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
> Note: the patch is against v3.12-rc2.

Added to my for-linus branch.

> ---
>  arch/avr32/kernel/process.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
> index c273100..42a53e74 100644
> --- a/arch/avr32/kernel/process.c
> +++ b/arch/avr32/kernel/process.c
> @@ -289,7 +289,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		p->thread.cpu_context.r0 = arg;
>  		p->thread.cpu_context.r1 = usp; /* fn */
> -		p->thread.cpu_context.r2 = syscall_return;
> +		p->thread.cpu_context.r2 = (unsigned long)syscall_return;
>  		p->thread.cpu_context.pc = (unsigned long)ret_from_kernel_thread;
>  		childregs->sr = MODE_SUPERVISOR;
>  	} else {
-- 
mvh
Hans-Christian Egtvedt

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3ETHPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:15:17 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:47030 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab3ETHPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:15:15 -0400
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] arm64: kernel: compiling issue, need =?UTF-8?Q?=27EXPORT=5FSY?=
 =?UTF-8?Q?MBOL=5FGPL=28read=5Fcurrent=5Ftimer=29=27?=
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 20 May 2013 09:15:04 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Organization: ARM Ltd
In-Reply-To: <5199C725.8050102@asianux.com>
References: <5199C725.8050102@asianux.com>
Message-ID: <168084c28e8ba5124c05553e97463172@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: gang.chen@asianux.com, Catalin.Marinas@arm.com, will.deacon@arm.com, santosh.shilimkar@ti.com, tony@atomide.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013 14:48:05 +0800, Chen Gang <gang.chen@asianux.com>
wrote:
> Need 'EXPORT_SYMBOL_GPL(read_current_timer)' if build with allmodconfig.
> 
> The related error:
>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/kernel/time.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index a551f88..7fcba80 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -73,6 +73,7 @@ int read_current_timer(unsigned long *timer_value)
>  	*timer_value = arch_timer_read_counter();
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(read_current_timer);
>  
>  void __init time_init(void)
>  {

While this solves the problem, I'm not sure this is the best fix. The real
issue is with get_cycles, which is a macro around read_current_timer.

AArch32 exports it because of the number of timer implementations. On
arm64, we should be able to just return CNTVCT_EL0.

Catalin, Will, what do you think?

        M.
-- 
Fast, cheap, reliable. Pick two.

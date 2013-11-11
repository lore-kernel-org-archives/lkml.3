Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3KKK6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:58:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60854 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3KKK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:58:32 -0500
Date: Mon, 11 Nov 2013 16:29:25 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes/powerpc: Kill arch_uprobe->ainsn
Message-ID: <20131111105925.GB21356@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20131109175350.GA17412@redhat.com>
 <20131109175409.GA17437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109175409.GA17437@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111110-6688-0000-0000-0000035D324C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 06:54:09PM +0100, Oleg Nesterov wrote:
> powerpc has both arch_uprobe->insn and arch_uprobe->ainsn to
> make the generic code happy. This is no longer needed after
> the previous change, powerpc can just use "u32 insn".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/powerpc/include/asm/uprobes.h |    5 ++---
>  arch/powerpc/kernel/uprobes.c      |    2 +-
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
> index 75c6ecd..7422a99 100644
> --- a/arch/powerpc/include/asm/uprobes.h
> +++ b/arch/powerpc/include/asm/uprobes.h
> @@ -36,9 +36,8 @@ typedef ppc_opcode_t uprobe_opcode_t;
> 
>  struct arch_uprobe {
>  	union {
> -		u8	insn[MAX_UINSN_BYTES];
> -		u8	ixol[MAX_UINSN_BYTES];
> -		u32	ainsn;
> +		u32	insn;
> +		u32	ixol;
>  	};
>  };
> 
> diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
> index 59f419b..003b209 100644
> --- a/arch/powerpc/kernel/uprobes.c
> +++ b/arch/powerpc/kernel/uprobes.c
> @@ -186,7 +186,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	 * emulate_step() returns 1 if the insn was successfully emulated.
>  	 * For all other cases, we need to single-step in hardware.
>  	 */
> -	ret = emulate_step(regs, auprobe->ainsn);
> +	ret = emulate_step(regs, auprobe->insn);
>  	if (ret > 0)
>  		return true;

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Oleg.

Ananth


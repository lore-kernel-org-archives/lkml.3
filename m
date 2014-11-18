Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaKROwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:52:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60296 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaKROwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:52:33 -0500
Date: Tue, 18 Nov 2014 14:52:29 +0000
From: Will Deacon <will.deacon@arm.com>
To: David Long <dave.long@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature
Message-ID: <20141118145228.GN18842@arm.com>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
 <1416292375-29560-6-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416292375-29560-6-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Nov 18, 2014 at 06:32:55AM +0000, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Add HAVE_REGS_AND_STACK_ACCESS_API feature for arm64.

[...]

> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index d3e782a..24cc048 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -111,6 +111,8 @@ struct pt_regs {
>  	u64 syscallno;
>  };
>  
> +#define MAX_REG_OFFSET (offsetof(struct pt_regs, orig_x0))

Is orig_x0 actually useful to this API? If not, we could instead operate on
the user_pt_regs structure, and define the maximum offset in terms of sizeof
that.

> +#define ARM_cpsr	pstate
> +#define ARM_pc		pc
> +#define ARM_sp		sp
> +#define ARM_lr		regs[30]
> +#define ARM_fp		regs[29]
> +#define ARM_x28		regs[28]
> +#define ARM_x27		regs[27]

[...]

I don't think we need these #defines.

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3JGP3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:29:01 -0400
Received: from multi.imgtec.com ([194.200.65.239]:47837 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab3JGP3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:29:00 -0400
Message-ID: <5252D343.6090100@imgtec.com>
Date: Mon, 7 Oct 2013 16:29:07 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: SmartMIPS: Fix build
References: <1381158642-10598-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381158642-10598-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.31]
X-SEF-Processed: 7_3_0_01192__2013_10_07_16_28_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/13 16:10, Thierry Reding wrote:
> All CONFIG_CPU_HAS_SMARTMIPS #ifdefs have been removed from code, but
> the ACX register declaration in struct pt_regs is still protected by it,
> causing builds to fail. Remove the #ifdef protection and always declare
> the register.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   arch/mips/include/asm/ptrace.h | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
> index 7bba9da..d47bdce 100644
> --- a/arch/mips/include/asm/ptrace.h
> +++ b/arch/mips/include/asm/ptrace.h
> @@ -33,9 +33,7 @@ struct pt_regs {
>   	unsigned long cp0_status;
>   	unsigned long hi;
>   	unsigned long lo;
> -#ifdef CONFIG_CPU_HAS_SMARTMIPS
>   	unsigned long acx;
> -#endif
>   	unsigned long cp0_badvaddr;
>   	unsigned long cp0_cause;
>   	unsigned long cp0_epc;
>

Hi Thierry,

Looks good to me. Thanks!

Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>


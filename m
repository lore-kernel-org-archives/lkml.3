Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3FGXeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:34:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32976 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab3FGXeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:34:21 -0400
Message-ID: <51B26E02.8070802@cogentembedded.com>
Date: Sat, 08 Jun 2013 03:34:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 20/31] mips/kvm: Hook into TLB fault handlers.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <1370646215-6543-21-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1370646215-6543-21-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/08/2013 03:03 AM, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
>
> If the CPU is operating in guest mode when a TLB related excpetion
> occurs, give KVM a chance to do emulation.
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>   arch/mips/mm/fault.c       | 8 ++++++++
>   arch/mips/mm/tlbex-fault.S | 6 ++++++
>   2 files changed, 14 insertions(+)
>
> diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
> index 0fead53..9391da49 100644
> --- a/arch/mips/mm/fault.c
> +++ b/arch/mips/mm/fault.c
[...]
> @@ -50,6 +51,13 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs, unsigned long writ
>   	       field, regs->cp0_epc);
>   #endif
>   
> +#ifdef CONFIG_KVM_MIPSVZ
> +	if (test_tsk_thread_flag(current, TIF_GUESTMODE)) {
> +		if (mipsvz_page_fault(regs, write, address))

    Any reason not to collapse these into single *if*?

> +			return;
> +	}
> +#endif
> +
>


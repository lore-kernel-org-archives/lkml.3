Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaIZIyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:54:12 -0400
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:38527 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbaIZIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:54:09 -0400
Message-ID: <542529AF.3050601@nexus-software.ie>
Date: Fri, 26 Sep 2014 09:54:07 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Ong Boon Leong <boon.leong.ong@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] x86, setup: add __flush_tlb() for Intel Quark X1000
References: <1411705827-2522-1-git-send-email-boon.leong.ong@intel.com> <1411705827-2522-2-git-send-email-boon.leong.ong@intel.com>
In-Reply-To: <1411705827-2522-2-git-send-email-boon.leong.ong@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 41ead8d..90e0b85 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -880,6 +880,13 @@ void __init setup_arch(char **cmdline_p)
>
>   	load_cr3(swapper_pg_dir);
>   	__flush_tlb_all();
> +	/*
> +	 * Quark X1000 wrongly advertises PGE, add __flush_tlb()
> +	 * below to make sure TLB is flushed correctly in the early stage
> +	 * of setup_arch() for Quark X1000.
> +	 * X86_FEATURE_PGE flag is only setup later stage at early_cpu_init();
> +	 */
> +	__flush_tlb();
>   #else
>   	printk(KERN_INFO "Command line: %s\n", boot_command_line);
>   #endif

Sorry guys.

Just actually *read* the patch now.

If the above text works for Ingo and Henrique then it works for me too.


--
BOD



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaGXJDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:03:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50893 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaGXJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:03:07 -0400
Date: Thu, 24 Jul 2014 11:03:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 14/70] x86, microcode, core: _FROZEN Cleanup
Message-ID: <20140724090303.GC19239@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-15-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406080786-3938-15-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:58:50PM -0400, Chen, Gong wrote:
> Remove XXX_FROZEN state from x86/microcode/core.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/microcode/core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index dd9d619..27e47be 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -499,6 +499,10 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
>  		pr_debug("CPU%d removed\n", cpu);
>  		break;
>  
> +	case CPU_UP_CANCELED:
> +		/* The CPU refused to come up during a system resume */
> +		if (action & CPU_TASKS_FROZEN)
> +			microcode_fini_cpu(cpu);

Missing "break". We like to add those even if it doesn't matter in this
case.

Also, add the boilerplate

"default:
	break;"

while you're at it, please.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

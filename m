Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbaD2UfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:35:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49842 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964940AbaD2UfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:35:18 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>, kgene.kim@samsung.com,
        steve.capper@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
Subject: Re: [PATCH v4 1/7] arm64: Use pr_* instead of printk
References: <000101cf6367$c4c219f0$4e464dd0$@samsung.com>
Date: Tue, 29 Apr 2014 13:35:23 -0700
In-Reply-To: <000101cf6367$c4c219f0$4e464dd0$@samsung.com> (Jungseok Lee's
	message of "Tue, 29 Apr 2014 13:59:14 +0900")
Message-ID: <vnkwsioveuwk.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28 2014 at 09:59:14 PM, Jungseok Lee <jays.lee@samsung.com> wrote:
> This patch fixed the following checkpatch complaint as using pr_*
> instead of printk.
>
> WARNING: printk() should include KERN_ facility level
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> ---
>  arch/arm64/kernel/traps.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 7ffaddd..0484e81 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -65,7 +65,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
>  	fs = get_fs();
>  	set_fs(KERNEL_DS);
>  
> -	printk("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
> +	pr_emerg("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);

Currently this printk is being called with lvl=KERN_EMERG or lvl="". In
the case of lvl=KERN_EMERG leaving lvl in is redundant. In the case of
lvl="" this is a behavioral change (printing to a different log
level). Was this intended?

>  
>  	for (first = bottom & ~31; first < top; first += 32) {
>  		unsigned long p;
> @@ -83,7 +83,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
>  					sprintf(str + i * 9, " ????????");
>  			}
>  		}
> -		printk("%s%04lx:%s\n", lvl, first & 0xffff, str);
> +		pr_emerg("%s%04lx:%s\n", lvl, first & 0xffff, str);

Ditto

>  	}
>  
>  	set_fs(fs);
> @@ -124,7 +124,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
>  			break;
>  		}
>  	}
> -	printk("%sCode: %s\n", lvl, str);
> +	pr_emerg("%sCode: %s\n", lvl, str);

Ditto. Also called with with lvl=KERN_INFO.


Mitch

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

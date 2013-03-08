Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab3CHEXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:23:33 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58276 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760331Ab3CHEXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:23:32 -0500
Message-ID: <513967BD.9010602@hitachi.com>
Date: Fri, 08 Mar 2013 13:23:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: oskar.andero@sonymobile.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        radovan.lekanovic@sonymobile.com,
        =?UTF-8?B?77+9?= <bjorn.davidsson@sonymobile.com>
Subject: Re: [PATCH] Kprobes blacklist: Conditionally add x86-specific
 symbols
References: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/07 19:44), oskar.andero@sonymobile.com wrote:
> From: Bjorn Davidsson <bjorn.davidsson@sonymobile.com>
> 
> The kprobes blacklist contains x86-specific symbols.
> Looking for these in kallsyms takes unnecessary time
> during startup on non-X86 platform.
> Added #ifdef CONFIG_X86 around them.

Right. however, it might be better break that into
common and arch-specific lists, because there may be
other arch-specific non-probe-able functions on each
architecture...

Would you know some other black points on your platform?

Thank you,

> 
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Björn Davidsson <bjorn.davidsson@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  kernel/kprobes.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index e35be53..8c3796f 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -95,9 +95,11 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>   */
>  static struct kprobe_blackpoint kprobe_blacklist[] = {
>  	{"preempt_schedule",},
> +#ifdef CONFIG_X86
>  	{"native_get_debugreg",},
>  	{"irq_entries_start",},
>  	{"common_interrupt",},
> +#endif
>  	{"mcount",},	/* mcount can be called from everywhere */
>  	{NULL}    /* Terminator */
>  };
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



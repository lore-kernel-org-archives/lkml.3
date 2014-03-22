Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaCVBAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 21:00:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:37475 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752088AbaCVBAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 21:00:33 -0400
Date: Fri, 21 Mar 2014 21:00:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 07/26] [BUGFIX] x86: Prohibit probing on thunk
 functions and restore
Message-ID: <20140321210020.438f6e32@gandalf.local.home>
In-Reply-To: <20140305115932.22766.76074.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115932.22766.76074.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:32 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

>  	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
> diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
> index a63efd6..92d9fea 100644
> --- a/arch/x86/lib/thunk_64.S
> +++ b/arch/x86/lib/thunk_64.S
> @@ -8,6 +8,7 @@
>  #include <linux/linkage.h>
>  #include <asm/dwarf2.h>
>  #include <asm/calling.h>
> +#include <asm/asm.h>
>  
>  	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
>  	.macro THUNK name, func, put_ret_addr_in_rdi=0
> @@ -25,6 +26,7 @@
>  	call \func
>  	jmp  restore
>  	CFI_ENDPROC
> +	_ASM_NOKPROBE(\name)
>  	.endm
>  
>  #ifdef CONFIG_TRACE_IRQFLAGS
> @@ -43,3 +45,4 @@ restore:
>  	RESTORE_ARGS
>  	ret
>  	CFI_ENDPROC
> +	_ASM_NOKPROBE(restore)
> 

Does kallsyms return something for this? I'm curious to what it does.
It might find something that we didn't expect. Do you have debug code
to list out all the black listed items found at boot up?

-- Steve



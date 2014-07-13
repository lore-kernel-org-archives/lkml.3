Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaGMWjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 18:39:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37996 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGMWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 18:39:10 -0400
Message-ID: <53C30A86.8030806@hitachi.com>
Date: Mon, 14 Jul 2014 07:39:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 3.16] x86,kprobes: Don't try to resolve kprobe faults
 from userspace
References: <c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net>
In-Reply-To: <c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/12 2:27), Andy Lutomirski wrote:
> This commit:
> 
>     commit 6f6343f53d133bae516caf3d254bce37d8774625
>     Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>     Date:   Thu Apr 17 17:17:33 2014 +0900
> 
>         kprobes/x86: Call exception handlers directly from do_int3/do_debug
> 
> appears to have inadvertently dropped a check that the int3 came
> from kernel mode.  Trying to dereference addr when addr is
> user-controlled is completely bogus.

Oops, right!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you very much!

> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Changes from v1: Fixed the changelog message
> 
>  arch/x86/kernel/kprobes/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 7596df6..67e6d19 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -574,6 +574,9 @@ int kprobe_int3_handler(struct pt_regs *regs)
>  	struct kprobe *p;
>  	struct kprobe_ctlblk *kcb;
>  
> +	if (user_mode_vm(regs))
> +		return 0;
> +
>  	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
>  	/*
>  	 * We don't want to be preempted for the entire
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



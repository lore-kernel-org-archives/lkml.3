Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaFWIqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:46:12 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45015 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaFWIqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:46:10 -0400
Message-ID: <53A7E94A.3080601@hitachi.com>
Date: Mon, 23 Jun 2014 17:46:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples/kprobes: Update jprobe_example.c for do_fork()
 change
References: <1403493027-16638-1-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1403493027-16638-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/23 12:10), Michael Ellerman wrote:
> In commit e80d666 "flagday: kill pt_regs argument of do_fork()", the
> arguments to do_fork() changed.
> 
> The example code in jprobe_example.c was not updated to match, so the
> arguments inside the jprobe handler do not match reality.
> 
> Fix it by updating the arguments to match do_fork(). While we're at it
> use pr_info() for brevity, and print stack_start as well for interest.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  samples/kprobes/jprobe_example.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/samples/kprobes/jprobe_example.c b/samples/kprobes/jprobe_example.c
> index b754135..9119ac6 100644
> --- a/samples/kprobes/jprobe_example.c
> +++ b/samples/kprobes/jprobe_example.c
> @@ -24,12 +24,11 @@
>  
>  /* Proxy routine having the same arguments as actual do_fork() routine */
>  static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
> -	      struct pt_regs *regs, unsigned long stack_size,
> -	      int __user *parent_tidptr, int __user *child_tidptr)
> +	      unsigned long stack_size, int __user *parent_tidptr,
> +	      int __user *child_tidptr)
>  {
> -	printk(KERN_INFO "jprobe: clone_flags = 0x%lx, stack_size = 0x%lx,"
> -			" regs = 0x%p\n",
> -	       clone_flags, stack_size, regs);
> +	pr_info("jprobe: clone_flags = 0x%lx, stack_start = 0x%lx "
> +		"stack_size = 0x%lx\n", clone_flags, stack_start, stack_size);
>  
>  	/* Always end with a call to jprobe_return(). */
>  	jprobe_return();
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



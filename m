Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3KAN5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:57:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29885 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753326Ab3KAN5c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:57:32 -0400
Date: Fri, 1 Nov 2013 09:57:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
Message-ID: <20131101095731.299070d8@gandalf.local.home>
In-Reply-To: <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
	<20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 11:25:37 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Prohibit probing on func_ptr_is_kernel_text().
> Since the func_ptr_is_kernel_text() is called from
> notifier_call_chain() which is called from int3 handler,
> probing it may cause double int3 fault and kernel will
> reboot.
> 
> This happenes when the kernel built with CONFIG_DEBUG_NOTIFIERS=y.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/extable.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/extable.c b/kernel/extable.c
> index 832cb28..022fb25 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -129,7 +129,7 @@ int kernel_text_address(unsigned long addr)
>   * pointer is part of the kernel text, we need to do some
>   * special dereferencing first.
>   */
> -int func_ptr_is_kernel_text(void *ptr)
> +int nokprobe func_ptr_is_kernel_text(void *ptr)
>  {
>  	unsigned long addr;
>  	addr = (unsigned long) dereference_function_descriptor(ptr);
> 


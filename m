Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaDDXzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:55:32 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62141 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaDDXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <1396476619-15386-1-git-send-email-rabin@rab.in>
References: <1396476619-15386-1-git-send-email-rabin@rab.in>
Date: Fri, 4 Apr 2014 16:55:29 -0700
X-Google-Sender-Auth: cv5RucGbpeflX75SYTZ0VWPUJSs
Message-ID: <CAGXu5jL+MWvLugY=OcQzJw8TfWF4Esp34bv1S0BMKiJ20JULnQ@mail.gmail.com>
Subject: Re: [PATCH] arm: ftrace: work with CONFIG_DEBUG_SET_MODULE_RONX
From: Kees Cook <keescook@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 3:10 PM, Rabin Vincent <rabin@rab.in> wrote:
> Make ftrace work with CONFIG_DEBUG_SET_MODULE_RONX by making module text
> writable around the place where ftrace does its work, like it is done on
> x86 in the patch which introduced CONFIG_DEBUG_SET_MODULE_RONX,
> 84e1c6bb38eb ("x86: Add RO/NX protection for loadable kernel modules").
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

This works for me as well. Thanks!

Tested-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm/kernel/ftrace.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index 34e5664..70ce654 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -14,6 +14,7 @@
>
>  #include <linux/ftrace.h>
>  #include <linux/uaccess.h>
> +#include <linux/module.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/opcodes.h>
> @@ -63,6 +64,18 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
>  }
>  #endif
>
> +int ftrace_arch_code_modify_prepare(void)
> +{
> +       set_all_modules_text_rw();
> +       return 0;
> +}
> +
> +int ftrace_arch_code_modify_post_process(void)
> +{
> +       set_all_modules_text_ro();
> +       return 0;
> +}
> +
>  static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
>  {
>         return arm_gen_branch_link(pc, addr);
> --
> 1.9.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Kees Cook
Chrome OS Security

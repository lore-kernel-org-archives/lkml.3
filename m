Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaGTUtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:49:04 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34928 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaGTUtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <1405661102-11967-1-git-send-email-xerofoify@gmail.com>
References: <1405661102-11967-1-git-send-email-xerofoify@gmail.com>
Date: Sun, 20 Jul 2014 22:49:01 +0200
Message-ID: <CAA9xbM4fvo8uKrhJU8Mvp_3HQ=PcrBgq4p_JL0cy_-rX2nL_Bg@mail.gmail.com>
Subject: Re: [PATCH] ia64: Fix me add register r8
From: =?UTF-8?Q?=C3=89meric_MASCHINO?= <emeric.maschino@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Well, I'm wondering why the original author of this FIXME comment
didn't fix the issue him/herself. Can you track down who added this
comment? I fear that this simple comment was actually here to point to
something more subtle...

     Émeric

2014-07-18 7:25 GMT+02:00 Nicholas Krause <xerofoify@gmail.com>:
> The function user_stack_pointer was not returning the correct value \
> as stated by a Fix Me message before the function declaration. I
> fixed the return value to add register r8 as that register stores
> dirty pages.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/ia64/include/asm/ptrace.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/ia64/include/asm/ptrace.h b/arch/ia64/include/asm/ptrace.h
> index 8451439..eaef692 100644
> --- a/arch/ia64/include/asm/ptrace.h
> +++ b/arch/ia64/include/asm/ptrace.h
> @@ -53,8 +53,7 @@
>
>  static inline unsigned long user_stack_pointer(struct pt_regs *regs)
>  {
> -       /* FIXME: should this be bspstore + nr_dirty regs? */
> -       return regs->ar_bspstore;
> +       return regs->ar_bspstore + regs->r8;
>  }
>
>  static inline int is_syscall_success(struct pt_regs *regs)
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

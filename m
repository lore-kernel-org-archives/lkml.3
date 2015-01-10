Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbbAJWOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:14:17 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:41025 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbbAJWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:14:16 -0500
MIME-Version: 1.0
In-Reply-To: <1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com> <1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 10 Jan 2015 14:13:54 -0800
Message-ID: <CALCETrWsT75a1Mh61BCEO41CAEz1SWJTuVjkRP=60kr=21T3OQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 2:00 PM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> The values of these two constants are the same, the meaning is different.

Acked-by: Andy Lutomirski <luto@amacapital.net>

I'll make the same change to my pending entry work, and hopefully we
can avoid conflicts.

--Andy

>
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: X86 ML <x86@kernel.org>
> CC: Alexei Starovoitov <ast@plumgrid.com>
> CC: Will Drewry <wad@chromium.org>
> CC: Kees Cook <keescook@chromium.org>
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/ia32/ia32entry.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 82e8a1d..156ebca 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -179,8 +179,8 @@ sysenter_dispatch:
>  sysexit_from_sys_call:
>         andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>         /* clear IF, that popfq doesn't enable interrupts early */
> -       andl  $~0x200,EFLAGS-R11(%rsp)
> -       movl    RIP-R11(%rsp),%edx              /* User %eip */
> +       andl    $~0x200,EFLAGS-ARGOFFSET(%rsp)
> +       movl    RIP-ARGOFFSET(%rsp),%edx                /* User %eip */
>         CFI_REGISTER rip,rdx
>         RESTORE_ARGS 0,24,0,0,0,0
>         xorq    %r8,%r8
> --
> 1.8.1.4
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbbAMWLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:11:33 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:49367 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbbAMWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com> <1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Jan 2015 14:11:10 -0800
Message-ID: <CALCETrV0R+QqDXNYsJk0QeMCpCwNVmQL=H_jbRpMUApaosTkDg@mail.gmail.com>
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

Applied.

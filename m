Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbbANWaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:30:03 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:65357 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbANWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAK1hOcMZKpcLVWffv_L9DoaK5-V2qSHkm3N2=mo8wKZfEMLyWA@mail.gmail.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com> <CAK1hOcMZKpcLVWffv_L9DoaK5-V2qSHkm3N2=mo8wKZfEMLyWA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Jan 2015 14:29:39 -0800
Message-ID: <CALCETrXBKnXzhhtvv5o_jAQnShrBJ1v8jCn7dXhDdiOOcZAp+g@mail.gmail.com>
Subject: Re: [PATCH 01/11] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 2:17 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Wed, Jan 14, 2015 at 10:48 PM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>> Macros which manipulate "struct pt_regs" on stack are reworked:
>> ALLOC_PT_GPREGS_ON_STACK allocates the structure.
>> SAVE_C_REGS saves to it those registers which are clobbered by C code.
>> SAVE_EXTRA_REGS saves to it all other registers.
>> Corresponding RESTORE_* and REMOVE_PT_GPREGS_FROM_STACK macros reverse it.
>
> Andy,
>
> Please note that this patch set also needs the previously posted patch:
>
> [PATCH 3/4] x86: open-code register save/restore in trace_hardirqs thunks
>
> which is not present in your tree - otherwise arch/x86/lib/thunk_64.S
> will not compile (no SAVE_ARGS anymore).

I need to go through Linus' and everyone else's comments on that to
figure out what to do first.

--Andy

>
> --
> vda



-- 
Andy Lutomirski
AMA Capital Management, LLC

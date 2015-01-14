Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbbANWRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:17:30 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34915 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbANWR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:17:28 -0500
MIME-Version: 1.0
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 14 Jan 2015 23:17:07 +0100
Message-ID: <CAK1hOcMZKpcLVWffv_L9DoaK5-V2qSHkm3N2=mo8wKZfEMLyWA@mail.gmail.com>
Subject: Re: [PATCH 01/11] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Andy Lutomirski <luto@amacapital.net>
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

On Wed, Jan 14, 2015 at 10:48 PM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> Macros which manipulate "struct pt_regs" on stack are reworked:
> ALLOC_PT_GPREGS_ON_STACK allocates the structure.
> SAVE_C_REGS saves to it those registers which are clobbered by C code.
> SAVE_EXTRA_REGS saves to it all other registers.
> Corresponding RESTORE_* and REMOVE_PT_GPREGS_FROM_STACK macros reverse it.

Andy,

Please note that this patch set also needs the previously posted patch:

[PATCH 3/4] x86: open-code register save/restore in trace_hardirqs thunks

which is not present in your tree - otherwise arch/x86/lib/thunk_64.S
will not compile (no SAVE_ARGS anymore).

-- 
vda

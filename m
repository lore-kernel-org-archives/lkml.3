Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaFRUwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:52:05 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:46099 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaFRUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140618202748.GA9022@www.outflux.net>
References: <20140618202748.GA9022@www.outflux.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Jun 2014 13:51:39 -0700
Message-ID: <CALCETrX+3fVvLncFJmZ+4Esgt1esqinGxwK89LopLAXo=3HR0Q@mail.gmail.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under PTRACE_O_TRACESECCOMP
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        =?UTF-8?Q?Andr=C3=A9_Hentschel?= <nerv@dawncrow.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 1:27 PM, Kees Cook <keescook@chromium.org> wrote:
> An x86 tracer wanting to change the syscall uses PTRACE_SETREGS
> (stored to regs->orig_ax), and an ARM tracer uses PTRACE_SET_SYSCALL
> (stored to current_thread_info()->syscall). When this happens, the
> syscall can change across the call to secure_computing(), since it may
> block on tracer notification, and the tracer can then make changes
> to the process, before we return from secure_computing(). This
> means the code must respect the changed syscall after the
> secure_computing() call in syscall_trace_enter(). The same is true
> for tracehook_report_syscall_entry() which may also block and change
> the syscall.
>
> The x86 code handles this (it expects orig_ax to always be the
> desired syscall). In the ARM case, this means we should not be touching
> current_thread_info()->syscall after its initial assignment. All failures
> should result in a -1 syscall, though.

This looks sensible.

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbaGQW37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:29:59 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36469 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaGQW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:29:58 -0400
MIME-Version: 1.0
Date: Thu, 17 Jul 2014 15:29:57 -0700
X-Google-Sender-Auth: NgsoIT7dFzFxC9ZjdvZBTKzELf8
Message-ID: <CAGXu5jJJ7dqC-or=ZhKKj8=eA5itKX4aLRsnxmFZvwnyRcrUrw@mail.gmail.com>
Subject: MIPS seccomp and changing syscalls
From: Kees Cook <keescook@chromium.org>
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently fixed a bug in seccomp on ARM that I think may be present
in the MIPS implementation too. In arch/mips/kernel/ptrace.c
syscall_trace_enter, the syscall variable is used (and returned), but
the syscall may be changed by either secure_computing or
tracehook_report_syscall_entry (via ptracers which can block and
change the registers). (I would note that "ret" is also set but never
used, so tracehook_report_syscall_entry failures actually won't get
noticed.)

The discussion about this bug on ARM is here:
https://lkml.org/lkml/2014/6/20/439

I don't yet have a working MIPS environment to test this on, but it
feels like the same bug. (Though, for testing, what's the right way to
change syscall during PTRACE_SYSCALL? On x86 it's the orig_ax
register, on ARM it's a arch-specific ptrace function
(PTRACE_SET_SYSCALL).

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security

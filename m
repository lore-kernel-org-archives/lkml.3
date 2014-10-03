Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaJCPXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:23:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33022 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbaJCPXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:23:50 -0400
Date: Fri, 3 Oct 2014 16:23:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Deepak Saxena <dsaxena@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141003152328.GB32451@arm.com>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
 <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org>
 <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com>
 <53F69045.7010301@linaro.org>
 <20140826175128.GD23445@arm.com>
 <542BE095.3010107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542BE095.3010107@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 12:08:05PM +0100, AKASHI Takahiro wrote:
> Will,
> 
> When I was looking into syscall_trace_exit() more closely, I found
> another (big) problem.
> There are two system calls, execve() and rt_sigreturn(), which change
> 'syscallno' in pt_regs to -1 in start_thread() and restore_sigframe(),
> respectively.
> 
> Since syscallno is not valid anymore in syscall_trace_exit() for these
> system calls, we cannot create a correct syscall exit record for tracepoint
> in trace_sys_exit() (=> ftrace_syscall_exit()) and for audit in audit_syscall_exit().
> 
> This does not happen on arm because syscall numbers are kept in
> thread_info on arm.
> 
> How can we deal with this issue?

How is this handled on other architectures? x86, for example, seems to zero
orig_ax when restoring the sigcontext, but leaves it alone in start_thread.

What is the impact of this problem? AFAICT, we just miss some exits, right
(as opposed to an OOPs or the like)?

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaK1Sno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:43:44 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41782 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1Snm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:43:42 -0500
Date: Fri, 28 Nov 2014 18:43:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 0/6] arm64: add seccomp support
Message-ID: <20141128184344.GA3968@arm.com>
References: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 05:26:33AM +0000, AKASHI Takahiro wrote:
> This patch series enables secure computing (system call filtering) on arm64,
> and contains related enhancements and bug fixes.
> 
>   NOTE: This versions contain a workaround against possible BUG_ON() failure
>   at audit_syscall_exit(), but doesn't contain an extra optimization, as I
>   submitted for arm, of excluding syscall enter/exit tracing against invalid
>   system calls due to an issue that I reported in:
>        http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/292170.html
> 
> The code was tested on ARMv8 fast model with 64-bit/32-bit userspace using:
>  * libseccomp v2.1.1 with modifications for arm64, especially its "live"
>    tests: No.20, 21 and 24.
>  * modified version of Kees' seccomp test for 'changing/skipping a syscall'
>    and seccomp() system call
>  * in-house tests for 'changing/skipping a system call' by tracing with
>    ptrace(SETREGSET, NT_SYSTEM_CALL) (that is, not via seccomp filter)'
> with and without audit tracing.
> 
> 
> Changes v9 -> v10:
> * modified system_call_get() for big-endian build [1/6]
> * modified the way to check for syscall(-1) on syscall entry [2/6]

Applied, thanks.

Will

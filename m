Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaHKJYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:24:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61688 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbaHKJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:24:35 -0400
Date: Mon, 11 Aug 2014 10:24:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Deepak Saxena <dsaxena@linaro.org>, Will Drewry <wad@chromium.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Campbell <leecam@google.com>
Subject: Re: [PATCH v5 3/3] arm64: Add seccomp support
Message-ID: <20140811092409.GE15344@arm.com>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
 <1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org>
 <53D082E9.8090303@amacapital.net>
 <53D09C4F.9010104@linaro.org>
 <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
 <53D2255C.9050006@linaro.org>
 <CAGXu5jJL=zXuSRNomGrB09kqpUhEpkuxDH18JN4NRbWocMw4xg@mail.gmail.com>
 <53E47DCE.4080902@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E47DCE.4080902@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 08:35:42AM +0100, AKASHI Takahiro wrote:
> On 08/06/2014 12:08 AM, Kees Cook wrote:
> > On Fri, Jul 25, 2014 at 2:37 AM, AKASHI Takahiro
> > <takahiro.akashi@linaro.org> wrote:
> >> I found a bug in my current patch (v5). When 32-bit tracer skips a system call,
> >> we should not update syscallno from x8 since syscallno is re-written directly
> >> via ptrace(PTRACE_SET_SYSCALL).
> >
> > Ah, yes. Will aarch64 have a PTRACE_SET_SYSCALL option, or is this
> > strictly a 32-bit vs 64-bit issue?
> 
> As discussed in a few weeks ago, aarch64 won't support PTRACE_SET_SYSCALL.

Well, I don't think anything was set in stone. If you have a compelling
reason why adding the new request gives you something over setting w8
directly, then we can extend ptrace.

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaKLLAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:00:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56701 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaKLLAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:00:52 -0500
Date: Wed, 12 Nov 2014 11:00:47 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Message-ID: <20141112110047.GB26437@arm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
 <20141107140405.GA30156@redhat.com>
 <54633A69.6090202@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54633A69.6090202@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:46:01AM +0000, AKASHI Takahiro wrote:
> On 11/07/2014 11:04 PM, Oleg Nesterov wrote:
> > To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
> > is very much arch-dependant (but most probably trivial) means that this  code
> > should live in arch_ptrace().
> 
> Thinking of Oleg's comment above, it doesn't make sense neither to define generic
> NT_SYSTEM_CALL (user_regset) in uapi/linux/elf.h and implement it in ptrace_regset()
> in kernel/ptrace.c with arch-defined syscall_(g)set_nr().
> 
> Since we should have the same interface on arm and arm64, we'd better implement
> ptrace(PTRACE_SET_SYSCALL) locally on arm64 for now (as I originally submitted).

I think the regset approach is cleaner. We already do something similar for
TLS. That would be implemented under arch/arm64/ with it's own NT type.

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaB1Uqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:46:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaB1Uqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:46:39 -0500
Date: Fri, 28 Feb 2014 15:45:57 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, viro@zeniv.linux.org.uk,
        eparis@redhat.com, Catalin.Marinas@arm.com, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH v6 2/2] arm64: audit: Add audit hook in
 ptrace/syscall_trace
Message-ID: <20140228204557.GJ16640@madcap2.tricolour.ca>
References: <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564635-3921-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564635-3921-3-git-send-email-takahiro.akashi@linaro.org>
 <20140228161558.GE29546@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228161558.GE29546@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/28, Will Deacon wrote:
> On Fri, Feb 28, 2014 at 05:17:15AM +0000, AKASHI Takahiro wrote:
> > This patch adds auditing functions on entry to or exit from
> > every system call invocation.
> > 
> > Acked-by: Richard Guy Briggs <rgb@redhat.com>
> > Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> > ---
> >  arch/arm64/kernel/ptrace.c |   54 ++++++++++++++++++++++++++------------------
> >  1 file changed, 32 insertions(+), 22 deletions(-)
> 
> I think you need to do something like I did for arch/arm/, where we have
> separate trace functions for entry/exit to make sure that we invoke the
> various helpers in the correct order (for example, you want to invoke all
> the debug stuff *first* on entry, but *last* on exit).

I'd have to agree.  I've just had my head deep in audit_syscall_entry()
and syscall_get_arch to clean them up.  Since current is only ever fed
to syscall_get_arch() and regs is never used by syscall_get_arch(), I'm
looking at dropping both from the syscall_get_arch() args list, but
leave syscall_get_arch() as you have it for now.

> Will

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

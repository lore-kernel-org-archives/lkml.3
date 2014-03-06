Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbaCFCzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:55:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbaCFCzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:55:54 -0500
Date: Wed, 5 Mar 2014 21:55:11 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, viro@zeniv.linux.org.uk,
        eparis@redhat.com, Catalin.Marinas@arm.com, dsaxena@linaro.org,
        arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH v6 2/2] arm64: audit: Add audit hook in
 ptrace/syscall_trace
Message-ID: <20140306025511.GZ16640@madcap2.tricolour.ca>
References: <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564635-3921-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564635-3921-3-git-send-email-takahiro.akashi@linaro.org>
 <20140228161558.GE29546@mudshark.cambridge.arm.com>
 <5317D90B.3020606@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5317D90B.3020606@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/06, AKASHI Takahiro wrote:
> On 03/01/2014 01:15 AM, Will Deacon wrote:
> >On Fri, Feb 28, 2014 at 05:17:15AM +0000, AKASHI Takahiro wrote:
> >>This patch adds auditing functions on entry to or exit from
> >>every system call invocation.
> >>
> >>Acked-by: Richard Guy Briggs <rgb@redhat.com>
> >>Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> >>---
> >>  arch/arm64/kernel/ptrace.c |   54 ++++++++++++++++++++++++++------------------
> >>  1 file changed, 32 insertions(+), 22 deletions(-)
> >
> >I think you need to do something like I did for arch/arm/, where we have
> >separate trace functions for entry/exit  to make sure that we invoke the
> >various helpers in the correct order (for example, you want to invoke all
> >the debug stuff *first* on entry, but *last* on exit).
> >
> >Will
> 
> If you mean syscall_trace_enter()/exit(), I will follow your suggestion
> for readability.

It isn't so much a question of readability, but rather correctness,
undoing operations in the opposite order on exit that they were done on
entry.

> -Takahiro AKASHI

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

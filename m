Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3FYIpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:45:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56669 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752559Ab3FYIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:45:45 -0400
Date: Tue, 25 Jun 2013 09:45:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 09/32] arm64: delete __cpuinit usage from all users
Message-ID: <20130625084539.GA2939@arm.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-10-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372102237-8757-10-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 08:30:14PM +0100, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> Note that some harmless section mismatch warnings may result, since
> notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
> are flagged as __cpuinit  -- so if we remove the __cpuinit from
> arch specific callers, we will also get section mismatch warnings.
> As an intermediate step, we intend to turn the linux/init.h cpuinit
> content into no-ops as early as possible, since that will get rid
> of these warnings.  In any case, they are temporary and harmless.
> 
> This removes all the arch/arm64 uses of the __cpuinit macros from
> all C files.  Currently arm64 does not have any __CPUINIT used in
> assembly files.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

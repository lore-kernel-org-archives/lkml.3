Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3DPIr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:47:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46319 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab3DPIrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:47:24 -0400
Date: Tue, 16 Apr 2013 09:46:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] ptrace/arm: Revert "hw_breakpoints: Fix racy access
 to ptrace breakpoints"
Message-ID: <20130416084624.GB30756@mudshark.cambridge.arm.com>
References: <20130414160501.GA7612@redhat.com>
 <20130414160534.GA7650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160534.GA7650@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 05:05:34PM +0100, Oleg Nesterov wrote:
> This reverts commit bf0b8f4b55e591ba417c2dbaff42769e1fc773b0.
> 
> The patch was fine but we can no longer race with SIGKILL after
> 9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
> with SIGKILL", the __TASK_TRACED tracee can't be woken up and
> ->ptrace_bps[] can't go away.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/kernel/ptrace.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)

Looks fine to me. Seems as though I missed arch/arm64/, so nothing to change
there.

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
